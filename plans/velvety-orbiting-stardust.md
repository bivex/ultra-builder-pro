# Trading-System-V2 统一架构改造计划

## 一、问题总结

### 1.1 数据库分裂
- **现状**：8个模块直接导入 SQLite (`from trading_system.database.db import get_database`)
- **目标**：统一使用 TimescaleDB
- **缺口**：`timescale_db.py` 缺少约30个方法（因子/假设/订单/持仓/策略等）

### 1.2 因子持久化不完整
- **现状**：RDAgentService 只保存因子代码预览（前200字符）
- **目标**：完整因子代码 + 版本追踪 + 血缘关系
- **缺口**：FactorRecord 模型缺少版本和血缘字段

### 1.3 数据路径分裂
- **现状**：TimescaleDB 和 Qlib bin 文件两条并行路径
- **目标**：TimescaleDB → Qlib 单一数据流
- **缺口**：需要自动化同步或直接Provider

### 1.4 因子服务分散
- **现状**：FactorService + RDAgentService 各自独立
- **目标**：统一因子仓库入口
- **缺口**：需要 FactorRepository 抽象层

---

## 二、推荐方案：渐进式迁移 + 架构增强

### Phase 1: TimescaleDB 功能对齐（优先级：最高）

**目标**：补全 TimescaleDB 缺失方法，达到与 SQLite 功能对等

**需要添加的方法**（约30个）：

```python
# 因子记录 (参考 db.py 1500-1622行)
save_factor_record(record) -> str
get_factor_record(factor_id) -> Optional[FactorRecord]
list_factor_records(category, is_valid, ai_only, templates_only) -> list
delete_factor_record(factor_id) -> bool

# 假设记录 (参考 db.py 1624-1717行)
save_hypothesis_record(record) -> str
get_hypothesis_record(hypothesis_id) -> Optional
list_hypothesis_records(status) -> list

# 订单记录 (参考 db.py 1719-1870行)
save_order_record(record) -> str
get_order_record(order_id) -> Optional
list_order_records(...) -> list
update_order_status(...) -> bool

# 持仓记录 (参考 db.py 1873-2006行)
save_position_record(record) -> str
list_position_records(...) -> list
close_position(position_id, realized_pnl) -> bool

# 策略记录 (参考 db.py 2008-2125行)
save_strategy_record(record) -> str
list_strategy_records(...) -> list
update_strategy_status(strategy_id, status) -> bool

# 配置相关
get_all_api_configs() -> list
delete_exchange_config(key_id) -> bool
```

**关键文件**：
- `/src/trading_system/database/timescale_db.py` - 添加方法
- `/src/trading_system/database/db.py` - 参考实现

**工作量**：8-12小时

---

### Phase 2: 导入路径统一

**目标**：修正8个模块的错误导入路径

**需要修改的模块**：
| 文件 | 修改内容 |
|------|---------|
| `services/factor_service.py:16` | `from trading_system.database.db` → `from trading_system.database` |
| `services/rdagent_service.py:25` | 同上 |
| `api/routers/backtest.py:17` | 同上 |
| `api/routers/trading.py:12` | 同上 + 重构直接SQL调用 |
| `api/routers/strategies.py:10` | 同上 |
| `api/routers/data_pipeline.py:20` | 同上 |
| `api/routers/config.py:21` | 同上 |
| `data_pipeline/extended_collector.py:23` | 同上 |

**特殊处理 - trading.py**：
```python
# 当前 (直接SQL)
conn = _db._get_connection()
cursor.execute("DELETE FROM exchange_configs WHERE id = ?", (key_id,))

# 改为
deleted = _db.delete_exchange_config(key_id)
```

**工作量**：4-6小时

---

### Phase 3: 因子模型增强

**目标**：扩展 FactorRecord 支持版本追踪和血缘关系

**模型增强**：
```python
@dataclass
class FactorRecord:
    # 现有字段...

    # 新增：血缘关系
    parent_factor_id: Optional[str] = None
    source_task_id: Optional[str] = None      # RD-Agent task_id
    evolution_generation: int = 0             # 进化代数

    # 新增：版本控制
    version: str = "1.0.0"
    code_hash: str = ""
```

**TimescaleDB 表结构增强**：
```sql
ALTER TABLE factor_records ADD COLUMN IF NOT EXISTS parent_factor_id TEXT;
ALTER TABLE factor_records ADD COLUMN IF NOT EXISTS source_task_id TEXT;
ALTER TABLE factor_records ADD COLUMN IF NOT EXISTS evolution_generation INTEGER DEFAULT 0;
ALTER TABLE factor_records ADD COLUMN IF NOT EXISTS version TEXT DEFAULT '1.0.0';
ALTER TABLE factor_records ADD COLUMN IF NOT EXISTS code_hash TEXT;
```

**关键文件**：
- `/src/trading_system/database/models.py`
- `/src/trading_system/database/timescale_db.py`

**工作量**：4小时

---

### Phase 4: RD-Agent 因子完整持久化

**目标**：RD-Agent 循环结果完整保存到 factor_records

**修改 rdagent_service.py**：
```python
def _extract_loop_results(self, loop_type: str, task_id: str) -> dict:
    # 现在只保存预览
    "preview": content[:200] + "..."

    # 改为保存完整代码
    factor_record = FactorRecord(
        factor_id=f"rdagent_{task_id}_{idx}",
        name=factor_name,
        code=full_code,           # 完整代码
        code_hash=md5(full_code),
        source_task_id=task_id,
        ai_generated=True,
    )
    self._db.save_factor_record(factor_record)
```

**关键文件**：
- `/src/trading_system/services/rdagent_service.py`

**工作量**：4小时

---

### Phase 5: 统一数据Provider

**目标**：创建 TimescaleDataProvider 供 Qlib/RD-Agent 使用

**新建文件** `src/trading_system/qlib_adapter/timescale_provider.py`：
```python
class TimescaleDataProvider:
    """从 TimescaleDB 直接提供数据"""

    UNIFIED_QLIB_PATH = Path.home() / ".qlib" / "trading_system" / "crypto"

    def get_ohlcv_dataframe(self, symbols, start, end) -> pd.DataFrame:
        """获取 OHLCV DataFrame (MultiIndex)"""

    def sync_to_qlib_format(self, symbols) -> bool:
        """同步 TimescaleDB → Qlib bin 格式"""
```

**修改 QlibAdapter**：
```python
def get_crypto_provider(self):
    from .timescale_provider import TimescaleDataProvider
    return TimescaleDataProvider()
```

**工作量**：6小时

---

### Phase 6: 数据迁移与清理

**目标**：迁移 SQLite 数据，废弃 db.py

**迁移脚本增强** `scripts/migrate_sqlite_to_timescale.py`：
- 添加 factor_records 迁移
- 添加 hypothesis_records 迁移
- 添加 order/position/strategy 迁移
- 验证数据完整性

**清理**：
- 在 `db.py` 添加 `@deprecated` 装饰器
- 更新文档标注 SQLite 为 legacy

**工作量**：4小时

---

## 三、关键文件清单

| 文件 | 操作 | 优先级 |
|------|------|--------|
| `database/timescale_db.py` | 添加30个方法 | P0 |
| `database/models.py` | 增强 FactorRecord | P1 |
| `services/factor_service.py` | 修改导入 | P1 |
| `services/rdagent_service.py` | 修改导入 + 完整持久化 | P1 |
| `api/routers/trading.py` | 修改导入 + 重构SQL | P1 |
| `api/routers/*.py` (其他5个) | 修改导入 | P2 |
| `qlib_adapter/timescale_provider.py` | 新建 | P2 |
| `scripts/migrate_sqlite_to_timescale.py` | 扩展 | P3 |
| `database/db.py` | 标记 deprecated | P3 |

---

## 四、总工作量估计

| Phase | 描述 | 工时 |
|-------|------|------|
| 1 | TimescaleDB 功能对齐 | 8-12h |
| 2 | 导入路径统一 | 4-6h |
| 3 | 因子模型增强 | 4h |
| 4 | RD-Agent 完整持久化 | 4h |
| 5 | 统一数据Provider | 6h |
| 6 | 数据迁移与清理 | 4h |

**总计**：30-36小时（约4-5个工作日）

---

## 五、确认决策

| 决策点 | 选择 |
|--------|------|
| SQLite 处理 | **完全删除** - 删除 db.py |
| Qlib 数据同步 | **自动化 bin 同步** - 定时任务自动转换 |
| 因子版本控制 | **完整血缘** - 版本号 + 父因子链 + source_task_id + 修改历史 |
| 实施节奏 | **连续完成** - 一次性完成全部6个Phase |

---

## 六、最终实施计划

### 完整血缘因子模型

```python
@dataclass
class FactorRecord:
    # 基本信息
    factor_id: str
    name: str
    description: str
    category: str
    formulation: str
    code: str                               # 完整代码

    # 验证状态
    is_valid: bool = False
    validation_metrics: Optional[str] = None

    # 来源追踪
    source: str = "manual"                  # template/llm/rdagent/manual
    ai_generated: bool = False
    ai_rationale: Optional[str] = None

    # 完整血缘（新增）
    parent_factor_id: Optional[str] = None  # 父因子 ID
    source_task_id: Optional[str] = None    # RD-Agent task_id
    hypothesis_id: Optional[str] = None
    evolution_generation: int = 0           # 进化代数

    # 版本控制（新增）
    version: str = "1.0.0"                  # 语义版本号
    code_hash: str = ""                     # MD5 哈希
    version_history: Optional[str] = None   # JSON: [{version, created_at, changes}]

    # 时间戳
    created_at: datetime
    updated_at: datetime
```

### 自动化 Qlib 同步服务

创建 `src/trading_system/data_pipeline/qlib_sync.py`:

```python
class QlibSyncService:
    """自动同步 TimescaleDB → Qlib bin 格式"""

    UNIFIED_QLIB_PATH = Path.home() / ".qlib" / "trading_system" / "crypto"

    async def sync_all_symbols(self) -> dict:
        """同步所有交易对数据到 Qlib 格式"""

    async def schedule_sync(self, interval_hours: int = 24):
        """定时同步任务"""

    def get_sync_status(self) -> dict:
        """获取同步状态"""
```

### 删除 SQLite 步骤

1. Phase 1 完成后验证 TimescaleDB 功能完整
2. Phase 2 修改所有导入路径
3. Phase 5 完成数据迁移后
4. Phase 6 删除 `database/db.py` 文件

---

## 七、执行顺序

```
Day 1-2: Phase 1 - TimescaleDB 功能对齐 (8-12h)
         └─ 添加约30个缺失方法

Day 2:   Phase 2 - 导入路径统一 (4-6h)
         └─ 修正8个模块导入

Day 3:   Phase 3 - 因子模型增强 (4h)
         └─ 完整血缘字段

Day 3-4: Phase 4 - RD-Agent 完整持久化 (4h)
         └─ 保存完整因子代码

Day 4:   Phase 5 - 自动化 Qlib 同步 (6h)
         └─ 创建同步服务

Day 5:   Phase 6 - 数据迁移与清理 (4h)
         └─ 迁移数据 + 删除 db.py
```

**总计**: 30-36小时 / 5个工作日

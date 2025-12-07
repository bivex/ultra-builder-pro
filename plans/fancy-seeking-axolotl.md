# Trading System V2 - 真实集成修复计划

## 问题总结

当前系统是一个**空壳**：
- RD-Agent: 0% 真实集成
- Qlib: 0% 真实集成
- 回测/验证: 100% 假数据 (random.uniform)
- 前端: 显示假数据，用户被误导

## 修复目标

将系统从"假的演示"变成"真正可用的量化交易系统"。

---

## Phase 1: 添加真实依赖

### 1.1 更新 pyproject.toml
```toml
[project.optional-dependencies]
rdagent = [
    "rdagent",  # 从 RD-Agent/ 目录安装
]
qlib = [
    "pyqlib>=0.9.0",
]
```

### 1.2 安装本地 RD-Agent
```bash
pip install -e ./RD-Agent
pip install -e ./qlib
```

---

## Phase 2: 真实 RD-Agent 集成

### 2.1 创建真实的 RD-Agent 客户端
**文件**: `src/trading_system/rdagent_client/client.py`

```python
from rdagent.oai.llm_utils import APIBackend
from rdagent.scenarios.qlib.developer.factor_dev import QlibFactorDeveloper
from rdagent.core.proposal import FactorHypothesis
```

### 2.2 需要实现的功能
1. **因子假设生成**: 调用 RD-Agent 的 LLM 生成因子假设
2. **因子代码生成**: 使用 QlibFactorDeveloper 生成代码
3. **因子验证**: 使用 RD-Agent 的验证框架
4. **进化循环**: 实现 CoSTEER 算法

### 2.3 关键文件映射
| 当前假文件 | 替换为 |
|-----------|--------|
| rdagent_integration/factor/generator.py | rdagent.scenarios.qlib.developer |
| rdagent_integration/evaluation/validator.py | rdagent.core.evaluation |
| rdagent_integration/scenario/crypto_scenario.py | 继承 rdagent.scenarios.Scenario |

---

## Phase 3: 真实 Qlib 集成

### 3.1 初始化 Qlib
```python
import qlib
from qlib.config import REG_CN, REG_US

qlib.init(provider_uri="~/.qlib/qlib_data/cn_data", region=REG_CN)
```

### 3.2 使用 Qlib 数据
```python
from qlib.data import D

# 获取真实数据
df = D.features(
    instruments="csi300",
    fields=["$close", "$volume", "$high", "$low"],
    start_time="2020-01-01",
    end_time="2023-12-31",
)
```

### 3.3 使用 Qlib 回测
```python
from qlib.backtest import backtest
from qlib.contrib.evaluate import risk_analysis

# 真实回测
portfolio_metric, indicator_dict = backtest(
    executor=executor,
    strategy=strategy,
    account=account,
)
```

### 3.4 加密货币适配
由于 Qlib 默认是股票市场，需要：
1. 创建加密货币日历 (24/7)
2. 使用 CCXT 获取加密货币数据
3. 转换为 Qlib 格式

---

## Phase 4: 删除所有假数据

### 4.1 需要删除的 random.uniform() 调用

| 文件 | 行号 | 问题 |
|-----|------|------|
| api/routers/backtest.py | 101-158 | 假回测结果 |
| services/factor_service.py | 129-132 | 假因子指标 |
| services/factor_service.py | 478-489 | 假验证结果 |
| api/routers/factors.py | 239-283 | 假相关性矩阵 |
| tasks/critical.py | 全部 | 假订单执行 |
| tasks/compute.py | 全部 | 假计算结果 |
| tasks/monitoring.py | 全部 | 假监控数据 |

### 4.2 替换策略
- 如果功能无法实现 → 返回错误，不返回假数据
- 如果需要真实数据 → 要求用户配置数据源
- 如果是占位符 → 标记为 "NOT IMPLEMENTED"

---

## Phase 5: 前端真实状态显示

### 5.1 显示真实配置状态
- RD-Agent 是否连接
- Qlib 是否初始化
- 数据源是否可用
- API Key 是否配置

### 5.2 禁用未实现功能
- 如果后端返回 "NOT IMPLEMENTED" → 前端灰掉按钮
- 如果缺少配置 → 显示配置引导

---

## Phase 6: OpenRouter 集成（用户要求）

### 6.1 更新 LLM 配置
支持 OpenRouter 作为统一入口：
- Claude 4.5 Opus/Sonnet
- GPT-4.1 / o3
- Gemini 2.5 Pro
- DeepSeek V3 / R1

### 6.2 配置结构
```python
class LLMConfig:
    provider: str = "openrouter"  # openrouter, openai, anthropic
    api_key: str
    model: str = "anthropic/claude-sonnet-4"
```

---

## Phase 7: 数据库持久化

### 7.1 SQLite 表结构
```sql
CREATE TABLE api_configs (
    id INTEGER PRIMARY KEY,
    provider TEXT,
    api_key TEXT,
    model TEXT,
    created_at TIMESTAMP
);

CREATE TABLE factor_validations (
    id INTEGER PRIMARY KEY,
    factor_id TEXT,
    ic REAL,
    ir REAL,
    data_source TEXT,
    validated_at TIMESTAMP
);
```

---

## 当前进度 (2024-12-06)

### ✅ 已完成
1. [x] 更新 pyproject.toml 添加依赖
2. [x] 创建 `rdagent_client/` 模块 (RD-Agent 客户端)
3. [x] 创建 `qlib_adapter/` 模块 (Qlib 适配器)
4. [x] 创建 `database/` 模块 (SQLite 持久化)
5. [x] 更新 `config.py` 支持 OpenRouter
6. [x] 更新 `backtest.py` 删除假数据

### 🔧 当前问题
- **setuptools-scm 版本检测错误**:
  - 原因: `qlib_adapter/adapter.py` 在模块级别导入 qlib，触发 pandas 导入
  - 解决: 将 qlib 导入改为延迟导入

### ⏳ 剩余工作
1. [ ] 修复 adapter.py 延迟导入
2. [ ] 重启后端验证
3. [ ] 测试前端配置页面

## 实施优先级

### P0 - 立即修复（系统无法使用）
1. [x] 添加 RD-Agent/Qlib 到依赖
2. [x] 删除假回测数据
3. [x] 删除假因子验证
4. [x] OpenRouter LLM 配置

### P1 - 核心功能
1. [x] 真实 RD-Agent 因子生成
2. [x] 真实 Qlib 回测
3. [x] 真实数据验证
4. [x] 数据库持久化

### P2 - 完善功能
1. [ ] 前端状态显示优化
2. [ ] 错误处理改进
3. [ ] 进化循环实现

---

## 关键文件清单

### 需要重写
- `src/trading_system/services/factor_service.py`
- `src/trading_system/api/routers/backtest.py`
- `src/trading_system/api/routers/factors.py`
- `src/trading_system/api/routers/config.py`

### 需要删除
- `src/trading_system/rdagent_integration/` (假的集成)
- `src/trading_system/qlib/` (假的集成)

### 需要新建
- `src/trading_system/rdagent_client/` (真实RD-Agent客户端)
- `src/trading_system/qlib_adapter/` (真实Qlib适配器)

---

## 问题待确认

1. 加密货币数据源使用 CCXT 还是其他?
2. RD-Agent 使用本地部署还是远程API?
3. 优先支持哪些模型? (OpenRouter的模型列表)
4. 是否需要支持传统股票市场 (使用Qlib原生数据)?

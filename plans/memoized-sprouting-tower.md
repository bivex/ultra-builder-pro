# PP 页面迁移计划

## 概述
将源项目 (`/Users/rocky243/paimon-yield- protocol/frontend`) 的 Dashboard 功能迁移到当前项目的 PP 页面，转换 Tailwind CSS 为 MUI，并移植相关 API。

## 源项目技术栈
- Tailwind CSS + Lucide Icons
- framer-motion 动画
- wagmi v2 + Reown AppKit
- ERC4626 Vault 合约模式

## 目标项目技术栈
- Material-UI (MUI) v5
- MUI Icons
- wagmi v2 + Reown AppKit (已配置)

---

## 迁移步骤

### 阶段 1: 合约配置迁移

**任务 1.1: 添加合约地址配置**
- 文件: `src/config/contracts.ts` (新建)
- 内容: pngyVault 地址、USDT 地址
- 来源: `lib/wagmi/config.ts`

**任务 1.2: 添加合约 ABI**
- 文件: `src/lib/contracts/abis.ts` (新建)
- 内容: PNGY_VAULT_ABI, ERC20_ABI
- 来源: `lib/contracts/abis.ts`

---

### 阶段 2: API 路由迁移

**任务 2.1: 迁移 NAV 历史 API**
- 文件: `src/app/api/netvalue/route.ts` (新建)
- 功能: 获取 NAV 历史数据，支持 mock 数据回退
- 来源: `app/api/netvalue/route.ts`

**任务 2.2: 迁移资产详情 API**
- 文件: `src/app/api/assets/details/route.ts` (新建)
- 功能: 获取资产配置数据，支持 mock 数据回退
- 来源: `app/api/assets/details/route.ts`

---

### 阶段 3: 核心组件迁移 (Tailwind → MUI)

**任务 3.1: 创建 PP Dashboard 主容器**
- 文件: `src/components/pp/PPDashboard.tsx` (新建)
- 功能: Dashboard 布局，包含 Fund Overview、Asset Allocation、My Position、Actions
- 转换: Tailwind grid → MUI Grid2, Card 组件
- 来源: `components/Dashboard.tsx`

**任务 3.2: 创建资产配置组件**
- 文件: `src/components/pp/AssetAllocation.tsx` (新建)
- 功能: 饼图、投资流动画、资产表格
- 转换: Tailwind → MUI sx, Lucide → MUI Icons
- 注意: framer-motion 动画保留或简化
- 来源: `components/AssetAllocation.tsx`

**任务 3.3: 创建 NAV 图表组件**
- 文件: `src/components/pp/NavChart.tsx` (新建)
- 功能: NAV 历史折线图
- 依赖: recharts (需检查是否已安装)
- 来源: `components/NavChart.tsx`

**任务 3.4: 创建存款表单组件**
- 文件: `src/components/pp/DepositForm.tsx` (新建)
- 功能: USDT 授权、存款流程
- 转换: Tailwind → MUI TextField, Button, Alert
- 来源: `components/DepositForm.tsx`

**任务 3.5: 创建取款表单组件**
- 文件: `src/components/pp/WithdrawForm.tsx` (新建)
- 功能: T+1 取款队列、取款流程
- 转换: Tailwind → MUI 组件
- 来源: `components/WithdrawForm.tsx`

---

### 阶段 4: Hooks 和工具函数

**任务 4.1: 创建 useVault Hook**
- 文件: `src/hooks/useVault.ts` (新建)
- 功能: Vault 交互 (deposit, withdraw, approve)
- 来源: `components/DepositForm.tsx`, `components/WithdrawForm.tsx` 中的合约调用逻辑

**任务 4.2: 创建 usePPData Hook**
- 文件: `src/hooks/usePPData.ts` (新建)
- 功能: 获取 NAV、资产配置数据
- API 调用: `/api/netvalue`, `/api/assets/details`

---

### 阶段 5: 页面集成

**任务 5.1: 更新 PP 页面**
- 文件: `src/app/pp/page.tsx` (修改)
- 变更: 替换 ComingSoon 为 PPDashboard
- 添加: WalletConnect 检查逻辑

---

## 依赖检查

需要验证/安装的依赖:
- [ ] recharts (NAV 图表)
- [ ] framer-motion (动画，可选)
- [x] wagmi (已有)
- [x] @mui/material (已有)

---

## 文件清单

### 新建文件 (11 个)
1. `src/config/contracts.ts`
2. `src/lib/contracts/abis.ts`
3. `src/app/api/netvalue/route.ts`
4. `src/app/api/assets/details/route.ts`
5. `src/components/pp/PPDashboard.tsx`
6. `src/components/pp/AssetAllocation.tsx`
7. `src/components/pp/NavChart.tsx`
8. `src/components/pp/DepositForm.tsx`
9. `src/components/pp/WithdrawForm.tsx`
10. `src/hooks/useVault.ts`
11. `src/hooks/usePPData.ts`

### 修改文件 (1 个)
1. `src/app/pp/page.tsx`

---

## 预估工作量

- 阶段 1 (合约配置): 2 个文件
- 阶段 2 (API 路由): 2 个文件
- 阶段 3 (核心组件): 5 个文件 (最耗时，需要 Tailwind → MUI 转换)
- 阶段 4 (Hooks): 2 个文件
- 阶段 5 (集成): 1 个文件

总计: 12 个文件变更

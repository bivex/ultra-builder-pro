# SSR 完整解决方案 - 基于官方文档 (更新版)

## 当前状态

**已实现**:
- ✅ 页面返回 HTTP 200，正常渲染
- ✅ `cookieStorage` 已配置，状态可持久化
- ⚠️ 服务器日志仍有 `indexedDB is not defined` 错误（不影响页面显示）

## 问题根因分析

`indexedDB` 错误发生原因：
1. `providers/index.tsx` 导入 `config` from `@/config/wagmi`
2. `wagmi.ts` 中的 `getDefaultConfig` 在模块加载时立即执行
3. RainbowKit 的 `getDefaultConfig` 会初始化 WalletConnect connectors
4. WalletConnect connectors 尝试访问 `indexedDB`（浏览器 API）
5. 即使组件是 Client Component，Next.js SSR 仍会预渲染导致模块加载

## 最终解决方案 - 完全避免 SSR 错误

根据 Wagmi 官方文档和实际测试，最彻底的解决方案是：**将所有 Web3 相关代码完全隔离到客户端**。

### 核心原理

Wagmi 官方推荐使用 `getConfig()` 函数 + `useState(() => getConfig())` 模式延迟初始化。但 RainbowKit 的 `getDefaultConfig` 会在模块加载时初始化 connectors，导致 SSR 错误。

**解决方案**：将 `cookieToInitialState` 调用移入动态导入的 Client Component，确保所有 wagmi/rainbowkit 代码只在客户端执行。

### 步骤 1: Wagmi Config - 使用 getConfig 函数

**文件**: `src/config/wagmi.ts`

```typescript
import { getDefaultConfig } from '@rainbow-me/rainbowkit';
import { arbitrum, arbitrumSepolia, base, baseSepolia } from 'wagmi/chains';
import { http, cookieStorage, createStorage } from 'wagmi';

// 使用函数延迟初始化，避免模块加载时执行
export function getConfig() {
  return getDefaultConfig({
    appName: 'LF Protocol',
    projectId: process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID || 'YOUR_PROJECT_ID',
    chains: [
      arbitrum,
      base,
      ...(process.env.NODE_ENV === 'development' ? [arbitrumSepolia, baseSepolia] : []),
    ],
    transports: {
      [arbitrum.id]: http(process.env.NEXT_PUBLIC_ARBITRUM_RPC_URL),
      [base.id]: http(process.env.NEXT_PUBLIC_BASE_RPC_URL),
      [arbitrumSepolia.id]: http(process.env.NEXT_PUBLIC_ARBITRUM_SEPOLIA_RPC_URL),
      [baseSepolia.id]: http(process.env.NEXT_PUBLIC_BASE_SEPOLIA_RPC_URL),
    },
    ssr: true,
    storage: createStorage({
      storage: cookieStorage,
    }),
  });
}
```

### 步骤 2: Web3Provider - 内部初始化 config

**文件**: `src/providers/Web3Provider.tsx`

```typescript
'use client';

import { useState } from 'react';
import { RainbowKitProvider, darkTheme, lightTheme } from '@rainbow-me/rainbowkit';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { WagmiProvider, cookieToInitialState } from 'wagmi';
import { getConfig } from '@/config/wagmi';

import '@rainbow-me/rainbowkit/styles.css';

interface Web3ProviderProps {
  children: React.ReactNode;
  cookie: string | null;  // 改为接收 cookie 字符串
}

export function Web3Provider({ children, cookie }: Web3ProviderProps) {
  // 关键：使用 useState 延迟初始化 config
  const [config] = useState(() => getConfig());

  // 在客户端解析 cookie
  const initialState = cookieToInitialState(config, cookie);

  const [queryClient] = useState(() => new QueryClient({
    defaultOptions: {
      queries: {
        staleTime: 1000 * 60 * 5,
        gcTime: 1000 * 60 * 30,
      },
    },
  }));

  return (
    <WagmiProvider config={config} initialState={initialState}>
      <QueryClientProvider client={queryClient}>
        <RainbowKitProvider
          theme={{
            lightMode: lightTheme({
              accentColor: '#0ea5e9',
              accentColorForeground: 'white',
              borderRadius: 'medium',
            }),
            darkMode: darkTheme({
              accentColor: '#0ea5e9',
              accentColorForeground: 'white',
              borderRadius: 'medium',
            }),
          }}
          modalSize="compact"
        >
          {children}
        </RainbowKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
}
```

### 步骤 3: Providers Index - 使用 dynamic import

**文件**: `src/providers/index.tsx`

```typescript
'use client';

import dynamic from 'next/dynamic';

// 使用 dynamic import 跳过 SSR
const Web3Provider = dynamic(
  () => import('./Web3Provider').then((mod) => mod.Web3Provider),
  { ssr: false }
);

interface ProvidersProps {
  children: React.ReactNode;
  cookie: string | null;
}

export function Providers({ children, cookie }: ProvidersProps) {
  return (
    <Web3Provider cookie={cookie}>
      {children}
    </Web3Provider>
  );
}
```

### 步骤 4: Layout - 只传递 cookie 字符串

**文件**: `src/app/layout.tsx`

```typescript
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import { headers } from 'next/headers';
import { Providers } from '@/providers';
import './globals.css';

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-inter',
});

export const metadata: Metadata = {
  title: 'LF Protocol',
  description: 'Comprehensive DeFi yield platform',
  keywords: ['DeFi', 'Yield', 'Launchpad', 'Quant', 'Arbitrum', 'Base'],
};

export default async function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  // 只读取 cookie 字符串，不调用任何 wagmi 函数
  const cookie = (await headers()).get('cookie');

  return (
    <html lang="en" suppressHydrationWarning>
      <body className={`${inter.variable} font-sans antialiased`}>
        <Providers cookie={cookie}>{children}</Providers>
      </body>
    </html>
  );
}
```

### 步骤 5: Next.js Config（已完成）

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  transpilePackages: ['@lf-protocol/sdk'],
  webpack: (config) => {
    config.resolve.fallback = {
      ...config.resolve.fallback,
      '@react-native-async-storage/async-storage': false,
    };
    config.externals.push('pino-pretty', 'lokijs', 'encoding');
    return config;
  },
};

module.exports = nextConfig;
```

---

## 工作原理图解

```
┌─────────────────────────────────────────────────────────────┐
│                     请求流程（无 SSR 错误）                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. 用户请求 → Server (Next.js)                              │
│     │                                                       │
│     ▼                                                       │
│  2. layout.tsx 只读取 cookie 字符串                          │
│     │  headers().get('cookie')  // 不调用任何 wagmi 函数     │
│     │                                                       │
│     ▼                                                       │
│  3. Providers 接收 cookie 字符串                             │
│     │  <Providers cookie={cookie}>                          │
│     │                                                       │
│     ▼                                                       │
│  4. Web3Provider 使用 dynamic import (ssr: false)           │
│     │  服务端跳过，不加载 wagmi/rainbowkit 模块              │
│     │                                                       │
│     ▼                                                       │
│  5. 客户端 Hydration 后，Web3Provider 加载                   │
│     │  useState(() => getConfig())  // 客户端初始化          │
│     │  cookieToInitialState(config, cookie)                 │
│     │                                                       │
│     ▼                                                       │
│  6. 钱包状态从 Cookie 恢复，无需重新连接                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 修改文件清单

| 文件 | 修改内容 |
|------|----------|
| `src/config/wagmi.ts` | 改为导出 `getConfig()` 函数（延迟初始化） |
| `src/providers/Web3Provider.tsx` | 接收 `cookie` prop，内部用 `useState` 初始化 config |
| `src/providers/index.tsx` | 使用 `dynamic import (ssr: false)` |
| `src/app/layout.tsx` | 只读取 cookie 字符串，不导入 wagmi |
| `next.config.js` | 保持当前配置（已正确） |

---

## 预期效果

1. ✅ 无 `indexedDB is not defined` 错误（服务端完全不加载 wagmi）
2. ✅ 无 `@react-native-async-storage` 警告（webpack fallback 已配置）
3. ✅ 页面正常渲染，无空白
4. ✅ 无 hydration 警告（服务端不渲染 Web3 组件）
5. ✅ 钱包连接状态在刷新后保持（Cookie 持久化 + 客户端恢复）

---

## 与当前实现的差异

**当前实现**（已部分工作）:
- `providers/index.tsx` 导入 `config` 和 `cookieToInitialState`
- 导致模块级代码在 SSR 时执行

**最终方案**（完全消除 SSR 错误）:
- `wagmi.ts` 导出 `getConfig()` 函数而非 `config` 值
- `Web3Provider.tsx` 使用 `useState(() => getConfig())` 延迟初始化
- `providers/index.tsx` 不导入任何 wagmi 模块
- 所有 wagmi 代码只在客户端执行

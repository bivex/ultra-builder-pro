# TypeScript Rules

## Type Safety

- Avoid `any` - use `unknown` with type guards
- Prefer interfaces over types for object shapes
- Use strict mode (`strict: true` in tsconfig)
- Enable `noImplicitReturns`, `noUncheckedIndexedAccess`

## Patterns

```typescript
// Use discriminated unions for state
type State =
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; error: Error };

// Use const assertions for constants
const ROLES = ['admin', 'user', 'guest'] as const;
type Role = typeof ROLES[number];

// Use branded types for IDs
type UserId = string & { readonly brand: unique symbol };
```

## Testing

- Use `@testing-library/react` for React components
- Use `msw` for API mocking
- Avoid `any` in test files

## Common Issues

- Don't use `!` assertion - handle nullability properly
- Don't disable ESLint/TypeScript errors without justification
- Don't mix CommonJS and ESM imports

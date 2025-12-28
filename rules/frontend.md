# Frontend Rules

## Core Web Vitals

- LCP < 2.5s (optimize images, reduce server response)
- INP < 200ms (break up long tasks, use web workers)
- CLS < 0.1 (include size attributes, reserve space)

## React Patterns

```typescript
// Use custom hooks for logic extraction
function useUser(id: string) {
  const [user, setUser] = useState<User | null>(null);
  // ...
  return { user, loading, error };
}

// Use compound components for flexibility
<Select>
  <Select.Trigger />
  <Select.Content>
    <Select.Item value="1" />
  </Select.Content>
</Select>

// Use children over props for composition
<Card>
  <Card.Header>Title</Card.Header>
  <Card.Body>{content}</Card.Body>
</Card>
```

## Accessibility

- All images need `alt` text
- Interactive elements need labels
- Color contrast ≥ 4.5:1
- Keyboard navigation support

## Styling

- Use design tokens (no hardcoded colors)
- Avoid default fonts (Inter, Roboto, Arial)
- Use CSS variables for theming
- Mobile-first responsive design

## Testing

- Test user behavior, not implementation
- Use `screen.getByRole()` over `getByTestId()`
- Use `userEvent` over `fireEvent`

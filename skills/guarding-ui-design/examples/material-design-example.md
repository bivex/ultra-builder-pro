# Material Design 3 - Example Implementation

**When to use**: Google ecosystem projects, comprehensive component needs, enterprise applications

---

## Typography Example

```tsx
import { createTheme } from '@mui/material/styles';

const theme = createTheme({
  typography: {
    // Avoid default fonts - use custom pairing
    fontFamily: '"Playfair Display", "JetBrains Mono", serif',
    h1: {
      fontFamily: '"Playfair Display", serif',  // Display font
      fontSize: '3.5rem',  // 3x+ jump from h2
      fontWeight: 700,
      lineHeight: 1.2,
    },
    body1: {
      fontFamily: '"JetBrains Mono", monospace',  // Monospace body
      fontSize: '1rem',
      lineHeight: 1.5,
    },
  },
});
```

## Color Theming with Design Tokens

```tsx
const theme = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: '#D32F2F',  // Choose dominant color based on brand
      light: '#EF5350',
      dark: '#C62828',
    },
    secondary: {
      main: '#7B1FA2',  // Accent color
    },
  },
  // Use CSS variables for design tokens
  components: {
    MuiCssBaseline: {
      styleOverrides: {
        ':root': {
          '--color-primary': '#D32F2F',
          '--color-accent': '#7B1FA2',
          '--spacing-unit': '8px',
        },
      },
    },
  },
});
```

## Motion (CSS-only)

```tsx
const theme = createTheme({
  transitions: {
    duration: {
      shortest: 150,
      shorter: 200,
      short: 250,
      standard: 300,  // Orchestrated timing
      complex: 375,
      enteringScreen: 225,
      leavingScreen: 195,
    },
    easing: {
      easeInOut: 'cubic-bezier(0.4, 0, 0.2, 1)',
      easeOut: 'cubic-bezier(0.0, 0, 0.2, 1)',
      easeIn: 'cubic-bezier(0.4, 0, 1, 1)',
    },
  },
});
```

## Component Usage

```tsx
import { Button, Card, CardContent, Typography } from '@mui/material';

// Prefer library components over custom
function ExampleCard() {
  return (
    <Card elevation={2}>
      <CardContent>
        <Typography variant="h5" component="h2">
          Title
        </Typography>
        <Typography variant="body2" color="text.secondary">
          Description
        </Typography>
        <Button variant="contained" color="primary">
          Action
        </Button>
      </CardContent>
    </Card>
  );
}
```

## Accessibility

```tsx
import { TextField, IconButton } from '@mui/material';
import CloseIcon from '@mui/icons-material/Close';

// WCAG 2.1 AA compliance
<TextField
  label="Email"
  aria-describedby="email-helper-text"
  helperText="We'll never share your email"
/>

<IconButton aria-label="Close dialog" onClick={handleClose}>
  <CloseIcon />
</IconButton>
```

---

**Key Principles**:
- Avoid default fonts (Inter, Roboto)
- Use design tokens (CSS variables)
- CSS-only motion first
- WCAG 2.1 AA compliance
- Prefer MUI components over custom basics

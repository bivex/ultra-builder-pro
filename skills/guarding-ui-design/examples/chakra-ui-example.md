# Chakra UI - Example Implementation

**When to use**: React projects, accessible by default, rapid development with built-in theming

---

## Typography Configuration

```tsx
import { extendTheme } from '@chakra-ui/react';

const theme = extendTheme({
  fonts: {
    // Avoid default fonts
    heading: '"Playfair Display", serif',
    body: '"JetBrains Mono", monospace',
  },
  fontSizes: {
    // 3x+ scale jumps
    'display-xl': '4.5rem',  // 72px
    'display-lg': '3.5rem',  // 56px
    'heading': '2rem',       // 32px
    'body': '1rem',          // 16px
  },
  fontWeights: {
    // High contrast weight distribution
    normal: 400,
    bold: 700,
  },
});
```

## Color Theming with Design Tokens

```tsx
const theme = extendTheme({
  colors: {
    // Design tokens for brand
    primary: {
      50: '#FFF5F5',
      100: '#FED7D7',
      500: '#E53E3E',  // Dominant color
      900: '#742A2A',
    },
    accent: {
      500: '#805AD5',  // Accent color
    },
  },
  // Semantic tokens (design tokens)
  semanticTokens: {
    colors: {
      'brand-primary': 'primary.500',
      'brand-accent': 'accent.500',
    },
  },
});
```

## Component Example

```tsx
import {
  Box,
  Button,
  Card,
  CardBody,
  CardHeader,
  Heading,
  Text,
} from '@chakra-ui/react';

function ExampleCard() {
  return (
    <Card variant="elevated">
      <CardHeader>
        <Heading size="md" fontFamily="heading">
          Title
        </Heading>
      </CardHeader>
      <CardBody>
        <Text fontFamily="body" color="gray.600">
          Description
        </Text>
        <Button
          colorScheme="primary"
          size="md"
          mt={4}
          _hover={{ transform: 'translateY(-2px)' }}
          transition="all 0.2s"
        >
          Action
        </Button>
      </CardBody>
    </Card>
  );
}
```

## Motion (CSS-only with Chakra)

```tsx
import { Box, keyframes } from '@chakra-ui/react';

// Orchestrated page load
const fadeIn = keyframes`
  from { opacity: 0; }
  to { opacity: 1; }
`;

const slideDown = keyframes`
  from { transform: translateY(-10px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
`;

function PageTransition({ children }) {
  return (
    <Box>
      <Box
        as="header"
        animation={`${slideDown} 0.3s ease-out`}
      >
        Header
      </Box>
      <Box
        as="main"
        animation={`${fadeIn} 0.3s ease-in-out 0.2s both`}
      >
        {children}
      </Box>
      <Box
        as="footer"
        animation={`${fadeIn} 0.3s ease-in-out 0.3s both`}
      >
        Footer
      </Box>
    </Box>
  );
}
```

## Accessibility (Built-in)

```tsx
import { FormControl, FormLabel, FormHelperText, Input, IconButton } from '@chakra-ui/react';
import { CloseIcon } from '@chakra-ui/icons';

// Chakra handles ARIA automatically
<FormControl>
  <FormLabel>Email</FormLabel>
  <Input type="email" />
  <FormHelperText>We'll never share your email</FormHelperText>
</FormControl>

// Icon buttons automatically get aria-label
<IconButton
  aria-label="Close dialog"
  icon={<CloseIcon />}
  onClick={handleClose}
/>
```

## Dark Mode Support

```tsx
import { useColorMode, useColorModeValue } from '@chakra-ui/react';

function ThemedComponent() {
  const { colorMode, toggleColorMode } = useColorMode();
  const bg = useColorModeValue('white', 'gray.800');
  const color = useColorModeValue('gray.800', 'white');

  return (
    <Box bg={bg} color={color}>
      <Button onClick={toggleColorMode}>
        Toggle {colorMode === 'light' ? 'Dark' : 'Light'}
      </Button>
    </Box>
  );
}
```

## Responsive Design

```tsx
import { Box, Stack } from '@chakra-ui/react';

<Box
  width={{ base: '100%', md: '80%', lg: '60%' }}
  fontSize={{ base: 'sm', md: 'md', lg: 'lg' }}
>
  Responsive content
</Box>

<Stack
  direction={{ base: 'column', md: 'row' }}
  spacing={4}
>
  <Box>Item 1</Box>
  <Box>Item 2</Box>
</Stack>
```

---

**Key Principles**:
- Avoid default system fonts (customize theme)
- Use semantic tokens (design tokens)
- CSS-only animations with `keyframes`
- Accessibility built-in (Chakra handles ARIA)
- Responsive by default (responsive array syntax)

**Why Chakra UI**:
- Accessible by default (WCAG 2.1 AA)
- Built-in dark mode
- Composable components
- TypeScript support

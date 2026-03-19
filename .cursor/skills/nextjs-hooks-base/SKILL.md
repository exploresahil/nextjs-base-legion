---
name: nextjs-hooks-base
description: Implementation of a standard hooks directory in Next.js, including browser detection, responsive breakpoints, and Lenis smooth scroll integration.
---

# Next.js Hooks Base Skill

This skill helps you implement a standard `hooks/` directory in your Next.js project with essential custom hooks.

## Folder Structure

- `hooks/`
  - `useBrowser.ts`: Detects the user's browser (Chrome, Firefox, Safari, Edge, IE).
  - `useResponsive.ts`: Provides breakpoint detection (small, medium, large, xLarge, xxLarge) and device type flags.
  - `useLenisScrollTo.ts`: Integration with Lenis for smooth scrolling to elements by ID.

## Assets Included

- `useBrowser.ts`: Browser detection logic optimized for React Compiler.
- `useResponsive.ts`: Window resize listener with SSR-safe breakpoint calculation.
- `useLenisScrollTo.ts`: Hook for programmatic smooth scrolling with custom easing support.

## Implementation Script

The skill includes a script:
- `scripts/implement.ps1`: Automates the creation of the `hooks/` directory, copies the default files, and **installs `lenis` and `@lenis/react`** if they are not already in your dependencies.

## Usage

### `useBrowser`
```tsx
const { isChrome, isSafari } = useBrowser();
```

### `useResponsive`
```tsx
const { isMobile, breakpoint } = useResponsive();
```

### `useLenisScrollTo`
```tsx
const scrollToId = useLenisScrollTo();
// Usage in event handler
scrollToId('my-section', { offset: -100, duration: 1 });
```

## Dependencies
- `lenis`
- `@lenis/react`
- `react`

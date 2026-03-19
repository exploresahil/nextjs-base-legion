---
name: nextjs-layout-scss-base
description: Restructures the default Next.js boilerplate into a preferred organized layout and SCSS system.
---

# Next.js Layout & SCSS Restructuring Skill

This skill is designed to transform a default Next.js boilerplate into a preferred, highly organized architecture. It replaces the standard root files with a structured system using route groups, modular SCSS, and pre-configured layouts.

## Folder Structure

- `src/app/`
  - `layout.tsx`: Root layout with font integration.
  - `globals.scss`: Global CSS variables and resets for the root layout.
  - `font/`
    - `index.ts`: Centralized font configuration and `useFonts` hook.
  - `(client)/`
    - `layout.tsx`: Client-side layout with Lenis smooth scroll.
    - `page.tsx`: Default home page.
    - `scss/`
      - `globals.scss`: Main SCSS entry point.
      - `_defaults.scss`: Base resets and styles.
      - `abstracts/`: SCSS variables and functions.

## Features

- **Modular SCSS**: Follows a modular architecture with abstracts and defaults.
- **Integrated Typography**: Implements a standard `next/font/google` setup (Geist, Geist Mono) with a `useFonts` hook for layout integration. Includes template code for local fonts.
- **Root Layout**: Pre-configured root layout that uses the `useFonts` hook for consistent typography across the app.
- **Client Layout**: Implements `ReactLenis` for global smooth scrolling and a base `main` container.
- **Home Page**: Provides a basic starting point for your application.
- **Cleanup**: Automatically removes the default `globals.css` and `page.module.css` from the `src/app` directory.
- **Auto-Installation**: The implementation script automatically installs `sass` and `lenis` if they are missing.

## Implementation Script

The skill includes a script:
- `scripts/implement.ps1`: Automates the creation of the directory structure and deploys the boilerplate code.

## Dependencies
- `sass` (devDependency)
- `lenis`

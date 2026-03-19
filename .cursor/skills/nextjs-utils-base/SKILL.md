---
name: nextjs-utils-base
description: Implementation of basic utility folder and file structure with default code for Next.js projects.
---

# Next.js Utils Base Skill

This skill helps you implement a standard utility directory in your Next.js project, providing essential helper functions and schemas.

## Folder Structure

- `utils/`
  - `index.ts`: Centralized export for all utilities.
  - `image.util.ts`: Image sizes and Zod schemas for image-related logic.
  - `pxToRem.util.ts`: Simple utility to convert pixel values to rem units.

## Implementation Script

This skill includes an implementation script:
- `scripts/implement.ps1`: Automates the creation of the `utils/` directory, copies the default files, and **installs `zod`** if it's not already in your dependencies.

### Key Utilities

#### `pxToRem(px: number)`
Converts a number (representing pixels) into a string with the equivalent `rem` value (assuming a 16px base).

#### `ImageSize` and `ImageSizeSchema`
Defines a structure for handling responsive image sizes in your application, integrated with Zod for type safety.

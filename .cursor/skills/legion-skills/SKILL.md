---
name: legion-skills
description: Project conventions for The Crochet Ghar (Next.js App Router + Sanity, SCSS, Biome, SOLID/DDD). Use when modifying this repo’s routes, components, styling, Sanity integration, or adding animation/3D dependencies.
---

# Legion Skills

## When To Use This Skill

Use this skill **only for this repository** (The Crochet Ghar) when:

- You are **adding or changing**:
  - Next.js routes, layouts, pages, or components under `src/app`
  - Shared components under `src/components`
  - Hooks, utilities, or feature slices under `src/hooks`, `src/utils`, or `src/features`
- You are **editing styles**:
  - Global SCSS in `src/app/(client)/scss`
  - Co-located component styles via `style.scss`
- You are **integrating or querying Sanity**:
  - Config, schema, or GROQ helpers in `src/sanity`
  - Feature-specific Sanity adapters in `src/features/<feature>/infrastructure`
- You are **adding animation or 3D**:
  - GSAP timelines
  - Three.js / React Three Fiber scenes
- You are **running or fixing tooling**:
  - Biome lint/format
  - TypeScript errors

When in doubt: **if you are touching code in this repo, follow this skill.**

## Stack Snapshot & Commands

- **Framework**: Next.js App Router (`src/app`)
- **CMS**: Sanity (`src/sanity`, Studio under `src/app/(studio)`)
- **Styling**: SCSS with shared `abstracts` + co-located `style.scss`
- **Tooling**: TypeScript (strict), Biome (lint + format), React Compiler
- **UX libs**: Lenis (scroll), Motion (animation), Lucide (icons), Styled Components (for specific cases)

**Commands**

- Dev server: `npm run dev`
- Build: `npm run build`
- Sanity types & schema: `npm run typegen`
- Lint (Biome): `npm run lint`
- Format (Biome): `npm run format`

Always keep **Biome and TypeScript clean** before considering a change “done”.

## Architecture & Folder Conventions

High-level layout:

- `src/app`
  - Route groups, layouts, and pages (App Router)
  - `(client)` – client-facing app layout and global SCSS entrypoint
  - `(studio)` – Sanity Studio route
- `src/components`
  - `ui/` – reusable primitives (e.g., `Button`)
  - `default/` – layout and persistent UI (e.g., header, footer)
  - `context/` – providers and app-wide client state
- `src/hooks` – reusable hooks
- `src/lib` – integrations and infrastructure helpers (db, etc.)
- `src/sanity` – Sanity config, schema, queries, and client helpers
- `src/utils` – pure utilities

### DDD-Friendly Feature Slices

When a feature grows beyond simple pages/components, prefer a DDD-style slice:

- `src/features/<feature>/domain/`
  - Entities, value objects, and domain rules
  - **No React, no Next.js, no IO**
- `src/features/<feature>/application/`
  - Use-cases and orchestration
  - Depends on `domain/` and ports (interfaces), not concrete infrastructure
- `src/features/<feature>/infrastructure/`
  - Sanity adapters, API clients, persistence implementations
  - Implements ports defined in `application/`
- `src/features/<feature>/ui/`
  - Feature components and composition
  - Server/client boundaries live here

**Import direction rules**

- `ui` ➜ can import `application`, `domain` types, and stable `infrastructure` facades.
- `application` ➜ can import `domain` and ports/interfaces.
- `domain` ➜ imports **nothing** from UI or infrastructure.
- `infrastructure` ➜ can import `domain` types and `application` ports but **not** UI.

Keep routing in `src/app`, and keep **domain/application logic inside `src/features`** or `src/lib` as appropriate.

## Next.js + Sanity Usage Rules

- Prefer **Server Components by default** for routes and data fetching.
- Move interaction/animation/DOM access into a **client child component** with `"use client"`.
- Keep Sanity-specific concerns in:
  - `src/sanity` for shared config, schemas, and generic helpers
  - `src/features/<feature>/infrastructure` for feature-specific queries/adapters
- Use official docs as the **source of truth**:
  - Next.js: `https://nextjs.org/docs`
  - Sanity: `https://www.sanity.io/docs`
  - next-sanity: `https://github.com/sanity-io/next-sanity`
  - Image helpers: `https://www.sanity.io/docs/image-url` and `https://www.npmjs.com/package/sanity-image`

When adding Sanity usage to a page:

1. **Define or reuse** the schema in `src/sanity`.
2. Put **GROQ queries and typed helpers** in `src/sanity` or feature `infrastructure/`.
3. Keep route components as **thin composition layers** calling those helpers.

## SCSS & Styling Conventions

### Global SCSS

- Global styles live in: `src/app/(client)/scss`
- They are imported by `(client)` layout:
  - `src/app/(client)/layout.tsx` ➜ `import "./scss/globals.scss";`
- Shared tokens/mixins/utilities live in:
  - `src/app/(client)/scss/abstracts`

### Component Styles (Preferred Pattern)

For most components, follow this pattern:

- Co-locate styles:
  - `Component.tsx`
  - `style.scss`
- Import styles at the top of the component file:

```tsx
import "./style.scss";
```

- Scope styles using a **component root id selector** and nest children under it:

```scss
@use "../../../app/(client)/scss/abstracts" as *;

#Header {
  @include full_width;
}
```

**Rules**

- Always `@use` shared abstracts with `as *` (no `@import`).
- Prefer **tokens and helpers** over raw values:
  - Use `rem()` instead of hard-coded `px`.
  - Use shared `breakpoint` mixins for responsive behavior.
- Keep component styles **local**:
  - No global element selectors except in explicit global files (e.g., `_defaults.scss`).

## Components & Reuse Rules

Follow patterns from `src/components/ui` (especially the `button` component):

- Use **typed prop unions** for variants and intent.
- Keep each component’s responsibility **narrow**:
  - Separate fetching from rendering.
  - Separate layout from interaction logic when possible.
- Prefer **composition over configuration**:
  - Use wrapper components, slots, or children instead of “god components” with many boolean props.

Naming and imports:

- Component and hook names: **PascalCase** for components, `useX` for hooks.
- Prefer `@/*` imports for cross-folder references instead of long relative paths.
- Add `"use client"` **only when necessary** (stateful hooks, DOM APIs, R3F Canvas, Motion, Lenis).

## Biome & TypeScript Expectations

- Biome is the **single source of truth** for linting and formatting:
  - Lint: `npm run lint` ➜ `biome check`
  - Format: `npm run format` ➜ `biome format --write`
- Keep imports organized and free of unused symbols (Biome will enforce this).
- TypeScript is **strict**:
  - Prefer explicit, narrow types.
  - Avoid `any` unless there is a clear escape hatch reason.
- Keep files **small and cohesive**:
  - One main responsibility per file.
  - Extract utilities or hooks when behavior starts to generalize.

Do not consider work complete until **Biome + TypeScript are clean**.

## 3D & Animation Additions (GSAP/Three/R3F)

Use these dependencies only when the feature clearly needs advanced animation or 3D:

- GSAP: `https://gsap.com/docs/v3/`
- Three.js: `https://threejs.org/docs/`
- React Three Fiber: `https://docs.pmnd.rs/react-three-fiber/getting-started/introduction`
- React Three Drei: `https://docs.pmnd.rs/drei/introduction`

Install them **on demand**:

```bash
npm i gsap three @react-three/fiber @react-three/drei
```

### Where 3D Lives

- Put any `<Canvas />` usage **behind a client component boundary**.
- Prefer lazy loading heavy scenes:
  - Use `next/dynamic` with `ssr: false` when the scene is not above-the-fold.
- Keep scenes **focused**:
  - Small scene graphs.
  - Shared geometry/materials where possible.

### Performance Defaults

- Consider `frameloop="demand"` for mostly static scenes and invalidate on interaction.
- Use Drei helpers (controls, loaders, environment, etc.) to reduce boilerplate.
- Memoize expensive assets and computations.

### Animation Composition

- Use **GSAP** for DOM and timeline-driven sequences, or when orchestrating complex cross-component transitions.
- For **3D transforms**, prefer:
  - R3F’s `useFrame` for per-frame updates.
  - Spring-based animation (e.g., `@react-spring/three` if introduced) for smooth motion.
- Keep animation logic inside dedicated hooks/components to avoid leaking it into domain or application layers.

## Quick Checklists

### Adding a New Feature Slice

1. **Create structure** under `src/features/<feature>/`:
   - `domain/` for entities and rules.
   - `application/` for use-cases and ports.
   - `infrastructure/` for adapters (Sanity, APIs, etc.).
   - `ui/` for React components and composition.
2. Define **domain types** and invariants in `domain/` with no React/Next imports.
3. Define **ports/interfaces** in `application/` that describe required IO.
4. Implement ports in `infrastructure/` (e.g., Sanity queries) using helpers from `src/sanity` where appropriate.
5. Build `ui/` components that call `application` use-cases and render domain data.
6. Wire the feature into `src/app` routes by importing from `features/<feature>/ui`.
7. Run `npm run lint` and `npm run format` to ensure Biome compliance.

### Adding a New Component with SCSS

1. Decide where it lives:
   - Shared primitive ➜ `src/components/ui`
   - Layout/persistent UI ➜ `src/components/default`
   - Feature-specific ➜ `src/features/<feature>/ui`
2. Create:
   - `Component.tsx` (PascalCase component).
   - `style.scss` co-located with the component.
3. In `Component.tsx`, import styles:

```tsx
import "./style.scss";
```

4. In `style.scss`, import abstracts and define a **root id**:

```scss
@use "../../../app/(client)/scss/abstracts" as *;

#ComponentRoot {
  // component styles here using tokens/mixins, e.g.:
  padding: rem(16);
}
```

5. Use `id="ComponentRoot"` on the component’s outermost element.
6. Use `rem()` and shared breakpoints; avoid raw `px` and ad-hoc media queries.
7. Keep selectors nested under the root id to avoid leaking styles.
8. Run `npm run format` and fix any Biome or TypeScript issues.

### Wiring a New Sanity-Powered Page

1. Confirm or add the **schema** in `src/sanity` (or the relevant schema file).
2. Add or extend a **typed query helper** in:
   - `src/sanity` for generic usage, or
   - `src/features/<feature>/infrastructure` for feature-specific usage.
3. Create or update the **route component** in `src/app`:
   - Prefer a Server Component that calls the query helper.
   - Keep the component mostly about data fetching + layout composition.
4. For interactive parts (filters, animations, 3D, etc.), render a **client child component** with `"use client"`.
5. Ensure image usage uses the Sanity image helpers as configured for this repo.
6. Run `npm run typegen` if schemas changed.
7. Run `npm run lint` and `npm run format` and fix all issues.

### Adding a 3D / Animation-Heavy Section

1. Decide if the feature truly needs **GSAP/Three/R3F**; if yes and not already installed, run:

```bash
npm i gsap three @react-three/fiber @react-three/drei
```

2. Create a **client component** (e.g., `SceneSection.tsx`) with `"use client"` that will own:
   - The `<Canvas />` and R3F scene, and/or
   - GSAP-driven DOM animations.
3. If the scene is not above-the-fold, wrap it with `next/dynamic` and `ssr: false`.
4. Build a **minimal scene graph** using R3F + Drei; keep objects and materials small and reusable.
5. Use `frameloop="demand"` or similar performance-friendly settings if the scene is mostly static.
6. Keep GSAP timelines or `useFrame` loops **encapsulated** in hooks/components dedicated to animation.
7. Verify performance in the browser (FPS, CPU usage) and tune if needed.
8. Run `npm run lint` and `npm run format`.

Use these checklists as a guardrail: if a step feels unclear, prefer smaller, well-factored additions and lean on the referenced docs for API details.


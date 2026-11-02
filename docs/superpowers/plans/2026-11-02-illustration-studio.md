# Illustration Studio Implementation Plan

> **For agentic workers:** Use this plan as the implementation checklist.

**Goal:** Build a vector-only illustration composition MVP ready for Vercel.

**Architecture:** Static browser application with immutable source SVG boards, locally extracted path clusters, editable composition state, and SVG export.

**Tech Stack:** HTML, CSS, browser JavaScript, SVG DOM APIs, Vercel static hosting.

**Spec:** `docs/superpowers/specs/2026-11-02-illustration-studio-design.md`

## Global Constraints

- Reuse only supplied illustration paths.
- Do not rasterize artwork or alter component proportions.
- Keep the app deployable as a static Vercel project without secrets.

## Review Focus

- Sparse or malformed source geometry must not stop the editor from loading.
- Component extraction preserves transforms and fill/stroke attributes.
- Recoloring preserves the palette and forces background objects to a monochrome tint.
- Canvas clipping does not modify source component geometry.
- SVG export includes a valid namespace and editable vector paths.

---

### Task 1: Package the supplied SVG sources

**Files:** `assets/source/*.svg`, `README.md`

- [x] Copy one copy of each unique valid board into the deliverable.
- [x] Document source provenance and vector-only structure.

### Task 2: Build the application shell and catalog

**Files:** `index.html`, `src/styles.css`, `src/app.js`

- [x] Add a responsive workspace layout and Russian interface.
- [x] Parse source SVGs, preserve transforms, cluster nearby geometry, and show candidate components.
- [x] Add text and semantic search, size filters, role filters, and palette controls.

### Task 3: Implement composition editing and export

**Files:** `src/app.js`, `src/styles.css`

- [x] Add canvas placement, selection, movement, rotation, duplicate/delete, and layer ordering.
- [x] Add format presets, palette recoloring, source composition examples, and vector SVG export.

### Task 4: Prepare and verify Vercel deployment

**Files:** `vercel.json`, `README.md`, `.gitignore`

- [x] Add static hosting configuration and setup instructions.
- [x] Run source syntax checks and inspect the local browser preview.
- [ ] User claims the temporary Vercel deployment in their own account; the claim page is open. The temporary URL expires in 60 minutes and currently returns 403 until claimed.
- [ ] Create a persistent authenticated production deployment and repository link after Vercel/GitHub ownership is established.

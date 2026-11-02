# Forma — updated design and implementation notes

## Intent

A static web editor for arranging editable SVG components from the user's supplied boards. It is intended as a test-assignment prototype that runs locally or on Vercel, without a server or account setup.

## Required behavior

- Read the supplied L and S SVG libraries and preserve vector paths, colors, and viewBox geometry.
- Search by component name/tags or by a metaphor expanded through a local concept dictionary.
- Allow manual placement, move, rotate, duplicate, delete, layer ordering, role changes, canvas format selection, palette changes, and SVG export.
- Main objects follow the selected palette. Background objects render with a monochrome palette tint. Canvas background uses the selected background color.
- Individual object scale is fixed. Format changes apply a shared uniform scale and position conversion to the composition.
- Save compact scene state and library names/tags in browser localStorage.

## Approaches

1. Figma plugin: strongest access to Figma components but requires plugin setup and the user requested a hosted website.
2. Static browser editor (selected): deployable to Vercel with no secrets or backend, reads the supplied SVGs directly, exports SVG.
3. Hosted catalog/editor: enables shared metadata and durable projects but requires auth/database work beyond this prototype.

## Architecture

The source SVG files under `assets/source/` remain untouched. Browser DOM APIs compute path geometry and candidate clusters, retain path attributes and source definitions, and namespace definition IDs when rendering/exporting. Layer state stores references to catalog items rather than duplicating SVG path data. Local palette matching remaps source colors, and role changes recolor background components monochromatically. SVG export composes vector paths and layer transforms into a new document. Metadata and projects remain local to the browser.

## Important source limitation

The source boards contain thousands of flattened paths and almost no object labels or groups. Spatial clustering can split or merge a visual object. Therefore the generated catalog is a set of candidates that must be visually reviewed and tagged before semantic assembly can be trusted. The web app must not claim that unreviewed candidates are exact whole source objects. A production-quality guarantee requires either a curated per-object manifest from the designer or manual review of every extracted candidate.

## AI use

ChatGPT/Codex supported requirements analysis, implementation, and code review. Runtime metaphor search is a deterministic local dictionary applied only to user-confirmed catalog tags. No external AI API or generated artwork is included.

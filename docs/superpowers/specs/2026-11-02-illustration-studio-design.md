# Illustration Studio — design

## Intent

Build a Vercel-ready web prototype that lets a designer assemble vector illustrations from the supplied SVG boards, recolor them with a selected palette, choose a detail size and canvas format, and export an editable SVG.

## Goals

- Keep all artwork as SVG paths and preserve component proportions.
- Provide component search by object name and by metaphor/idea using local semantic tags.
- Support primary and monochrome background roles, two detail sizes, and three palettes.
- Allow adding, moving, rotating, duplicating, deleting, ordering, and recoloring objects.
- Include three example compositions and SVG export.

## Constraints and non-goals

- Only reuse path geometry from the three unique supplied SVG boards; do not generate replacement artwork.
- The boards have no text labels and mostly lack per-object groups. The application will extract candidate regions by vector geometry and allow a person to review/rename them.
- MVP data stays in the browser. It does not require account, database, or AI API keys.
- The metaphor flow uses local semantic tags and keyword matching. ChatGPT assisted implementation; no generated assets are included.

## Approaches considered

1. Figma plugin: direct access to native layers, but requires Figma connection and plugin setup.
2. Client-side web app (chosen): hosts easily on Vercel, imports the supplied boards, and keeps a self-contained vector editor without account infrastructure.
3. Hosted catalog and collaboration service: durable shared library but adds database, upload, and authentication scope beyond the test assignment.

## Architecture

Static HTML/CSS/JavaScript served from `public/` on Vercel. The original SVG boards are immutable source assets. At runtime the browser parses their vector geometry, groups nearby paths into candidate components, and stores component metadata and editor state locally. Composition objects reference vector snippets and transformations; export writes a new SVG document with vector paths, layer order, palette colors, and a format-specific viewBox.

## Decisions left to implementation

- Candidate grouping thresholds and component names should be treated as editable suggestions because semantic labels are absent from the source exports.
- The two source boards with portrait artboards are mapped to the two detail sizes; if their intended size labels differ, the mapping can be changed in catalog metadata.

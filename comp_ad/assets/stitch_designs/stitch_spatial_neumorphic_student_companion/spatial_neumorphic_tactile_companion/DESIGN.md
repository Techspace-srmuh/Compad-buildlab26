---
name: Spatial Neumorphic Tactile Companion
colors:
  surface: '#0e131e'
  surface-dim: '#0e131e'
  surface-bright: '#343945'
  surface-container-lowest: '#090e19'
  surface-container-low: '#171c27'
  surface-container: '#1b202b'
  surface-container-high: '#252a35'
  surface-container-highest: '#303541'
  on-surface: '#dee2f2'
  on-surface-variant: '#c7c4d7'
  inverse-surface: '#dee2f2'
  inverse-on-surface: '#2b303c'
  outline: '#908fa0'
  outline-variant: '#464554'
  surface-tint: '#c0c1ff'
  primary: '#c0c1ff'
  on-primary: '#1000a9'
  primary-container: '#8083ff'
  on-primary-container: '#0d0096'
  inverse-primary: '#494bd6'
  secondary: '#4cd7f6'
  on-secondary: '#003640'
  secondary-container: '#03b5d3'
  on-secondary-container: '#00424e'
  tertiary: '#4edea3'
  on-tertiary: '#003824'
  tertiary-container: '#00885d'
  on-tertiary-container: '#000703'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e1e0ff'
  primary-fixed-dim: '#c0c1ff'
  on-primary-fixed: '#07006c'
  on-primary-fixed-variant: '#2f2ebe'
  secondary-fixed: '#acedff'
  secondary-fixed-dim: '#4cd7f6'
  on-secondary-fixed: '#001f26'
  on-secondary-fixed-variant: '#004e5c'
  tertiary-fixed: '#6ffbbe'
  tertiary-fixed-dim: '#4edea3'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#0e131e'
  on-background: '#dee2f2'
  surface-variant: '#303541'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 30px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 26px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 22px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 18px
  mono-metric-lg:
    fontFamily: JetBrains Mono
    fontSize: 28px
    fontWeight: '500'
    lineHeight: 32px
    letterSpacing: -0.03em
  mono-metric-md:
    fontFamily: JetBrains Mono
    fontSize: 18px
    fontWeight: '500'
    lineHeight: 24px
    letterSpacing: -0.02em
  mono-metric-sm:
    fontFamily: JetBrains Mono
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: -0.01em
  label-caps:
    fontFamily: JetBrains Mono
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.08em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  gutter-desktop: 1.5rem
  margin-desktop: 2.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.25rem
---

## Brand & Style

This design system establishes a high-craft fusion of Apple VisionOS spatial glass surfaces with soft, hyper-tactile Neumorphic physics. Engineered specifically for a standalone, fully offline mobile student environment, the interface projects an aura of extreme focus, sensory satisfaction, and absolute privacy. 

The aesthetic merges physical desktop instrumentation with futuristic spatial layers:
- **Physicality & Tactility:** Extruded tactile panels, sunken toggle trenches, and deeply inset entry fields make interactions feel like pressing physical machinery keys or bespoke slate instruments.
- **Spatial Stratification:** Translucent frosted HUDs and floating action docks float above tactile substrate plates with heavy backdrop blurs, crisp light reflections, and kinetic luminous filaments.
- **Emotional Intent:** Reduces academic burnout and digital fatigue by replacing harsh digital planes with grounding, touch-sensitive midnight surfaces and precise, kinetic micro-interactions.

## Colors

The palette operates in strict dark mode, anchored in deep midnight tones that allow directional lighting and kinetic chromatic glows to communicate state changes and focal points:

- **Base Canvas (`#0F131D`):** Deep midnight charcoal foundation that recedes infinitely.
- **Physical Plate Surface (`#161B26`):** The master tactile plane used for extruded containers, cards, and resting interactive blocks.
- **Floating Spatial Glass:** Layered `rgba(22, 27, 38, 0.65)` to `rgba(30, 38, 54, 0.45)` with `24px` backdrop blurs and `rgba(255, 255, 255, 0.08)` rim edges.
- **Indigo Glow (`#6366F1`):** Primary driver for focus timers, active study sessions, and master navigation triggers.
- **Cyan Glow (`#06B6D4`):** Secondary driver for reference databases, search vectors, and informational tags.
- **Emerald Glow (`#10B981`):** Progress completion, offline integrity confirmations, and streak milestones.
- **Coral Glow (`#F43F5E`):** Flashcard recall challenges, urgent deadlines, and critical battery/storage metrics.

## Typography

Typography balances warm human ergonomics with structural, scientific precision:
- **Plus Jakarta Sans** delivers humanist geometry and approachability across titles, editorial study guides, and content cards, mitigating cognitive strain during long reading intervals.
- **JetBrains Mono** governs all quantitative and temporal data: study timers, countdown nodes, flashcard difficulty indexes, memory consumption readouts, and metadata tags.
- Uppercase tracking on labels (`label-caps`) ensures ultra-crisp legibility when embossed or debossed directly onto dark neomorphic surfaces.

## Layout & Spacing

The layout model is mobile-first, utilizing a fluid responsive grid engineered for single-thumb actuation and visual breathing room around tactile extruded geometry:

- **Mobile (<640px):** Single-column fluid architecture with `1.25rem` outer canvas padding. Interactive targets maintain generous breathing room to accommodate double-shadow feathering without overlapping neighboring boundaries.
- **Tablet (640px - 1024px):** 6-column grid with `1rem` gutters; navigation docks transition into floating spatial vertical sidebars.
- **Desktop / Foldable (>1024px):** 12-column constrained grid (max-width `1280px`) with `1.5rem` gutters and `2.5rem` outer margins. Content groups into modular split-slate control panels.
- **Neumorphic Padding Law:** Components require higher internal padding (`space-md` to `space-lg`) than standard flat interfaces to allow extruded edge highlights to drop off naturally without crowding label text.

## Elevation & Depth

Visual hierarchy is constructed across three distinct physical and spatial strata:

### Level -1: Inset Well (Debossed / Carved)
Used for text input fields, inactive progress tracks, and pressed toggle wells.
- **Shadows:** `inset -3px -3px 8px rgba(255, 255, 255, 0.04), inset 4px 4px 10px rgba(0, 0, 0, 0.7)`
- **Border:** `1px solid rgba(0, 0, 0, 0.4)`
- **Surface:** `#121620`

### Level 0: Tactile Extrusion (Baseline Neumorphic)
Used for resting cards, modular tool tiles, and unpressed buttons. Elements emerge organically from the `#161B26` slate.
- **Shadows:** `-6px -6px 16px rgba(255, 255, 255, 0.05), 8px 8px 20px rgba(0, 0, 0, 0.6)`
- **Top-Left Specular Edge:** `1px solid rgba(255, 255, 255, 0.06)`
- **Bottom-Right Occlusion:** `1px solid rgba(0, 0, 0, 0.35)`

### Level +1: Spatial Glass (VisionOS Floating Layer)
Used for floating bottom action docks, heads-up timer overlays, and interactive modals.
- **Surface:** `rgba(22, 27, 38, 0.60)` with `backdrop-filter: blur(24px)`
- **Boundary Rim:** `1px solid rgba(255, 255, 255, 0.12)` top/left gradient, fading to `rgba(255, 255, 255, 0.03)` bottom/right.
- **Ambient Levitation Shadow:** `0 20px 40px -10px rgba(0, 0, 0, 0.7), 0 0 1px 1px rgba(255, 255, 255, 0.1)`

### Kinetic Accent Glows
When states activate (e.g., timer active, item mastered), the tactile extrusion gains a localized neon specular spill:
- `box-shadow: -6px -6px 16px rgba(255, 255, 255, 0.05), 8px 8px 20px rgba(0, 0, 0, 0.6), 0 0 24px rgba(99, 102, 241, 0.3)`

## Shapes

The design system maintains a tactile, molded geometric language:
- **Base Geometry (`roundedness: 2`):** Primary standard radius is `0.5rem (8px)` for smaller inputs, chips, and tactile switches.
- **Cards & Slates (`rounded-lg: 1rem / 16px`):** Used for tactile modules, subject decks, and question containers. Ensures light highlights curve smoothly around corners.
- **Spatial Floating Glass (`rounded-xl: 1.5rem / 24px`):** Used for navigation docks, floating action toolbars, and contextual modals.
- **Pill Architecture (`rounded-full`):** Reserved exclusively for interactive HUD status pills, timer capsules, and mono metric badges.

## Components

### Buttons
- **Tactile Standard:** Built on `#161B26` with Level 0 extruded shadows. Typography uses `Plus Jakarta Sans 600`. On tap/press, the element transitions using a spring curve (`cubic-bezier(0.34, 1.56, 0.64, 1)`) to Level -1 inset shadows and translates `1px` downward, creating physical mechanical travel.
- **Spatial Glass Action:** Built on floating glass surface with an active kinetic stroke matching the context (`Indigo` for study session, `Emerald` for save/commit).

### Input Fields
- Rendered as Level -1 inset wells sunken into the panel surface. Background is slightly darker (`#121620`).
- Placeholders sit at `40%` opacity. On focus, the inner shadow deepens and an inner edge glow of `Indigo` (`rgba(99, 102, 241, 0.25)`) radiates along the interior perimeter.

### Chips & Badges
- **Status Pills:** Pill-shaped capsules with translucent backing (`rgba(255, 255, 255, 0.04)`) and `JetBrains Mono` label text.
- **Filter Chips:** Neumorphic extrusions in resting state; snap into sunken inset state with a kinetic accent rim when active.

### Cards & Content Slates
- High-surface `#161B26` slabs with directional dual shadows. Content sits directly on the plate without harsh borders.
- Sub-cards or nested list items alternate between slightly shallower extrusions and inset resting wells to create rich visual layers without altering background hue.

### Floating Action Dock (Spatial HUD)
- Floating anchored dock pinned `1.25rem` above the bottom safe area.
- Uses `backdrop-filter: blur(24px)`, `background: rgba(22, 27, 38, 0.65)`, and an ultra-thin specular rim (`1px rgba(255, 255, 255, 0.12)`).
- Icons use dual-tone fills that illuminate with targeted kinetic glows (`Cyan`, `Indigo`, `Coral`) upon selection.

### Offline Companion Extras
- **Standalone Telemetry Pill:** A dedicated HUD capsule housing `JetBrains Mono` readouts showing `100% OFFLINE / LOCAL CACHE`, backed by a pulsing `Emerald` specular LED point (`#10B981`).
- **Focus Pomodoro Dial:** Concentric inset track with an extruded center knob featuring spring resistance depression feedback on touch.
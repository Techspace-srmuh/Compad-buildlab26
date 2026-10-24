---
name: Nocturnal Campus Utility
colors:
  surface: '#0f131d'
  surface-dim: '#0f131d'
  surface-bright: '#353944'
  surface-container-lowest: '#0a0e18'
  surface-container-low: '#171b26'
  surface-container: '#1c1f2a'
  surface-container-high: '#262a35'
  surface-container-highest: '#313540'
  on-surface: '#dfe2f1'
  on-surface-variant: '#c7c4d7'
  inverse-surface: '#dfe2f1'
  inverse-on-surface: '#2c303b'
  outline: '#908fa0'
  outline-variant: '#464554'
  surface-tint: '#c0c1ff'
  primary: '#c0c1ff'
  on-primary: '#1000a9'
  primary-container: '#8083ff'
  on-primary-container: '#0d0096'
  inverse-primary: '#494bd6'
  secondary: '#4fdbc8'
  on-secondary: '#003731'
  secondary-container: '#04b4a2'
  on-secondary-container: '#003f38'
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
  secondary-fixed: '#71f8e4'
  secondary-fixed-dim: '#4fdbc8'
  on-secondary-fixed: '#00201c'
  on-secondary-fixed-variant: '#005048'
  tertiary-fixed: '#6ffbbe'
  tertiary-fixed-dim: '#4edea3'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#0f131d'
  on-background: '#dfe2f1'
  surface-variant: '#313540'
typography:
  display:
    fontFamily: Plus Jakarta Sans
    fontSize: 40px
    fontWeight: '800'
    lineHeight: 48px
    letterSpacing: -0.03em
  display-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 30px
    fontWeight: '800'
    lineHeight: 38px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: -0.005em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0em
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-tablet: 1.25rem
  gutter-desktop: 1.5rem
  margin: 1rem
  margin-tablet: 1.5rem
  margin-desktop: 2rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.25rem
  space-xl: 2rem
---

## Brand & Style

This design system is tailored for an offline-first collegiate companion built for low-friction daily life on campus. The aesthetic balances utilitarian reliability with an energetic, modern night-campus atmosphere. It rejects generic light productivity conventions in favor of deep-space focus, high information density, and low-cognitive-load navigation.

### Visual Character & Philosophy
- **Atmosphere:** Low-glare, nocturnal, focused. Designed for dim lecture halls, late-night library study sessions, and quick sunlight-to-shadow outdoor walk transitions.
- **Design Movement:** Modern Architectural Glass & Slate. Instead of heavy blur effects or generic muddy drop shadows, the aesthetic relies on structural containment, low-contrast ghost borders (`1px` hair-thin lines), deliberate luminance tiers, and high-frequency tactile micro-accents.
- **Tone of Voice in UI:** Direct, kinetic, and context-aware. Interface elements emphasize instant state clarity (e.g., cached vs. syncing statuses) without cluttering the screen.

## Colors

The palette employs a multi-tiered slate base punctuated by laser-sharp chromatic focal points to establish visual hierarchy without ocular fatigue.

### Surface Tiers
- **Canvas Base (`#0B0F19`):** Root background across phone and tablet screens.
- **Surface Level 1 (`#111827`):** Recessed containers, primary views, and master grouping sections.
- **Surface Level 2 (`#1F2937`):** Interactive cards, modules, course schedule blocks, and bottom sheets.
- **Surface Level 3 (`#374151`):** Active toggles, elevated pills, popovers, and sticky overlays.

### Accents & Roles
- **Electric Indigo (`#6366F1` / `#4F46E5`):** Primary interactions, core offline sync status active indicators, and actionable buttons.
- **Luminous Teal (`#14B8A6` / `#2DD4BF`):** Secondary navigation links, transit tracking, campus schedules, and real-time markers.
- **Mint Emerald (`#10B981`):** Health markers, campus dining status, gym density indicators, and finished offline syncs.
- **Warm Amber (`#F59E0B`):** Impending deadlines, classroom reassignments, offline conflict alerts, and network sync warnings.

### Typography & Border Contrast
- High-contrast text (`#F9FAFB`) is preserved strictly for primary titles, numerical badges, and form inputs.
- Medium-contrast text (`#9CA3AF`) serves secondary reading, course IDs, and timestamps.
- Subtle text (`#4B5563`) delivers structural captions, metadata labels, and disabled elements.
- Ghost borders (`rgba(255, 255, 255, 0.08)`) define boundaries without breaking immersion; active states step up to `#374151` or an accent-tinted border.

## Typography

Plus Jakarta Sans is utilized across the entirety of the typographic hierarchy. Its crisp geometry, open counters, and high x-height guarantee legibility when moving between harsh ambient light and pitch-dark environments.

### Rules of Usage
- **Tight Headings:** All headers from `headline-sm` up to `display` must leverage negative letter spacing to preserve a compact, engineered posture.
- **Label Capitalization:** `label-sm` is exclusively used for micro-tags, offline data caching statuses, and system tags; it should typically render with uppercase transformation and `0.05em` tracking.
- **Density Control:** Never mix multiple weights within a single horizontal data row. Keep text pairings locked between Medium (`500`) / Semibold (`600`) values for labels and Regular (`400`) for secondary contextual descriptions.

## Layout & Spacing

The layout is built upon an 8-point structural system, with a 4-point micro-scale reserved for tags, borders, and input insets. The grid is fluid with strict boundary margins suited for thumb-driven mobile ergonomics.

### Screen Adaptations
- **Mobile (< 640px):** Single-column layout. Margin is `1rem` (16px) with dynamic bottom-sheet clearance and a persistent pinned offline status bar. Internal card gutters are locked to `1rem`.
- **Tablet (640px - 1024px):** 6-column fluid structure. Margin widens to `1.5rem` (24px) with a split-screen schedule/map master-detail paradigm.
- **Desktop / Large Displays (> 1024px):** 12-column fixed-max layout with a maximum container width of `1280px` centered on `#0B0F19`. Lateral margins expand to `2rem` (32px).

### Spacing Principles
- Dynamic stacking uses `space-sm` (8px) for tightly coupled metadata, `space-md` (16px) for item separation inside cards, and `space-xl` (32px) to delimit separate functional campus blocks (e.g., Next Class vs. Meal Balances).

## Elevation & Depth

This design system deliberately omits soft, diffused drop shadows. Instead, it relies on structural chromatic layering and 1px crisp borders. This keeps the dark interface pure, prevents muddy artifacts on mobile OLED panels, and preserves hardware battery life during long days on campus.

### Spatial Layering Architecture
- **Layer 0 (Canvas):** `#0B0F19` — The infinite canvas, background for all page viewports.
- **Layer 1 (Recessed Container):** `#111827` framed by a 1px solid border of `rgba(255, 255, 255, 0.08)`. Used for horizontal scroll lists, parent cards, and grouped feeds.
- **Layer 2 (Elevated Item):** `#1F2937` with an active highlight perimeter of `1px solid rgba(255, 255, 255, 0.12)`. Applied to interactive cards, timetable modules, and touch targets.
- **Layer 3 (Floating Modal / Overlay):** `#1F2937` with an explicit outer contour of `1px solid #374151`. Backdrops employ a `backdrop-filter: blur(12px)` coupled with an 80% opacity `#0B0F19` scrim.

### Interaction States
When focused or hovered, cards and interactive modules do not rise along the z-axis via shadows. They illuminate along the border: the border color transitions cleanly to `rgba(99, 102, 241, 0.4)` (Electric Indigo Tint) or `#374151`.

## Shapes

The geometric signature is grounded in a continuous, generous curvature centered on the 20px (`1.25rem`) card geometry specified for key modules. This softens the technical aesthetic of dark mode, creating an inviting, mobile-first feel.

### Geometric Scale
- **Pills / Status Chips (`radius-full`):** All tags, indicators, offline counters, and small filter buttons use an enclosed pill geometry.
- **Small Controls (`radius-sm` - `6px` / `radius-md` - `8px`):** Checkboxes, form fields, and dropdown targets.
- **Internal Elements (`radius-lg` - `16px`):** Embedded sub-cards and list items resting inside an exterior parent module.
- **Primary Modules & Sheets (`radius-card` - `20px`):** Main schedule panels, assignments, dining cards, modal dialogs, and navigation drawers.

## Components

### Buttons
- **Primary:** Background `#6366F1`, text `#F9FAFB`, `radius-md` (8px) or `radius-full` for mobile FABs. Hover state transitions to `#4F46E5`. No shadow; border is `1px solid rgba(255, 255, 255, 0.15)`.
- **Secondary / Ghost:** Background `transparent`, text `#F9FAFB`, border `1px solid rgba(255, 255, 255, 0.08)`. Hover fills with `#1F2937` and shifts border to `#374151`.
- **Icon Actions:** Flat `#111827` surface, `1px solid rgba(255, 255, 255, 0.08)` border, icon tint `#9CA3AF`. Switches to high-contrast `#F9FAFB` on touch.

### Cards & Modules
- **Geometry:** Locked to `radius-card` (20px).
- **Background:** `#111827` or `#1F2937` depending on grouping depth.
- **Perimeter:** Bound by `1px solid rgba(255, 255, 255, 0.08)`. Zero drop-shadow.
- **Card Padding:** Uniform `1.25rem` (20px) on mobile, expandable to `1.5rem` (24px) on desktop layouts.

### Chips & Badges
- **Offline / Sync Indicator:** Pill container (`radius-full`), subtle background of `#111827`, border `1px solid rgba(255, 255, 255, 0.08)`. Contains an animated or solid 6px dot: `#10B981` (Synced), `#F59E0B` (Offline / Stored Local), `#6366F1` (Syncing).
- **Filter Tags:** Background `#1F2937`, text `#9CA3AF`, `radius-full`. When selected, border switches to `#6366F1` with an inner fill of `rgba(99, 102, 241, 0.15)` and text `#F9FAFB`.

### Form Inputs
- **Field Base:** `#111827` fill, border `1px solid #374151`, text `#F9FAFB`, placeholder `#4B5563`, rounded to `radius-md` (8px). Height locked to 44px for touch accessibility.
- **Active / Focus:** Border changes to `#6366F1` with an interior glow achieved purely via an additional `box-shadow: 0 0 0 1px #6366F1` ring. No outer blur halos.

### Lists & Timetable Rows
- Separated not by full-width dividers, but by 4px air gaps or distinct item cards using `#1F2937` against the `#0B0F19` canvas.
- Vertical indicator strips (3px wide, rounded ends) sit at the extreme left edge of timetable items to reflect category: Teal for Lectures, Emerald for Wellness/Rec, Amber for Due Dates.

### Selection Controls (Checkboxes & Radios)
- **Base:** Unchecked state uses `#111827` interior with `1px solid #4B5563`.
- **Checked:** Filled with `#6366F1`, checkmark rendered in pure `#F9FAFB`. Checkbox border radius is 4px (`radius-sm`); radios are `radius-full`.
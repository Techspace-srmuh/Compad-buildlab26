---
name: Campus Companion
colors:
  surface: '#faf8ff'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#464555'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#767587'
  outline-variant: '#c7c4d8'
  surface-tint: '#4746e2'
  primary: '#2319c5'
  on-primary: '#ffffff'
  primary-container: '#3f3ddb'
  on-primary-container: '#c9c8ff'
  inverse-primary: '#c1c1ff'
  secondary: '#006b5f'
  on-secondary: '#ffffff'
  secondary-container: '#6df5e1'
  on-secondary-container: '#006f64'
  tertiary: '#5c3800'
  on-tertiary: '#ffffff'
  tertiary-container: '#7b4d00'
  on-tertiary-container: '#ffc277'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e1dfff'
  primary-fixed-dim: '#c1c1ff'
  on-primary-fixed: '#08006c'
  on-primary-fixed-variant: '#2c26cb'
  secondary-fixed: '#71f8e4'
  secondary-fixed-dim: '#4fdbc8'
  on-secondary-fixed: '#00201c'
  on-secondary-fixed-variant: '#005048'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 38px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  title-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: -0.01em
  title-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
    letterSpacing: 0em
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: -0.01em
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0em
  body-sm:
    fontFamily: Inter
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
    letterSpacing: 0.04em
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
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

The brand identity bridges academic utility with reassuring, empathetic daily guidance. It positions itself as an indispensable digital companion for university students traversing bustling, low-connectivity lecture halls, vast campuses, and high-stress deadline cycles. The emotional resonance is calm, supportive, and dependable—eliminating anxiety through clear information hierarchy, high-contrast legibility, and prominent indicators of offline readiness.

The aesthetic follows an expressive **Material 3 / iOS Hybrid** philosophy. It unites the structural predictability, smooth tactile sheets, and tonal surfaces of iOS with the rich functional color zoning, fluid gesture patterns, and container tokens of Material 3. Surfaces use soft, pastel-tinted cards for spatial category recognition, paired with bold geometric typography and tactile 48px touch surfaces engineered for quick thumb-reach access.

## Colors

The palette balances structural authority with intuitive visual triage. Light mode is the default canvas to ensure legibility across variable outdoor campus lighting conditions, supplemented by specialized tint zones that reinforce spatial memory across distinct domains of student life.

### Functional Tint Domains
To facilitate instant recognition during rapid navigation across campus:
- **Academic Domain (Indigo Tint):** Base surface `#EEF2FF`, border `#C7D2FE`, content `#3730A3`. Applied to class schedules, lecture notes, syllabus checklists, and exam timelines.
- **Navigation & Campus Domain (Teal Tint):** Base surface `#F0FDFA`, border `#99F6E4`, content `#0F766E`. Applied to building indoor maps, shuttle schedules, and campus facilities.
- **Student Life Domain (Violet/Pink Tint):** Base surface `#FDF2F8`, border `#FBCFE8`, content `#9D174D`. Applied to clubs, dining hall menus, social mixers, and campus events.
- **Wellbeing & Health Domain (Soft Green Tint):** Base surface `#F0FDF4`, border `#BBF7D0`, content `#166534`. Applied to counseling check-ins, gym hours, peer drop-in sessions, and sleep logs.

### System & Alert Semantics
- **Urgent Accent (Deadlines & Warnings):** Amber `#F59E0B` (surface tint `#FFFBEB`, text `#B45309`) for upcoming submissions, overdue balances, and registration cutoffs.
- **Emergency SOS:** Signal Red `#EF4444` (surface `#FEF2F2`, active `#DC2626`) reserved strictly for security dispatch, emergency escorts, and campus crisis alerts.
- **Offline Reliability Indicator:** Emerald Green `#10B981` paired with neutral surface layers to signpost cached, locally-synced states without anxiety.

## Typography

The type scale integrates the approachability and structural geometry of **Plus Jakarta Sans** for titles, metric displays, and contextual chips with the high-legibility optical engine of **Inter** for dense campus data, body descriptions, and timetables.

- Display headers prioritize tight letter-spacing to allow comfortable nesting of long module codes (e.g., `CS-4028 Algorithms`) within narrow mobile frames.
- Body sizes are restricted to a minimum of 12px for micro-metadata and 14px for general descriptions, ensuring outdoor legibility under direct sunlight.
- Numerical time stamps, classroom codes, and countdown clocks utilize tabular figures (`tnum`) within Inter to prevent horizontal visual jitter during live updates.

## Layout & Spacing

The canvas is tailored for a mobile baseline of 390x844 with fluid adaptation across compact screens. The layout relies on an 8-point vertical cadence anchored by 16px (`gutter`) horizontal intervals and a standardized 20px (`margin`) outer edge margin, shielding content from screen bevels and hardware edges.

### Layout Ergonomics
- **Safe Zone Pacing:** Top header maintains a fixed 44px status bar offset followed by a 56px top bar container.
- **Bottom Navigation Dock:** Fixed 80px container elevation with a 34px bottom inset accommodating the iOS home indicator bar and Android navigation gestures.
- **Thumb-Zone Optimization:** High-frequency controls, search expansions, and the center quick-add button reside within the lower two-thirds (400px–750px vertical range) of the display.

## Elevation & Depth

Visual hierarchy uses clean tonal planes layered over ambient shadows, rejecting sharp skeuomorphic gradients in favor of an airy, physical card stack:

- **Level 0 (Canvas Base):** Plain `#F8FAFC` background. Completely flat with zero elevation.
- **Level 1 (Category & Content Cards):** Tonal category surfaces with a 1px matching border (`#E2E8F0` or domain pastel border) combined with an ultra-diffused drop shadow: `0 2px 8px -2px rgba(15, 23, 42, 0.04), 0 1px 4px -1px rgba(15, 23, 42, 0.02)`.
- **Level 2 (Top App Bar & Floating Chips):** Background of `rgba(255, 255, 255, 0.88)` enhanced with a `16px` backdrop-filter blur, anchored by a bottom hairline rule `rgba(226, 232, 240, 0.8)`.
- **Level 3 (Modal Sheets & Bottom Dock):** Bottom navigation dock uses `rgba(255, 255, 255, 0.94)` with an ambient `0 -4px 20px rgba(15, 23, 42, 0.06)` shadow.
- **Level 4 (Elevated Floating Center Action Button):** Solid `#3F3DDB` core with a colored glow drop shadow: `0 8px 24px -4px rgba(63, 61, 219, 0.45)`.

## Shapes

The design system maintains a coherent rounded profile balancing modern digital polish with ergonomic feel:

- **Standard Cards & Module Panels:** Fixed to `20px` corner radii (`rounded-xl` equivalent within base variables), framing discrete blocks of timetable, route, or task information.
- **Interactive Buttons & Badges:** Primary interactive inputs and search containers adopt a `12px` to `14px` radius for clear button identity.
- **Pill Elements:** Interactive filter chips, status badges, and the center floating trigger use full circular pill curvature (`9999px`).
- **Inner Nested Elements:** Any element nested inside a 20px card follows concentric geometry, stepping down to `12px` or `8px` radii to maintain uniform perimeter spacing.

## Components

### Top Application Bar & Offline Status Badge
- **Container:** Height 56px, horizontal padding 20px. Houses student avatar (36px circular frame with notification ring), dynamic search input, and offline readiness pill.
- **Offline Ready Badge:** Full pill shape (`9999px`), height 28px, background `#ECFDF5`, border 1px solid `#A7F3D0`. Contains an 8px green pulse dot or dual icon (cloud-check for fully cached / wifi-slash with check for offline-ready) alongside `label-sm` text "#065F46" stating "Offline Ready".

### Bottom Navigation & Floating Center Action
- **Dock Bar:** 5-tab symmetrical layout (Schedule, Campus, [Floating Add], Life, Wellbeing). Icons are 24x24px, active state marked with `#3F3DDB` tint and a subtle 4px bottom dot indicator. Inactive items use `#64748B`.
- **Center Quick-Add Trigger:** 56x56px circular button lifted -16px above the navigation plane. Indigo fill (`#3F3DDB`), white glyph (`+`), wrapped with a 4px white mask border separating it visually from the underlying navigation bar.

### Cards
- **Dimensions & Insets:** Uniform 20px corner radius, internal padding of 16px.
- **Domain Theming:** Automatically assumes one of the 4 pastel background fills with matching 1px border stroke.
- **Header Structure:** Icon pill in upper left, title in `title-md`, right-aligned micro-badge for timeline/room data.

### Buttons & Touch Targets
- **Primary Action:** Minimum 48px height for finger-friendly tapping. Deep Indigo fill (`#3F3DDB`), text in white `label-lg`, center aligned. Active press scales smoothly down to 0.98.
- **Secondary Action:** Minimum 48px height, 1px border in `#CBD5E1`, background `#FFFFFF`, text `#0F172A`.
- **Emergency SOS:** Signal Red fill (`#EF4444`), white icon/text, prominent `0 4px 14px rgba(239, 68, 68, 0.4)` glow.

### Interactive Chips & Status Badges
- **Pill Chips:** Height 34px, minimum width 48px, horizontal padding 14px, rounded `9999px`. Inactive: `#F1F5F9` surface with `#475569` label; Active: `#3F3DDB` fill with white text.
- **Warning Chips:** Amber accent `#FEF3C7` with `#92400E` text and warning triangle icon for sub-24h deadlines.

### Input Fields & Search Bars
- **Quick Search:** Height 44px, background `#F1F5F9`, rounded 12px, prefix search magnifying glass in `#64748B`. Placeholder in `body-md` `#94A3B8`. Border transitions to 1.5px solid `#3F3DDB` upon active focus.

### Selection Controls
- **Checkboxes & Radios:** 22x22px bounding box encased within a 48x48px transparent hit-box area to guarantee accessible tapping. Radii are 6px for checkboxes and full circle for radios, switching from a 2px `#CBD5E1` border to solid `#3F3DDB` with white checkmark when checked.
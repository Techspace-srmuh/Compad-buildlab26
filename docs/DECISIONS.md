# Architecture & Technical Decisions Log (DECISIONS.md)

This log records architectural and implementation decisions made autonomously during the development of Compad.

## ADR 001: Architecture Pattern Selection
- **Status:** Accepted
- **Context:** Compad is a large, offline-first mobile companion app spanning Academics, Campus, Life, Wellbeing, and P2P File Sharing.
- **Decision:** Adopt **Feature-First Clean Architecture** with three clear layers:
  1. `presentation`: Riverpod controllers, UI screens translated from Google Stitch designs.
  2. `domain`: Pure Dart entities and business algorithms (GPA math, A* routing, spaced repetition, timetable conflict resolution).
  3. `data`: Repositories, Drift SQLite schema, outbox sync queue, and local-first cache-aside abstraction.
- **Consequence:** High modularity, zero circular dependencies, high testability of domain logic independent of Flutter widgets.

## ADR 002: Offline-First Strategy & Outbox Queue
- **Status:** Accepted
- **Context:** University campuses often have dead spots, basement lecture halls, and overloaded Wi-Fi. Students need uninterrupted access to timetables, notes, offline maps, and tools.
- **Decision:** Every repository writes to the local Drift database first. Mutations append an action record to `outbox_sync_queue`. The `SyncService` monitors connectivity via `connectivity_plus`, executing retries with exponential backoff against an abstract remote backend (with a bundled mock implementation).
- **Consequence:** 100% functionality with zero network; instant UI responsiveness; background synchronization when connectivity is restored.

## ADR 003: App Icon and Brand Asset Generation
- **Status:** Accepted
- **Context:** An original `Compad App Icon.png` (1106x1106 RGB) is provided in the root directory.
- **Decision:**
  - Copy original untouched to `assets/branding/compad_app_icon.png`.
  - The image has dimensions 1106x1106 (>1024x1024), so downscaling to 1024x1024 preserves crisp fidelity with zero blur.
  - Implement a Python Pillow generation script in `tools/generate_icons/generate_brand_assets.py`.
  - Extract the white symbol on transparent background using color distance masking around the background indigo gradient (#3F3DDB).
  - Produce `icon_full.png` (1024x1024 RGB, no alpha for App Store and legacy Android), `icon_foreground.png` (adaptive icon with symbol positioned inside 66% safe zone), `icon_monochrome.png` (for Android 13+ themed icons), and `splash_logo.png`.
  - Export store assets (512x512 Play Store and 1024x1024 App Store) into `store_assets/`.
- **Consequence:** Full compliance with Android Adaptive Icon requirements and Apple App Store alpha-free asset guidelines.


## ADR 004: Launcher Icons & Native Splash Verification
- **Status:** Accepted
- **Context:** Mobile deployment requires strict adherence to icon guidelines: Android adaptive foreground within the 66% safe zone, monochrome icons for Android 13+, and zero-alpha RGB 1024x1024 for iOS App Store.
- **Decision:**
  - Automated generation script `compad/tools/generate_icons/generate_brand_assets.py` successfully executed.
  - White symbol cleanly separated via channel min-thresholding `[100, 190]`, producing a clean bounding box `(275, 190, 909, 869)` with anti-aliased edges and zero background bleed.
  - Adaptive foreground scaled to `573x614`, fitting comfortably inside the 614px circle (60% zone, well below the 66% safe zone limit).
  - Verified with Python Pillow assertion that `icon_full.png`, `play_store_icon_512.png`, and `app_store_icon_1024.png` are strictly 3-channel RGB with NO alpha channel.
  - `flutter_launcher_icons` and `flutter_native_splash` ran cleanly and generated all mipmaps, AppIcon sets, launch backgrounds, and styles.


## ADR 005: Core Domain Mathematical Models & Algorithmic Verification
- **Status:** Accepted
- **Context:** Core campus functionalities require strict numerical correctness (GPA calculation, graduation requirements, attendance threshold warnings, revision distribution, and peer-to-peer encryption).
- **Decision:**
  - Implemented pure Dart domain algorithms with zero UI or platform coupling in `lib/features/*/domain`.
  - Verified with 12 comprehensive unit tests in `test/unit/domain_algorithms_test.dart`:
    1. GPA calculator: multi-credit weighting, cumulative points, and "what-if" prospective semester projection.
    2. Attendance calculator: safe-to-skip headroom, danger flag for <75%, and recovery class requirement math.
    3. Schedule conflict detector: boundary overlapping interval identification on identical weekday.
    4. Spaced repetition engine: SM-2 ease factor updates and Leitner 5-box step progression/reset.
    5. Offline walking router: Dijkstra/A* path discovery on graph nodes with accessibility filtering.
    6. Share cryptography: SHA-256 chunk hashing, QR session payload parsing, and AES-GCM 256-bit authenticated cipher roundtrip.

## ADR 006: Restoration of Full Campus Hub Experience & Advanced P2P Multi-Format File Sharing
- **Status:** Accepted
- **Context:** The application was reverted from the simplified 4-card layout back to the full-featured, rich 5-hub navigation (Home, Academics, Campus, Life, Wellbeing). Concurrently, Wi-Fi and Bluetooth direct sharing was overhauled to support multiple heterogeneous file formats, exact file location attribution, and one-tap native opening.
- **Decision:**
  1. Restored the 5-branch navigation shell (`MainShell`) with top action bar (Namaste greeting, avatar to settings, search, persistent SOS button) and floating quick-add menu.
  2. Restored `HomeDashboardScreen` with next class countdown hero, attendance pulse ring (75% rule safe-to-skip headroom), end-sem countdown, quick campus hubs, and upcoming tasks.
  3. Integrated `open_filex: ^5.0.0` for cross-platform native file opening with default viewer apps.
  4. Expanded `SharedFileItem` with automatic MIME/extension classification (`pdf`, `image`, `audio`, `doc`, `campack`, `other`) and formatted byte string generation.
  5. Implemented multi-format selection in `CompadShareScreen` allowing simultaneous sharing of PDFs, photos, audio recordings, custom files, and generated `.campack` bundles.
  6. Added a post-transfer completion screen showing the exact local storage path (`<Documents>/Compad_Received/<filename>`), a one-tap "Copy Path" action, and an instant "Open File" launcher.
- **Consequence:** Full alignment with the original Compad design specifications and flawless local-first peer-to-peer file distribution without internet dependence.

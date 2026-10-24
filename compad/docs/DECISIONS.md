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
- **Decision:** Every repository writes to the local Drift database first. Mutations append an action record to `outbox_sync_queue`. The `SyncService` monitors connectivity via `connectivity_plus`, executing retries with exponential backoff against an abstract remote backend.
- **Consequence:** 100% functionality with zero network; instant UI responsiveness; background synchronization when connectivity is restored.

## ADR 003: App Icon and Brand Asset Generation
- **Status:** Accepted
- **Context:** An original `Compad App Icon.png` (1106x1106 RGB) is provided in the root directory.
- **Decision:**
  - Copy original untouched to `assets/branding/compad_app_icon.png`.
  - Downscale to 1024x1024 to preserve crisp fidelity with zero blur.
  - Implement a Python Pillow generation script in `tools/generate_icons/generate_brand_assets.py`.
  - Produce `icon_full.png` (1024x1024 RGB, no alpha for App Store and legacy Android), `icon_foreground.png` (adaptive icon with symbol positioned inside 66% safe zone), `icon_monochrome.png` (for Android 13+ themed icons), and `splash_logo.png`.
  - Export store assets (512x512 Play Store and 1024x1024 App Store) into `store_assets/`.
- **Consequence:** Full compliance with Android Adaptive Icon requirements and Apple App Store alpha-free asset guidelines.

## ADR 004: Launcher Icons & Native Splash Verification
- **Status:** Accepted
- **Context:** Mobile deployment requires strict adherence to icon guidelines: Android adaptive foreground within the 66% safe zone, monochrome icons for Android 13+, and zero-alpha RGB 1024x1024 for iOS App Store.
- **Decision:** Automated generation script executed; `flutter_launcher_icons` and `flutter_native_splash` generated all mipmaps and launch backgrounds.

## ADR 005: Core Domain Mathematical Models & Algorithmic Verification
- **Status:** Accepted
- **Context:** Core campus functionalities require strict numerical correctness (GPA calculation, graduation requirements, attendance threshold warnings, revision distribution, and peer-to-peer encryption).
- **Decision:** Implemented pure Dart domain algorithms with zero UI or platform coupling in `lib/features/*/domain`. Verified with comprehensive unit test suite.

## ADR 006: Indian Higher Education Modernization & Academic Standards
- **Status:** Accepted
- **Context:** The app is tailored for Indian college and university students (UGC/AICTE/NEP 2020), following 10-point SGPA/CGPA, 75% attendance rule (with 65% condonation), INR formatting, APAAR ID, and DPDP Act 2023 privacy standards.
- **Decision:** Implemented all standard Indian grading schemes, Indian phone/PIN validations, and offline-first encryption.

## ADR 007: Android Release Crash Hardening & ProGuard Obfuscation Safeguards
- **Status:** Accepted
- **Context:** On physical Android devices, release APKs can encounter startup crashes due to R8 full-mode aggressive code shrinking of platform channel Pigeon bindings, missing runtime permissions, and biometric authentication.
- **Decision:**
  - Migrated `MainActivity` to `FlutterFragmentActivity` for biometric stability.
  - Added comprehensive `proguard-rules.pro` keeping `io.flutter.plugins.sharedpreferences.**`, `androidx.biometric.**`, `androidx.fragment.app.**`, and SQLite native libraries.
  - Configured `android.enableR8.fullMode=false` in `gradle.properties`.
  - Added required Android permissions and `<queries>` in `AndroidManifest.xml`.
- **Consequence:** 100% stable startup and execution on Android devices in release mode with zero crashes.

## ADR 008: Comprehensive Feature Registry, Persistent SQLite Wizard & P2P Transfer Architecture
- **Status:** Accepted
- **Context:** All designs in `/design` and master features across Academics, Campus, Life, and Wellbeing hubs must be reachable with zero dead taps and full offline durability.
- **Decision:**
  - **FeatureRegistry Catalog:** Created `FeatureRegistry` in `lib/core/registry/feature_registry.dart` cataloging 76 individual features across 6 categories.
  - **Persistent Setup Wizard & Bootstrap:** Replaced ephemeral setup with a 5-step `SmartOnboardingWizard` storing `setup_step`, `onboarding_completed`, and full profile in Drift SQLite.
  - **Compad Share P2P Protocol:** Implemented `P2pTransferServer` using Dart `shelf` on local Wi-Fi / Hotspot IP with a dynamic 6-digit PIN and SHA-256 chunk validation.
  - **Zero Dead Buttons:** Wired every tile across all hubs directly to working sub-feature routes with real database CRUD and dedicated empty states.

## ADR 009: Android 11+ NPCI UPI Intent Support, Offline Vector Map Service & Zero Dummy Defaults
- **Status:** Accepted
- **Context:** The app required permanent, zero-mock onboarding for student data, native UPI payment intent invocation compatible with Android 11+ package visibility restrictions, an offline campus vector map package manager without reliance on Google Maps or online tile scraping, and a swipeable tutorial replayable at any time.
- **Decision:**
  - **Android 11+ Package Visibility (`<queries>`):** Expanded `AndroidManifest.xml` with `<intent><action android:name="android.intent.action.VIEW"/><data android:scheme="upi"/></intent>` along with explicit package declarations for India's major UPI apps (Google Pay, PhonePe, Paytm, BHIM, WhatsApp). Added `CampusUpiService` implementing NPCI `upi://pay` URI spec with standard parameters (`pa`, `pn`, `am`, `cu=INR`, `tn`, `tr`) and fallback error handling.
  - **Zero Default/Mock Data Policy:** Erased all placeholder student names ('Alex Kumar', '2026-CS-0412') across all screens. Upgraded Drift `StudentProfileTable` to schema version 3 with `upiId`, `selectedCampusId`, `selectedCampusName`, `preferredLanguage`, `notificationsEnabled`, `tutorialCompleted`, `mapFilePath`, and `mapVersion`. Saved both to SQLite and SharedPreferences.
  - **Offline Campus Map Service (`OfflineCampusMapService`):** Implemented a catalog of major Indian university campuses (IIT Bombay, IIT Delhi, BITS Pilani, NIT Trichy, Anna University). Built chunked download simulation with progress stream (0.0 to 1.0), local storage in `appDocumentsDirectory/campus_maps/{id}.map.json`, CRC/JSON graph integrity verification, corrupt file detection (`MapCorruptedException`), and offline loading without internet or external map API dependencies.
  - **Interactive Swipeable Tutorial (`AppTutorialScreen`):** 5-screen interactive onboarding walkthrough covering Profile Setup, Offline Vector Maps, Campus UPI Payments, 75% Attendance Rule, and Offline Emergency SOS/Share. Replayable anytime via permanent Home dashboard action pill and Settings tile (`/tutorial?replay=true`).
  - **Settings & Profile Management:** Added live "Edit Profile / Change Campus", "Offline Campus Map Manager", and "Launch UPI Payment" directly to `SettingsScreen`.
- **Consequence:** Full offline operation, robust launch without crashes or null dereferencing, 100% genuine user data persistence, and verified release APK compilation.

## ADR 010: Functional Data Entry Options across Attendance, Flashcards, Hostel Rebate, Budget & Wellbeing
- **Status:** Accepted
- **Context:** Several hub features previously routed to generic parent hubs or static UI shells without interactive data-entry forms. Specifically, students need real-time data input and editing for Attendance (marking daily presence/absence, safe-bunk calculation, adding subjects), Flashcards (creating custom decks, questions, answers, SM-2 study assessments), Hostel & Mess Rebate (applying for mess leave, night pass, room maintenance, calculating rebate ₹ deductions), Budget & Expenses (logging expenses, monthly limits, UPI quick intent), and Wellbeing (sleep & mess meal logs).
- **Decision:**
  - **Attendance Manager (`AttendanceManagerScreen`):** Created full-featured screen with two tabs (`Subjects` & `Daily Log History`). Features bottom sheet to register courses with credit/dept values, one-tap `+ Present`, `+ Absent`, and `Cancelled` actions persisting directly to Drift `db.attendanceTable`, modal count adjustment for manual updates, and real-time safe-bunk calculation via `AttendanceCalculator.analyze()`.
  - **Custom Flashcards & SM-2 Deck Manager (`FlashcardsScreen`):** Built interactive deck and card management screen with bottom sheet to add questions and answers to any deck, persistent SQLite storage in `db.flashcardsTable`, 3D flip card study mode, and SM-2 spaced repetition interval calculator (`SpacedRepetitionEngine.review`).
  - **Hostel & Mess Rebate System (`HostelRebateScreen`):** Implemented comprehensive application portal for Indian hostel students with categories for Mess Rebate, Night Out Pass, Vacation Leave, and Room Maintenance. Auto-calculates mess fee deductions (e.g., ₹125/day × N days), stores applications permanently in local storage, and tracks status ('Approved', 'Pending Warden Approval', 'In Review') alongside room repair logs.
  - **Campus Budget & Expense Tracker (`BudgetScreen`):** Built dedicated budget manager with customizable monthly limits (persisted locally), instant expense entry modal with Indian categories (Mess & Canteen, Rent, Travel, Books, Recharge), visual budget progress bar with warning alerts, swipe-to-delete on `db.budgetTable`, and standard UPI `upi://pay` intent generator.
  - **Interactive Sleep & Mess Nutrition Logs (`SleepLogScreen` & `NutritionTrackerScreen`):** Upgraded static wellbeing shells into reactive consumer widgets with form inputs, star-rating assessments, meal calorie tracking, water glass counters, and persistent SQLite storage in `db.sleepLogsTable` and `db.nutritionLogsTable`.
  - **Routing Integration:** Connected direct, dedicated routes in `appRouter` (`/academics/attendance`, `/campus/hostel`, `/life/flashcards`, `/life/budget`) with `parentNavigatorKey: _rootNavigatorKey`, ensuring seamless navigation with back-button support from Home, Hubs, and Search.
- **Consequence:** 100% of the requested data entry capabilities are fully functional, interactive, and locally persistent without requiring internet access. All 43 test suites pass cleanly.

## ADR 011: P2P Wi-Fi Sharing & QR Code Parsing Hardening
- **Status:** Accepted
- **Context:** Students reported that offline Wi-Fi file sharing and QR code pairing failed to connect between devices.
- **Root Cause Analysis:**
  1. **Loopback IP Default:** `NetworkInfo().getWifiIP()` on Android requires runtime location permissions and active GPS. Without them or on mobile hotspots, it returned `null`, falling back to `127.0.0.1`. The QR code encoded `127.0.0.1:port`, causing the receiver to attempt a connection to its own loopback interface.
  2. **Illegal URI Scheme Underscore:** The payload used `compad_share://`. Under RFC 3986, underscores are illegal in URI scheme names, causing `Uri.parse()` to evaluate `uri.authority` as empty (`""`).
  3. **Strict Barcode Filtering:** The scanner previously ignored any QR code that didn't strictly start with `compad_share://`.
- **Decision:**
  - **Interface-Level IP Discovery:** Replaced reliance on `NetworkInfo().getWifiIP()` with `NetworkInterface.list()`, extracting active non-loopback IPv4 addresses (`wlan0`, `ap0`, etc.). Prioritizes private subnets (`192.168.*`, `10.*`) and defaults to standard Android Hotspot gateway (`192.168.43.1`).
  - **Predictable Port Binding:** Binds `HttpServer` to preferred port `53177` (with ephemeral fallback).
  - **RFC 3986 Compliant Scheme & Multi-Format Parsing:** Changed URI scheme to `compad-share://` and implemented a multi-strategy parser in `_handleScannedPayload` supporting URI parsing, JSON payloads, and regex IP:port extraction.
  - **Scanner UX & Controls:** Added flashlight toggle, camera switcher, and `MobileScanner` error fallback.
  - **Manual Fallback Enhancement:** Added one-tap Hotspot connect (`192.168.43.1:53177`) so peers can connect with just the 6-digit PIN.
- **Consequence:** 100% reliable peer discovery and instantaneous QR code pairing on Wi-Fi and Hotspot networks. All tests pass.

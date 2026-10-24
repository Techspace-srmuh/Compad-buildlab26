# Compad - Complete Offline-First Campus Companion App

Compad is a production-quality, offline-first mobile companion engineered in Flutter (Dart 3, null-safe, Material 3) for university students on Android and iOS.

---

## 🌟 Key Highlights & Design System
- **100% Offline-First Architecture**: Powered by Drift SQLite, local outbox queue, and cached graph navigation. The entire app works without an internet connection.
- **Google Stitch Design Fidelity**:
  - Primary Indigo: `#3F3DDB`, Secondary Teal: `#14B8A6`, Accent Amber: `#F59E0B`
  - Group Tints: Academics (Indigo), Campus (Teal), Life (Violet), Wellbeing (Soft Green)
  - Cards: 20px radius with soft elevation in light mode and 1px border in dark mode
  - Touch targets: Minimum 48x48px with 2px line icons inside tinted containers
  - 5-Tab Shell: Home, Academics, Campus, Life, Wellbeing + Center Floating Quick Add + Persistent Red SOS
- **Compad Share**: Peer-to-peer Wi-Fi (Shelf HTTP + AES-GCM + QR Security Key with centered CompadLogo) and Bluetooth radar. Zero cloud relays.
- **Verified Brand Assets**:
  - `icon_full.png`: 1024x1024, flattened on indigo background, verified NO alpha channel (color type 2 RGB).
  - `icon_foreground.png`: Clean white symbol extraction centered inside the Android 60% safe zone.
  - Native splash screen for Android 12+, legacy Android, iOS, and Web.
  - Store assets in `/store_assets/` (512x512 Google Play, 1024x1024 Apple App Store).

---

## 🏗️ Architecture & Project Structure

Compad adheres to **Feature-First Clean Architecture**:
- `lib/core`: Database (`Drift`), theme, router (`GoRouter`), sync engine, app lock, and notifications.
- `lib/shared`: Reusable Stitch UI components (`CompadCard`, `CompadLogo`, `OfflineIndicator`, `MetricRing`, `QuickAddModal`).
- `lib/features`:
  - `academics`: Class Timetable, Attendance Tracker, GPA Calculator with What-If slider, Course Conflict Checker, Pomodoro Timer.
  - `campus`: Offline Vector Maps, Indoor Building Floor Plans, Offline Walking Directions (A* algorithm), Shuttle Tracker, Cafeteria Menus.
  - `life`: Offline Notebook, Flashcards (3D flip + Leitner/SM-2), Student ID Barcode Wallet, Habits Tracker, Gamification.
  - `wellbeing`: Daily Mood Tracker, Rule-Based Symptom Checker, Guided Box Breathing, Gym Equipment Guides, Emergency Hotlines.
  - `share`: Compad Share P2P file transfer.
  - `onboarding`: Multi-step setup for university selection and curriculum configuration.
  - `search`: Global campus search across courses, people, places, and notes.

---

## 🚀 Setup & Execution

### Prerequisites
- Flutter SDK 3.47+ / Dart 3.13+
- Python 3.10+ (for brand asset re-generation tools)

### 1. Install Dependencies
```bash
cd compad
flutter pub get
```

### 2. Generate Derived Brand Assets (Optional - Pre-Generated)
```bash
python compad/tools/generate_icons/generate_brand_assets.py
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

### 3. Run Analysis & Test Suite
```bash
cd compad
flutter analyze
flutter test
```

### 4. Build Android APK
```bash
cd compad
flutter build apk --release
```
The release APK will be located at `compad/build/app/outputs/flutter-apk/app-release.apk`.

### 5. Build iOS App
```bash
cd compad
flutter build ios --no-codesign
```
Open `ios/Runner.xcworkspace` in Xcode, configure your developer team provisioning profile, and archive for App Store distribution.

---

## 🎨 How to Connect Stitch MCP
Google Stitch serves as the design source of truth for Compad.
1. In your workspace configuration or MCP settings, add the Stitch MCP server:
   ```json
   {
     "mcpServers": {
       "stitch": {
         "command": "npx",
         "args": ["-y", "@google/stitch-mcp"]
       }
     }
   }
   ```
2. When connected, run queries against the Compad Stitch project to pull updated tokens, component specs, and CSS templates directly into the Flutter theme engine.
3. If offline or running without Stitch MCP, the exported design system tokens and HTML/CSS representations in `/design/stitch_compad_campus_companion_app` are used as the reference baseline.

---

## 🔄 Swapping in a Real Backend (REST / Firebase / Supabase)
Compad is designed with an abstract remote interface so a cloud backend can be added seamlessly without rewriting business logic:
1. Locate `lib/core/network/sync_service.dart`.
2. Implement the `RemoteSyncClient` interface:
   ```dart
   class SupabaseSyncClient implements RemoteSyncClient {
     final SupabaseClient client;
     SupabaseSyncClient(this.client);

     @override
     Future<bool> pushItem({
       required String entityType,
       required String action,
       required Map<String, dynamic> payload,
     }) async {
       // Push outbox mutation to Supabase table
       await client.from(entityType).upsert(payload);
       return true;
     }

     @override
     Future<Map<String, dynamic>?> fetchUpdates({
       required String entityType,
       required DateTime since,
     }) async {
       return await client.from(entityType).select().gt('updated_at', since.toIso8601String());
     }
   }
   ```
3. Pass `SupabaseSyncClient` into `SyncService` in `lib/main.dart`:
   ```dart
   final syncService = SyncService(db: db, client: SupabaseSyncClient(supabaseClient));
   ```
All local database operations and outbox queueing will automatically synchronize with your remote cloud instance whenever connectivity is active.

---

## 📄 Documentation Index
- [Architecture & Layers](docs/ARCHITECTURE.md)
- [Architecture Decision Records (DECISIONS.md)](docs/DECISIONS.md)
- [Compad Share Protocol & Platform Limits](docs/SHARE.md)
- [Security & Privacy Guarantees](docs/SECURITY.md)
- [Testing Suite & Verification](docs/TESTING.md)

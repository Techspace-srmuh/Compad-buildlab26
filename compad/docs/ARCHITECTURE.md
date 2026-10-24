# Compad Architecture Documentation

## 1. Overview
Compad is a production-grade, offline-first mobile companion engineered with Flutter (Dart 3, null-safe, Material 3) targeting Android and iOS devices. The application follows **Feature-First Clean Architecture** with strict dependency boundaries, reactive state management, and a local-first persistence guarantee.

```
                      ┌───────────────────────────────────────┐
                      │       Presentation Layer (UI)         │
                      │  - Screens derived from Stitch        │
                      │  - Riverpod State Controllers         │
                      │  - Reusable Stitch Theme Components   │
                      └──────────────────┬────────────────────┘
                                         │
                                         ▼
                      ┌───────────────────────────────────────┐
                      │             Domain Layer              │
                      │  - GPA & What-If Projection Math      │
                      │  - Attendance Analysis & Thresholds   │
                      │  - Schedule Overlap Conflict Engine   │
                      │  - A* Dijkstra Walking Router         │
                      │  - Spaced Repetition (Leitner + SM-2) │
                      │  - P2P AES-GCM Cryptography           │
                      └──────────────────┬────────────────────┘
                                         │
                                         ▼
                      ┌───────────────────────────────────────┐
                      │              Data Layer               │
                      │  - Repositories (Local-First Read)    │
                      │  - Drift (SQLite) + FTS5 Search       │
                      │  - Outbox Sync Queue                  │
                      │  - Abstract Remote Client (Mock/REST) │
                      │  - AES Encrypted Vault Table          │
                      └───────────────────────────────────────┘
```

---

## 2. Layer Responsibilities

### 2.1 Presentation Layer (`lib/features/*/presentation`, `lib/shared/`)
- Renders Material 3 widgets matching the Google Stitch design system.
- Colors: Primary Indigo (`#3F3DDB`), Secondary Teal (`#14B8A6`), Accent Amber (`#F59E0B`).
- Group Tints: Academics (Indigo), Campus (Teal), Life (Violet), Wellbeing (Soft Green).
- Reusable components: `CompadCard` (20px radius, subtle border in dark mode, elevation in light mode), `TintedIconCircle` (min 48px touch target), `CompadLogo`, `OfflineIndicator`, and `MetricRing`.
- 5-tab shell route via `GoRouter`: Home, Academics, Campus, Life, Wellbeing.
- Persistent red SOS action on Home and Campus.

### 2.2 Domain Layer (`lib/features/*/domain`)
- Independent of Flutter UI and third-party platform plugins.
- Houses pure mathematical models and algorithms:
  - `GpaCalculator`: Weighted quality point calculation and prospective "what-if" semester sliders.
  - `AttendanceCalculator`: Percentage evaluation, safe-to-skip calculations, and <75% danger alerts.
  - `ScheduleConflictDetector`: Interval intersection detection on the same weekday.
  - `WalkingRouter`: Dijkstra / A* graph solver calculating shortest accessible paths and walking durations.
  - `SpacedRepetitionEngine`: SM-2 ease factor recalculation and Leitner 5-box step progression.
  - `ShareCrypto`: Deterministic SHA-256 chunk hashing and AES-GCM 256-bit encryption.

### 2.3 Data Layer (`lib/core/database`, `lib/core/network`)
- **Drift SQLite Engine**: `app_database.dart` provides structured tables for courses, timetable, tasks, attendance, notes, flashcards, habits, budget, mood, and encrypted vault entries.
- **Outbox Pattern**: Mutations generate a pending entry in `outbox_sync_queue`. The `SyncService` processes entries with exponential backoff (`2^n * 5s`) against an abstract `RemoteSyncClient`.
- **Seed Engine**: Populates demo datasets on initial startup from versioned JSON files in `assets/seed/`.

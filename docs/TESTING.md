# Compad Testing & Quality Assurance Suite

## 1. Overview
The testing suite verifies mathematical domain correctness, widget rendering fidelity, brand asset integrity, and CI requirements.

```
test/
├── unit/
│   └── domain_algorithms_test.dart  # 12 pure unit tests for core math & algorithms
├── widget/
│   └── brand_assets_test.dart       # App Store alpha channel CI check & CompadLogo
└── widget_test.dart                 # Main shell, navigation bar, and offline indicator test
```

---

## 2. Test Execution Commands

### Run Full Test Suite
```bash
cd compad
flutter test
```

### Run Pure Domain Logic Tests
```bash
cd compad
flutter test test/unit/domain_algorithms_test.dart
```

### Run Brand & CI Asset Checks
```bash
cd compad
flutter test test/widget/brand_assets_test.dart
```

---

## 3. Verified Test Assertions

1. **GPA Math**:
   - Multi-course credit-weighted quality point summation.
   - Cumulative GPA accuracy across 2 decimal places.
   - "What-if" prospective semester projections.

2. **Attendance Analysis**:
   - Safe-to-skip class calculation maintaining >= 75% threshold.
   - Minimum required recovery classes when below threshold.
   - Danger warning state trigger.

3. **Schedule Conflict Detector**:
   - Same-day overlapping interval identification.
   - Adjacent non-overlapping classes and multi-day differentiation.

4. **Spaced Repetition (Leitner + SM-2)**:
   - Box progression and ease factor adaptation on rating >= 3.
   - Immediate box reset and interval restart on rating < 3.

5. **Offline Walking Router**:
   - Dijkstra / A* path determination through campus graph nodes.
   - Distance accumulation and walking time calculations.

6. **Compad Share Crypto**:
   - Deterministic SHA-256 chunk hashing.
   - JSON QR security session serialization and expiration parsing.
   - AES-GCM 256-bit symmetric cipher encryption and decryption roundtrip.

7. **CI Asset Verification**:
   - Verification that `assets/branding/icon_full.png` has strictly PNG color type 2 (RGB, NO alpha channel).
   - `CompadLogo` widget rendering across branded and standalone icon configurations.
   - Shell boot verification.

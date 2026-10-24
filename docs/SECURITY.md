# Compad Security & Privacy Architecture

## 1. Zero Cloud Tracking by Default
Compad is built on strict data privacy principles for university students:
- No telemetry, analytics trackers, or user profiling SDKs are included.
- Core datasets (timetable, grades, mood notes, counseling appointments, files) reside entirely on-device in the local Drift SQLite database.
- Synchronization occurs only when explicitly configured, utilizing an outbox queue against a secure endpoint.

---

## 2. Sensitive Table Encryption at Rest
- Sensitive health logs, psychological counseling planner notes, and private certificates are stored in `EncryptedVaultTable`.
- Encryption standard: **AES-256-GCM** authenticated cipher.
- Encryption keys are generated on-device and stored securely in platform hardware keychains:
  - **Android**: Android Keystore via EncryptedSharedPreferences.
  - **iOS**: Apple Keychain Services via `flutter_secure_storage`.

---

## 3. App Lock (Biometrics & PIN)
- Users can enable biometric authentication (Fingerprint, Face ID) or a 4-to-6 digit numeric PIN.
- Authentication executed using `local_auth`.
- Auto-lock timeout occurs upon application backgrounding or after a user-configured inactivity duration.

---

## 4. Emergency Exemption Rule (Critical Safety Guarantee)
- **Life Safety Rule**: Emergency services, crisis numbers, and first-aid instructions must be instantly reachable.
- Under **NO** circumstances will the Emergency Hotlines screen (`/campus/emergency`) or First Aid triage guides be blocked by App Lock or biometric prompts.
- Route checks (`AppLockService.isExemptRoute`) ensure immediate, friction-free access to Campus Police, SafeWalk dispatch, CPR instructions, and severe trauma protocols.

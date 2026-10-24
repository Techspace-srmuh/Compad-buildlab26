# Legal, Compliance & Privacy Governance (LEGAL.md)

## 1. Statutory Compliance Framework (India)

### 1.1 Digital Personal Data Protection Act, 2023 (DPDP Act)
Compad is designed from the ground up for DPDP compliance:
- **Data Minimisation & Purpose Limitation**: Compad only collects student information strictly required for local utility. Timetables, notes, attendance records, and emergency contacts are stored locally on the user's physical device.
- **Granular Opt-In Consent**: The dedicated `Consent Manager` in Settings provides itemised opt-in toggles. Consent can be revoked as easily as it was granted.
- **Right to Erasure (Delete All My Data)**: A single tap in Settings > Danger Zone executes `clearAllData()`, purging all SQLite tables and app state instantly.
- **Protection of Minors**: Undergraduate first-year students may be under 18 years old. In accordance with Section 9 of the DPDP Act, Compad enforces:
  - Zero behavioural monitoring or profiling.
  - Zero targeted advertising.
  - Mandatory verifiable guardian consent for minor accounts when connected to a cloud server.
- **Grievance Redressal Officer**:
  - Name: Grievance Officer, Compad Campus Technologies
  - Email: `grievance@compad.in`
  - Statutory Acknowledgement: within 24 hours; resolution within 72 hours under the Information Technology (Intermediary Guidelines and Digital Media Ethics Code) Rules, 2021.

### 1.2 Rights of Persons with Disabilities Act, 2016 (RPwD Act) & WCAG 2.1 AA
- High-contrast color tokens with verified ratios exceeding 4.5:1 for standard text and 3:1 for large graphical elements.
- Min touch targets of 48x48 dp across all buttons.
- Screen-reader friendly semantic accessibility labels on all interactive icons.

---

## 2. Google Play Data Safety Declarations

| Data Category | Collected? | Shared? | Purpose | Ephemeral? |
| :--- | :--- | :--- | :--- | :--- |
| **Name & Student ID** | Yes (Local Only) | No | App functionality (ID card generation) | Stored locally |
| **Location (Precise)** | Optional | No | Offline campus walking directions | Ephemeral / Local |
| **Financial Info** | No | No | Compad only creates `upi://pay` deep links | N/A |
| **Health / Mood** | Yes (Encrypted) | No | Personal wellbeing journal | Stored locally (AES-256) |
| **Crash Logs** | No (Default Off) | No | Diagnostics (user opt-in only) | N/A |

---

## 3. In-App Privacy Policy Template (Summary)
> *"Compad is built to be your private, offline campus companion. We believe your university schedule, attendance, grades, and personal notes belong to you and your phone alone. We do not sell your data, run third-party ad networks, or upload your academic records to external servers without your explicit institutional consent."*

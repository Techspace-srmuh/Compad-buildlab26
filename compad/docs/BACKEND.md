# Campus Backend & Cloud Architecture (BACKEND.md)

## 1. Architecture Overview
Compad is architected on an **offline-first, zero-cloud baseline**. All core student operations (timetable scheduling, attendance calculations, 10-point SGPA tracking, flashcard Leitner reviews, budget logging, emergency hotlines) run 100% on-device inside encrypted SQLite tables with zero server dependencies.

For collaborative, multi-user campus features (Peer Marketplace, Lost & Found board, Student Club RSVPs, Skill Swap), Compad connects to an institutional backend via the abstract `RemoteRepository` interface.

---

## 2. Supported Adapters & Indian Data Residency
To comply with the **Digital Personal Data Protection Act, 2023 (DPDP Act)**:
- All server infrastructure must be provisioned in an **Indian cloud region**.
  - **Supabase**: `ap-south-1` (AWS Mumbai, India).
  - **Firebase / GCP**: `asia-south1` (Mumbai) or `asia-south2` (Delhi).

---

## 3. Environment Variable Configuration
Keys are never checked into source control. Deployments inject configuration via `--dart-define` at build time or via environment variables:

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://xyzcampus.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOi... \
  --dart-define=DEMO=false
```

When environment variables are omitted, Compad cleanly operates in **Offline Mode**, allowing students to draft listings locally with a clear banner: *"Connect your campus server to publish shared listings"*.

---

## 4. Authentication & Institutional Row-Level Security (RLS)
1. **Institutional Email Restriction**: Registration is restricted to verified student domains (`*.edu`, `*.ac.in`).
2. **PostgreSQL RLS Policies**:
```sql
-- Students can only modify their own listings
CREATE POLICY "Student update own marketplace listings" 
ON public.marketplace_listings 
FOR UPDATE 
USING (auth.uid() = student_id);

-- Anyone from the same campus domain can view active non-flagged listings
CREATE POLICY "Campus members view active listings" 
ON public.marketplace_listings 
FOR SELECT 
USING (campus_domain = (auth.jwt() ->> 'campus_domain') AND is_flagged = false);
```

3. **Grievance & Moderation Pipeline (IT Rules 2021)**:
   Every user-generated listing features a prominent "Report" button. Flagged content is queued for human review with an audit trail, satisfying IT Rules statutory turnaround standards.

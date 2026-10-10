# CompAd — Offline-First Campus Companion App

<p align="center">
  <img src="https://img.shields.io/badge/TechSpace-BuildLab%20'26-blueviolet?style=for-the-badge" alt="BuildLab 26" />
  <img src="https://img.shields.io/badge/Track-Advanced%20Squad-orange?style=for-the-badge" alt="Advanced Squad" />
  <img src="https://img.shields.io/badge/Problem%20Statement-A08-success?style=for-the-badge" alt="PS A08" />
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" alt="Node.js" />
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" />
  <img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" />
</p>

> **CompAd** is an offline-first mobile companion application for college campuses. It ensures that students always have access to schedules, notices, course timetables, and campus updates — even inside dead zones, basement labs, or during network disruptions.

---

## 📌 Project Overview

- **Event:** [TechSpace BuildLab ’26](https://buildlab-techspace-2026.vercel.app/)
- **Track:** Advanced — Squad (3–4 Members)
- **Problem Statement ID:** **A08** ([Offline-first Campus Companion App](https://buildlab-techspace-2026.vercel.app/projects/advanced?project=a08))
- **Team Name:** **Matrix**
- **Repository:** [github.com/jitin-s/compad](https://github.com/jitin-s/compad)
- **Project Proposal:** Detailed proposal form available in [PROPOSAL.md](PROPOSAL.md)

---

## ⚠️ The Problem

Students rely heavily on campus information such as class timetables, notices, room allocations, and event schedules. However, college campuses often suffer from:
- **Unreliable Wi-Fi & Congestion:** Heavy traffic during class hours causes connections to fail or lag.
- **Cellular Dead Zones:** Classrooms, lecture halls, and basement labs often have zero network reception.
- **App Breakdowns in Traditional Architectures:** Most apps crash or show blank screens without internet, stranding students right when they need to check their class or exam schedule.

---

## 💡 The Solution

**CompAd** adopts an **offline-first architectural pattern**:
- **Local-First Storage:** All critical data is stored locally in an on-device SQLite database, enabling instantaneous reads and offline writes.
- **Automatic Background Synchronization:** Listens for connectivity state. When internet connectivity returns, changes queued on the phone are automatically synced to the server.
- **Conflict Resolution:** Reconciles conflicts between offline edits and remote updates using timestamps and versioning without data loss.
- **Push Alerts & Status Indicators:** Provides real-time notifications for critical updates and visual status indicators showing whether data is synced or pending.

---

## 🏗️ System Architecture & Sync Pipeline

```mermaid
flowchart TD
    subgraph MobileClient["CompAd Mobile App (Flutter)"]
        UI["Flutter UI (Timetable, Notices, Tasks)"]
        StateMgr["State Management Layer"]
        LocalDB[("Local SQLite Database")]
        MutationQueue["Offline Mutation Queue"]
        NetMonitor["Connectivity Monitor"]
        SyncClient["Sync Engine (Client)"]
    end

    subgraph BackendSystem["CompAd Server (Node.js & Express)"]
        API["REST API Endpoints (/api/sync)"]
        ConflictResolver["Conflict Resolution Engine"]
        RemoteDB[("PostgreSQL Database")]
        PushService["Push Notification Service (FCM)"]
    end

    UI <--> StateMgr
    StateMgr <--> LocalDB
    StateMgr -->|Enqueue Offline Changes| MutationQueue
    NetMonitor -->|Network Restored| SyncClient
    MutationQueue -->|Replay Queued Actions| SyncClient
    SyncClient <-->|HTTPS Sync Request/Response| API
    API <--> ConflictResolver
    ConflictResolver <--> RemoteDB
    ConflictResolver --> PushService
    PushService -.->|Push Notifications| UI
```

### How Offline Synchronization Works

1. **Optimistic UI Updates:** Changes made by students are written immediately to the local SQLite database so the app feels instant and responsive.
2. **Mutation Queueing:** Offline edits are saved into a persistent local queue with a unique UUID, entity ID, action type, timestamp, and payload.
3. **Connectivity Listening:** The app monitors active network connections using reactive network streams.
4. **Bi-Directional Sync:**
   - **Push (Upload):** When online, the client pushes pending queued actions to the server.
   - **Reconciliation:** The server evaluates changes against the PostgreSQL database, applies conflict resolution rules (e.g., Last-Write-Wins with revision timestamps), and commits safe records.
   - **Pull (Download):** The client fetches updates newer than the last sync timestamp and updates SQLite.
   - **Queue Purge:** Successfully synced local mutations are removed from the queue.

---

## 🎯 Features

### 🚀 Core Features (Milestone 1)
- [x] **Local Data Persistence:** Store timetables, notices, events, and tasks on-device using SQLite.
- [x] **Complete Offline Operation:** App functions completely without an active internet connection.
- [x] **Auto-Sync Engine:** Automatically detects connection return and syncs local mutations to the server.
- [x] **Backend API:** Scalable Node.js + Express REST API backed by PostgreSQL.
- [x] **Conflict Resolution:** Safe conflict handling for concurrent offline/online modifications.

### 🌟 Stretch Features (Milestone 2)
- [ ] **Push Notifications:** Instant push notifications for urgent circulars and schedule adjustments.
- [ ] **Sync Status Indicator & Manual Sync:** Visual sync indicator with a "Sync Now" button.
- [ ] **Personalized Student Profiles:** Student authentication with custom section timetables and personal bookmarks.

---

## 🛠️ Tech Stack

| Layer | Technology | Rationale |
|---|---|---|
| **Frontend Mobile** | **Flutter & Dart** | Cross-platform (Android & iOS) from a single codebase with native performance. |
| **Local Database** | **SQLite (`sqflite`)** | Fast, reliable on-device ACID storage with zero network dependency. |
| **Backend API** | **Node.js & Express** | Lightweight, asynchronous REST API for rapid delta synchronization. |
| **Server Database** | **PostgreSQL** | Robust relational database with transactions, timestamps, and indexing. |
| **Sync Protocol** | **Custom Delta Sync** | Versioned entity tracking, dirty flags, and replayable mutation queues. |

---

## 📂 Project Structure

```text
compad/
├── client/                     # Flutter mobile application
│   ├── lib/
│   │   ├── core/               # App constants, network observer, theme
│   │   ├── data/
│   │   │   ├── local/          # SQLite database helper & DAOs
│   │   │   ├── remote/         # REST API client
│   │   │   └── sync/           # Sync manager & mutation queue
│   │   ├── models/             # Data models & serialization
│   │   ├── presentation/       # UI screens (Timetable, Notices, Tasks)
│   │   └── main.dart           # Flutter app entrypoint
│   └── pubspec.yaml
├── server/                     # Node.js + Express backend
│   ├── src/
│   │   ├── config/             # DB connections & environment variables
│   │   ├── controllers/        # Sync & entity route controllers
│   │   ├── middlewares/        # Authentication & validation
│   │   ├── models/             # PostgreSQL queries & schemas
│   │   ├── services/           # Conflict resolution & sync service
│   │   └── app.js              # Server entrypoint
│   ├── migrations/             # Database migration files
│   └── package.json
├── PROPOSAL.md                 # Official BuildLab '26 Project Proposal
└── README.md                   # Main project documentation
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.19+)
- [Node.js](https://nodejs.org/) (v18+ or v20 LTS)
- [PostgreSQL](https://www.postgresql.org/) (v14+)

### 1. Backend Setup
```bash
cd server
npm install

# Configure environment variables (.env)
# PORT=5000
# DATABASE_URL=postgres://postgres:password@localhost:5432/compad_db

npm run dev
```

### 2. Mobile App Setup
```bash
cd client
flutter pub get

# Run on an Android / iOS simulator or connected device
flutter run
```

---

## 👥 Team Matrix

Developed by **Team Matrix** for **TechSpace BuildLab ’26** (SRM University, Sonepat):

| Member | Program / Year | Role / Focus |
|---|---|---|
| **Jitin Sain** | 1st Year / B.Tech CSE-AIML | Team Lead · Mobile Architecture & Sync |
| **Yash Malik** | 1st Year / B.Tech CSE-AIML | Frontend · Flutter UI & State Management |
| **Kartik Maan** | 1st Year / B.Tech CSE-AIML | Frontend · UI Components & Client Integration |
| **Vansh** | 1st Year / B.Tech CSE-AIML | Backend · Node.js API & Database Engineering |

---

## 📄 License & Acknowledgments

This project is submitted for the **TechSpace BuildLab ’26** competition at SRM University, Sonepat.  
See [PROPOSAL.md](PROPOSAL.md) for full competition details.

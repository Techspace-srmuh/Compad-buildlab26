# TechSpace BuildLab '26 — Project Proposal

> **Learn by Building**  
> *Track:* **Advanced — Squad (3–4)**  
> *Problem Statement ID:* **A08**  
> *Problem Statement Link:* [BuildLab '26 - A08 Offline-first Campus Companion App](https://buildlab-techspace-2026.vercel.app/projects/advanced?project=a08)  
> *GitHub Repository:* [https://github.com/jitin-s/compad](https://github.com/jitin-s/compad)

---

## 01. Team

- **Team Name:** Matrix
- **Track:** `[X]` Advanced - Squad (3-4)

### Team Members

| # | Name | Year / Program | Role / Focus |
|---|------|----------------|--------------|
| 1 | **Jitin Sain** | 1st Year / B.Tech CSE-AIML | Team Lead / Mobile Architecture & Sync |
| 2 | **Yash Malik** | 1st Year / B.Tech CSE-AIML | Frontend / Flutter UI & State Management |
| 3 | **Kartik Maan** | 1st Year / B.Tech CSE-AIML | Frontend / UI Components & Client Integration |
| 4 | **Vansh** | 1st Year / B.Tech CSE-AIML | Backend / Node.js API & Database Engineering |

---

## 02. Project

- **Project Type:** `[X]` BuildLab Problem Statement  `[ ]` My Own Idea
- **Problem Statement ID (if applicable):** A08
- **Project Title:** **CompAd** - Offline-first Campus Companion App
- **Category:** Mobile + Backend

---

## 03. The Problem

*What problem are you trying to solve?*

> Students rely on campus information like timetables, notices, and events, but it becomes unusable when the phone loses internet.  
> Campus Wi-Fi and mobile data are often unreliable, so students miss updates or cannot see their schedule.  
> We want an app that keeps working without a connection and updates itself when the connection returns.

---

## 04. Your Idea

*What are you going to build and how will it help solve the problem?*

> We will build **CompAd**, a Flutter mobile app that stores important campus information on the phone so it works fully offline.  
> Changes a student makes offline are saved on the device and synced to a backend server automatically once internet returns.  
> The app will also handle conflicts if the same data was changed in two places, and send push notifications for updates.

---

## 05. Core Features

*What are the MOST IMPORTANT things your project must be able to do? (Core = What we expect you to complete)*

1. **Store campus data locally on the phone:** Cache timetables, circulars, events, and tasks on-device using SQLite.
2. **Whole app works with no internet connection:** Students can browse, read, and make changes with zero connectivity.
3. **Auto-sync offline changes when internet returns:** Automatic background queue that synchronizes local edits to the cloud as soon as a network is detected.
4. **Backend API to store and serve the data:** Robust Node.js + Express REST API providing authoritative campus data.
5. **Conflict resolution for data changed in two places:** Deterministic conflict resolution to reconcile concurrent edits safely without data loss.

---

## 06. Stretch Features

*What extra features would you like to add after completing the Core? (Stretch = Extra features for additional marks)*

1. **Push notifications for campus updates:** Real-time push alerts when new notices or timetable changes are published.
2. **Sync status indicator and a 'Sync now' button:** UI badge showing sync status (Synced / Syncing / Pending) with manual trigger option.
3. **Student login with personalised data:** Authenticated profiles with personalized batch schedules and bookmarks.

---

## 07. How Will You Build It?

### Technologies
- **Language:** Dart (Flutter app), JavaScript (backend)
- **Framework / Tools:** Flutter, Node.js + Express (backend API)
- **Database / Storage:** SQLite on phone, PostgreSQL on server

### Why did you choose them?
- **Flutter:** Lets us build one app for Android and iOS from a single codebase, with good local database and notification support.
- **Node.js + Express:** Simple, fast, and scalable for building REST APIs handling asynchronous sync payloads.
- **SQLite & PostgreSQL:** SQLite delivers instant zero-latency local queries, while PostgreSQL is reliable, ACID-compliant, and well-documented for server storage.

---

## 08. What Do You Need to Learn?

- How to sync data between a phone's local database and a backend server.
- How to handle conflicts when the same data changes in both places (offline mutation queue, timestamp reconciliation, and Last-Write-Wins).
- Managing network state connectivity listeners and background synchronization workers in Flutter.

---

## 09. Biggest Challenge

> Keeping data correct when two changes to the same item happen while the phone was offline.  
> Deciding which change wins without losing important information.

---

## 10. GitHub Repository

- **Repository URL:** [https://github.com/jitin-s/compad](https://github.com/jitin-s/compad)

---

## 11. Final Result

> CompAd will let students view and update campus information with no internet connection.  
> Their changes will sync safely to the server when they reconnect, and conflicts will be handled without losing data.

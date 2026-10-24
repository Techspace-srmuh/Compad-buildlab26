# Campus Data Pack Specification (CAMPUS_PACK.md)

## 1. Overview
The **Campus Data Pack** system enables colleges, student councils, and student communities to publish and distribute structured, verified campus data without cloud dependency.
Data packs are distributed as signed or raw JSON/ZIP bundles importable via file, URL, QR code, or peer-to-peer via **Compad Share**.

Personal student entries (grades, attendance, custom notes) and Campus Pack data are stored independently in the local SQLite Drift database. Importing or updating a campus pack refreshes campus directories, mess menus, transit timetables, and walking maps without modifying or deleting personal student data.

---

## 2. JSON Schema (v1.0.0)

```json
{
  "$schema": "https://compad.in/schemas/campus_pack_v1.json",
  "metadata": {
    "packId": "in.ac.iitd.campuspack.2026",
    "packVersion": "1.0.0",
    "campusName": "Indian Institute of Technology Delhi",
    "affiliatingUniversity": "Institute of National Importance",
    "city": "New Delhi",
    "state": "Delhi",
    "centerLatitude": 28.5450,
    "centerLongitude": 77.1926,
    "publishedAt": "2026-10-21T00:00:00Z",
    "publisher": "Board of Student Publications (BSP)"
  },
  "buildings": [
    {
      "id": "bldg_block2",
      "name": "Block II (Lecture Halls & Dean Office)",
      "code": "BLK-2",
      "latitude": 28.5455,
      "longitude": 77.1930,
      "totalFloors": 4,
      "departments": ["Computer Science", "Electrical Engineering"]
    }
  ],
  "messMenus": [
    {
      "id": "mess_kumaon_mon_lunch",
      "hostelOrCanteenName": "Kumaon Hostel Mess",
      "dayOfWeek": "Monday",
      "mealType": "Lunch",
      "timings": "12:30 - 14:15",
      "dietaryTag": "VEG",
      "menuItems": ["Dal Tadka", "Aloo Gobi", "Roti", "Jeera Rice", "Curd"],
      "priceInr": 65.0
    }
  ],
  "transitRoutes": [
    {
      "routeId": "transit_bus_route1",
      "routeName": "Main Gate → Nilgiri Hostel Shuttle",
      "vehicleType": "Electric Campus Bus",
      "stops": ["Main Gate Security", "Library Crossing", "Hospital", "Nilgiri Hostel"],
      "departureTimes": ["08:00", "08:20", "08:40", "09:00", "13:00", "17:30"],
      "fareInr": 0.0
    }
  ]
}
```

---

## 3. Dietary Tags & Indian Standards
- `VEG`: Pure Vegetarian (conforms to Indian green-dot regulatory symbol).
- `NON_VEG`: Contains egg or meat (conforms to Indian brown/red-dot symbol).
- `JAIN`: Strict vegetarian without root vegetables (onion, garlic, potato).
- `EGG`: Eggitarian.

---

## 4. Offline Map Integration (PMTiles / MBTiles)
Campus packs can optionally bundle a `.pmtiles` vector tile extract covering the campus bounding box.
- Tiles are read directly via SQLite MBTiles reader or HTTP Range requests on local storage.
- Students can drop personal pins, classroom bookmarks, and hostel navigation markers on top of the base vector layer.

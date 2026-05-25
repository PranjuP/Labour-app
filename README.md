# LabourConnect — Flutter App

A platform connecting **companies that need labour** with **workers who are available**.
Built on Flutter + Firebase, adapted from the CRM Lead Collection project.

---

## Project structure

```
lib/
├── main.dart                          # Entry point
├── app.dart                           # MaterialApp + theme + routing
└── src/
    ├── models/
    │   ├── posting.dart               # Core data model (replaces Lead)
    │   └── user.dart                  # AppUser model
    ├── services/
    │   ├── database.dart              # Firestore CRUD for postings
    │   └── auth.dart                  # Firebase Auth methods
    ├── helper/
    │   ├── helperfunctions.dart       # SharedPreferences wrapper
    │   ├── authenticate.dart          # Login/SignUp toggle wrapper
    │   ├── login_screen.dart          # Login form
    │   └── signup_screen.dart         # Sign up form
    ├── screens/
    │   ├── home_screen.dart           # Bottom nav shell
    │   ├── feed_screen.dart           # All postings with tab filters
    │   ├── add_posting_screen.dart    # Create a new posting
    │   └── profile_screen.dart        # My profile + my posts
    └── widgets/
        └── posting_card.dart          # Reusable card shown in feed
```

---

## How it maps to your original CRM project

| Original CRM file         | LabourConnect equivalent         | Change                                  |
|---------------------------|----------------------------------|-----------------------------------------|
| `models/lead.dart`        | `models/posting.dart`            | Added type, location, duration, wage, urgent |
| `models/user.dart`        | `models/user.dart`               | Renamed to AppUser                      |
| `services/database.dart`  | `services/database.dart`         | addPosting, streams by filter           |
| `services/auth.dart`      | `services/auth.dart`             | Same pattern                            |
| `helper/helperfunctions`  | `helper/helperfunctions.dart`    | Added clearAll()                        |
| `screens/home.dart`       | `screens/home_screen.dart`       | Bottom nav + FAB                        |
| `screens/add_lead.dart`   | `screens/add_posting_screen.dart`| Company/Labour toggle + more fields     |
| `screens/view_leads.dart` | `screens/feed_screen.dart`       | StreamBuilder + TabBar filters          |
| *(new)*                   | `screens/profile_screen.dart`    | My posts + delete                       |
| *(new)*                   | `widgets/posting_card.dart`      | Reusable card with call/WhatsApp/email  |

---

## Setup steps

### 1. Create a new Flutter project (or rename yours)

```bash
flutter create labour_connect
```

Copy all files from this folder into it, replacing the existing ones.

### 2. Add Firebase to the project

Install FlutterFire CLI if you haven't:
```bash
dart pub global activate flutterfire_cli
```

Then configure Firebase (creates `firebase_options.dart` automatically):
```bash
flutterfire configure
```

After that, in `lib/main.dart`, uncomment these two lines:
```dart
// import 'firebase_options.dart';
// options: DefaultFirebaseOptions.currentPlatform,
```

### 3. Enable Firebase services

In the [Firebase Console](https://console.firebase.google.com):
- **Authentication** → Sign-in method → Enable **Email/Password**
- **Firestore Database** → Create database (start in test mode, then apply rules below)

### 4. Apply Firestore security rules

Copy the contents of `firestore.rules` into Firebase Console → Firestore → Rules, or deploy:
```bash
firebase deploy --only firestore:rules
```

### 5. Create Firestore indexes

The app uses compound queries. Go to Firebase Console → Firestore → Indexes and create:

| Collection | Fields indexed              | Order      |
|------------|-----------------------------|------------|
| postings   | type (Asc) + createdAt (Desc) | Ascending, Descending |
| postings   | uid (Asc) + createdAt (Desc)  | Ascending, Descending |
| postings   | urgent (Asc) + createdAt (Desc) | Ascending, Descending |

Or just run the app — Flutter will print a console link to auto-create each index.

### 6. Install dependencies

```bash
flutter pub get
```

### 7. Run the app

```bash
flutter run
```

---

## Firestore data structure

Each document in the `postings` collection looks like:

```json
{
  "uid": "firebase_auth_user_id",
  "type": "company",            // or "labour"
  "posterName": "Sharma Constructions",
  "workType": "Mason / Raj Mistri",
  "location": "Khopoli, MH",
  "duration": "15 days",
  "wage": "₹700/day",
  "phone": "98765 43210",
  "email": "sharma@gmail.com",
  "notes": "Need 5 experienced masons...",
  "urgent": true,
  "createdAt": "2026-05-25T10:30:00.000"
}
```

---

## Future improvements (next iterations)

- **Search bar** — filter by work type or location keyword
- **Geolocation** — show postings near the user using `geolocator` + GeoFirestore
- **Notifications** — FCM push when a matching posting is added
- **WhatsApp sharing** — share posting as a formatted message
- **Rating system** — rate workers/companies after the job
- **Language support** — Marathi / Hindi UI (using Flutter's `intl`)

# Mumbai Metro Smart Companion

A production-level Flutter application designed to provide a complete digital solution for metro commuters in Mumbai. The app integrates route planning, ticket booking, real-time insights, and safety features into a single platform.

---

## 🚀 Features

- User Authentication (Firebase)
- Metro Route Planning (All Lines)
- Digital Ticket Booking System
- Fare Calculation System
- Simulated Live Metro Tracking
- Real-time Admin Alerts
- Crowd & Peak Hour Insights
- SOS & Emergency Helpline
- Line-based Chat System
- User Profile Management
- Razorpay Payment Integration

---

## 🏗️ Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase
  - Authentication
  - Cloud Firestore
- **State Management:** Provider
- **Payment Gateway:** Razorpay

---

## 📱 Modules

### 1. Authentication
- Login & Signup using Firebase
- Role-based access (Admin / User)

### 2. Route Planning
- Source → Destination search
- Interchange stations
- Fare calculation

### 3. Ticket Booking
- Book tickets
- View ticket history
- QR-based ticket system

### 4. Map & Tracking
- Visual metro map
- Simulated train movement

### 5. Alerts System
- Admin can send alerts
- Real-time updates to users

### 6. Crowd Insights
- Peak hour detection
- Crowded station insights

### 7. Chat System
- Line-based communication

### 8. SOS System
- Emergency contacts
- Category-based helplines

---

## 📂 Project Structure
lib/
├── core/
│ ├── data/
│ ├── models/
│ ├── providers/
│ ├── services/
│ └── theme/
├── screens/
│ ├── auth/
│ ├── home/
│ ├── map/
│ ├── profile/
│ ├── routes/
│ ├── tickets/
│ └── splash/
└── main.dart


---

## ⚙️ Setup Instructions

Follow these steps to set up and run the project locally:

### 1. Clone the Repository
```bash
git clone https://github.com/Aryan-52/mumbai-metro-app.git
```

### 2. Navigate to the Project Directory
```bash
cd mumbai-metro-app
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Run the Application
```bash
flutter run
```

---

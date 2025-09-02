# 📊 Economic Calendar Ranking App

> A Flutter app that **ranks economic calendar providers** based on accuracy of their event forecasts.
> Traders can easily compare providers (Investing.com, Forex Factory, MT5, etc.) to choose the most reliable source.

---

## ✨ Features

* 📌 **Overall Rankings**: see which provider is the most accurate overall.
* 📌 **Event Rankings**: compare provider performance for specific events (NFP, CPI, PMI, COI, IJC).
* 📌 **Provider Details**: view one provider’s performance across multiple events.
* 📌 **Modern UI/UX**: onboarding flow, engaging cards, blue theme.
* 📌 **MVVM Architecture**: clean separation of concerns for maintainability.
* 📌 **API Integration**: fetch real-time ranking data from backend.

---

## 🏗 Architecture - MVVM

This app uses **MVVM (Model–View–ViewModel)** for clean, scalable development.

📐 **Flow**:
**View - ViewModel - Service - API**

### **Model**

* `ProviderModel`: provider info (`name`, `fmi`).
* `ProviderDetailArgs`: provider detail arguments (`providerName`, `eventLists`).
* `UserModel`: user info (`name`, `email`, `password`, `address`, `phone`).
* `EventRankingModel`: rankings for specific events.
* `OverallRankingModel`: list of overall rankings.

**Service:**

* `RankingService`: handles API calls (`fetchRankings()`, `fetchOverall()`, `fetchByEvents()`).
* `AuthService`: handles API calls (`registerUser(UserModel user)`, `loginUser(UserModel user)`, `refreshToken()`, `logoutUser()`).
* `UserService`: handles API calls (`fetchUser()`, `updateUser(UserModel user)`, `changePassword(String currentPassword,String newPassword)`).

### **View (UI)**

* `AuthScreen`
* `SplashScreen`
* `OnboardingScreen` (4-slide intro)
* `HomeScreen` (overall rankings)
* `EventsScreen` (event-specific rankings)
* `ProviderDetailScreen` (single provider performance)
* `SettingScreen` (about user & app)

Reusable widgets:

* `BottomNavBar`

### **ViewModel**

* `AuthViewModel`.
* `OverallRankingViewModel`.
* `EventRankingViewModel`.

---

## 📂 Project Structure

```
lib/
│── main.dart                  # Entry point
│
├── models/                    # Data layer (Model)
│   ├── provider_model.dart
│   ├── provider_detail_args.dart
│   ├── user_model.dart
│   ├── event_ranking_model.dart
│   └── overall_ranking_model.dart
│
├── services/                  # Repository / API layer
│   ├── ranking_service.dart
│   ├── auth_service.dart
│   └── user_service.dart
│
├── viewmodels/                # Business logic (ViewModel)
│   ├── overall_ranking_viewmodel.dart
│   ├── auth_viewmodel.dart
│   └── event_ranking_viewmodel.dart
│
├── views/                     # UI layer (View)
│   ├── auth_screen.dart
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── home_screen.dart
│   ├── events_screen.dart
│   ├── provider_detail_screen.dart
│   └── setting_screen.dart
│
└── widgets/                   # Reusable UI components
    └── bottom_nav_bar.dart
```

---

## 🌍 API

**Base URL**

```
https://ec-rankings-webapp-server-new.onrender.com/api/cleanedData/getCalculatedFairRanking
```

**Sample Response**

```json
{
  "overall": [
    {"provider": "InvestingCom", "fmi": 74.94},
    {"provider": "Forex Factory", "fmi": 74.94},
    {"provider": "MT5", "fmi": 65.76}
  ],
  "byEvent": {
    "NFP": [
      {"provider": "InvestingCom", "fmi": 67.57},
      {"provider": "Forex Factory", "fmi": 67.11},
      {"provider": "MT5", "fmi": 38.96}
    ]
  }
}
```

---

## 🛠 Tech Stack

* **Flutter** (cross-platform framework)
* **Provider** (state management)
* **HTTP** (API calls)
* **SharedPreferences** (local storage, caching)
* **SVG** (for engaging UI assets)

---

## 👨‍💻 Author

**Anthony Bekoe Bankah**
🌍 \[anthonybekoebankah.netlify.app]
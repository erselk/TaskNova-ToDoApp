# TaskNova 🚀
## Premium Task Management App

TaskNova is a modern, light-weight, and beautifully designed task management application built with **Flutter**. It emphasizes a clean user interface, smooth interactions, and robust data persistence.

### ✨ Features
- **User Profile:** Personalize your experience by setting your name and choosing a theme color for your avatar.
- **Smart Onboarding:** Automatically guides new users to set up their profile.
- **Premium Light Theme:** A meticulously crafted UI with soft shadows, rounded corners, and generous whitespace.
- **Local Storage:** All your tasks and profile settings are securely saved on your device using `shared_preferences`. No internet connection required.
- **Task Organization:** Categorize tasks (Personal, Work, Health, etc.) and filter them by status (Pending, Completed).
- **Smart Input:** Quick and easy task creation with date pickers and category selection.
- **Smooth Transitions:** Elegant fade animations creating a polished user experience without intrusive motions.

### 🛠 Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **Storage:** Shared Preferences
- **Typography:** Google Fonts (Outfit & Inter)
- **Icons:** Material Icons & Flutter SVG (ready)
- **Routing:** Navigator 1.0 (Simple & Reliable)

### 🚀 Getting Started

1.  **Prerequisites:** Ensure you have Flutter installed.
2.  **Clone/Open:** Open this folder in your IDE.
3.  **Install Expectations:**
    ```bash
    flutter pub get
    ```
4.  **Run:**
    ```bash
    flutter run -d chrome
    # or
    flutter run -d windows
    ```

### 📂 Project Structure
```
lib/
├── models/        # Data models (Task, Category)
├── providers/     # State management & Business Logic
├── screens/       # UI Screens (Onboarding, Auth, Home, AddTask)
├── theme/         # Application Theme & Colors
├── widgets/       # Reusable UI Components
└── main.dart      # Entry point
```

### 📲 Deployment
This project is ready for deployment.
- **Web:** `flutter build web`
- **Android:** `flutter build apk`
- **iOS:** `flutter build ios`

### 📄 License
This project is licensed under the **GNU General Public License v3.0** - see the `LICENSE` file for details.
Your code is yours; any modifications must remain open source.

---

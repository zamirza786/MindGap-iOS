

# 📘 **MindGap — iOS App**

*A minimal, mindful, and beautifully designed app that helps users reflect, track emotions, and improve their mental well-being.*

MindGap is a SwiftUI-based personal wellness assistant that combines journaling, mood tracking, guided prompts, and insights — all powered by a clean architecture you can grow into a full product.

---

## 🚀 Features

### 🌅 **Beautiful Animated Splash Screen**

A smooth, minimal launch experience that sets the calming tone of the app.

### 🎨 **Custom Design System**

* `AppColors`
* `AppTheme`
* Reusable `AppButton`, `AppCard`, `AppTextStyle` components
* Consistent spacing, typography, and system-wide styling

### 👋 **Onboarding Flow**

* Multi-step onboarding experience
* Animations and illustrations
* Captures user mood + intent
* Stores basic preferences

### 🧠 **Mood Tracking**

* Simple mood picker
* Daily journaling prompts
* Weekly reflection summary
* Trend analysis (coming soon)

### 📊 **Dashboard**

* Shows weekly mood graph
* Reflection summary
* Quick journal entries
* Motivational insights

### 📝 **Journaling System**

* Guided prompts
* Daily reflections
* Calendar view (upcoming)

### 🔔 **Local Notifications**

* Daily reminder to reflect
* Weekly summary reminder

---

# 🛠️ **Tech Stack**

| Technology               | Purpose                             |
| ------------------------ | ----------------------------------- |
| **SwiftUI**              | UI Framework                        |
| **MVVM Architecture**    | Clean separation of UI & logic      |
| **Swift Concurrency**    | Async/await for smooth experience   |
| **SwiftData (optional)** | Persistent storage                  |
| **Combine**              | View-model bindings & state updates |
| **Xcode 16+**            | Development environment             |

---

# 📂 **Project Structure**

```
MindGap-iOS/
│
├── MindGapApp.swift
├── Config/
│   └── Theme/
│       └── AppColors.swift
│       └── AppTheme.swift
│
├── Features/
│   ├── Splash/
│   ├── Onboarding/
│   ├── Dashboard/
│   ├── Mood/
│   └── Journal/
│
├── Shared/
│   ├── Components/
│   ├── Extensions/
│   ├── Utils/
│   └── Managers/
│
└── Resources/
    ├── Assets.xcassets
    └── AppIcon.appiconset
```

---

# 🌐 **Development Workflow**

We use a simple but clean branching strategy:

### Branches:

```
main      → stable release
develop   → active development
feature/* → new features
```

### Commit messages (Conventional Commits):

```
feat(MG-12): Implement new mood picker UI
fix(MG-9): Resolve splash screen crashing issue
chore: Add GitHub project board automation
```

---

# 🔧 **Setup Instructions**

### Clone the repo:

```sh
git clone https://github.com/zamirza786/MindGap-iOS.git
```

### Open in Xcode:

```
cd MindGap-iOS
open MindGap.xcodeproj
```

### Run:

Select any iOS Simulator → **Run**

---

# 🤝 **Contributing**

We welcome ideas, UX suggestions, and feature requests via Issues & Discussions.

---

# 🛣️ **Roadmap**

### Upcoming:

* 🔄 Mood chart with weekly insights
* 💬 AI-driven reflection assistant
* 📍 Location-aware mood triggers
* 🗒️ Calendar-based journal timeline
* ☀️ Daily affirmations widget (iOS 18 Live Activities)

---

# 📱 **App Preview (Coming Soon)**

Screenshots and demo videos will be added once the UI is finalized.

---

# 📄 **License**

This project is licensed under the **MIT License**.

---

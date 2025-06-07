
# 🎉 Funny Facts App

A modern and fun Flutter app that delivers random funny facts with a clean UI, enhanced features, and smooth user experience. This project has been significantly upgraded to bring users a more intuitive, responsive, and visually appealing interface.


<p align="center">
  <img src="assets/funny_facts.gif" alt="Demo" width="400"/>
</p>

---

##  Features

-  **Modern UI** with Material Design 3 and custom themes
-  **Copy facts** to clipboard with visual feedback
-  **Random navigation** to explore surprising facts
-  **Share facts** with friends using `share_plus`
-  **Progress indicator** to track current fact
-  **Advanced Settings page** with organized sections
-  **Dark/Light mode** support

---

##  User Experience

- Smooth animations for screen transitions and fact cards
- Retry mechanism for error handling
- Tactile and visual feedback on all actions
- Intuitive navigation through swipe and buttons
- Enhanced loading and error states

---

##  Project Structure

```
lib/
│
├── main.dart
│   
├── screens/
│   ├── home_screen.dart
│   └── settings_screen.dart
│ 
├── widgets/
│   └── themeSwitcher.dart
└── providers/
    ├── themeProvider.dart
    └── constants.dart
```

---

##  Dependencies

Make sure to update your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  share_plus: ^7.2.1
  url_launcher: ^6.2.5
  package_info_plus: ^5.0.1
```

Install via:

```bash
flutter pub get
```

---


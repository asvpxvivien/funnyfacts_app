import 'package:flutter/material.dart';

class Themeprovider extends ChangeNotifier {
  bool _isDarkModeChecked = false;

  bool get isDarkModeChecked => _isDarkModeChecked;

  void toggleTheme() {
    _isDarkModeChecked = !_isDarkModeChecked;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class Themeprovider extends ChangeNotifier {
  bool isDarkModeChecked = true;
  void updateMode({required bool darkMode}) {
    isDarkModeChecked = darkMode;
    notifyListeners();
  }
}

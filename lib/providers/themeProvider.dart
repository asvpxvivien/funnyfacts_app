import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Themeprovider extends ChangeNotifier {
  bool _isDarkModeChecked = true;
  double _fontSize = 18.0;
  bool _isFirstTime = true;

  // Getters
  bool get isDarkModeChecked => _isDarkModeChecked;
  double get fontSize => _fontSize;
  bool get isFirstTime => _isFirstTime;

  // Clés pour SharedPreferences
  static const String _darkModeKey = 'isDarkModeChecked';
  static const String _fontSizeKey = 'fontSize';
  static const String _firstTimeKey = 'isFirstTime';

  /// Met à jour le mode de thème
  Future<void> updateMode({required bool darkMode}) async {
    if (_isDarkModeChecked != darkMode) {
      _isDarkModeChecked = darkMode;

      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_darkModeKey, darkMode);
        notifyListeners();
      } catch (e) {
        // En cas d'erreur, on revert le changement
        _isDarkModeChecked = !darkMode;
        debugPrint('Erreur lors de la sauvegarde du thème: $e');
      }
    }
  }

  /// Met à jour la taille de police
  Future<void> updateFontSize(double newFontSize) async {
    if (_fontSize != newFontSize &&
        newFontSize >= 12.0 &&
        newFontSize <= 30.0) {
      _fontSize = newFontSize;

      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(_fontSizeKey, newFontSize);
        notifyListeners();
      } catch (e) {
        debugPrint('Erreur lors de la sauvegarde de la taille de police: $e');
      }
    }
  }

  /// Charge les préférences sauvegardées
  Future<void> loadMode() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      _isDarkModeChecked = prefs.getBool(_darkModeKey) ?? true;
      _fontSize = prefs.getDouble(_fontSizeKey) ?? 18.0;
      _isFirstTime = prefs.getBool(_firstTimeKey) ?? true;

      // Si c'est la première fois, on marque comme vue
      if (_isFirstTime) {
        await prefs.setBool(_firstTimeKey, false);
        _isFirstTime = false;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement des préférences: $e');
      // Utilise les valeurs par défaut en cas d'erreur
      _isDarkModeChecked = true;
      _fontSize = 18.0;
      _isFirstTime = true;
      notifyListeners();
    }
  }

  /// Remet les paramètres par défaut
  Future<void> resetToDefaults() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      _isDarkModeChecked = true;
      _fontSize = 18.0;

      await prefs.setBool(_darkModeKey, _isDarkModeChecked);
      await prefs.setDouble(_fontSizeKey, _fontSize);

      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de la réinitialisation: $e');
    }
  }

  /// Bascule entre les modes (utile pour les raccourcis)
  Future<void> toggleTheme() async {
    await updateMode(darkMode: !_isDarkModeChecked);
  }

  /// Vérifie si le mode sombre du système est activé
  bool isSystemDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  /// Applique le thème système si souhaité
  Future<void> followSystemTheme(BuildContext context) async {
    final bool systemIsDark = isSystemDarkMode(context);
    await updateMode(darkMode: systemIsDark);
  }
}

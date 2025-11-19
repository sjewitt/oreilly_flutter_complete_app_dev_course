// Do we extend a base class here? - it's NOT a model...
// yes...
import 'package:flutter/material.dart';

// efficiency of `extends` vs `with`?
class ThemeProvider extends ChangeNotifier {
  // brivate var indicating whether dark mode is on:
  bool _isDarkMode = false;

  // getters
  bool get isDarkMode => _isDarkMode;

  // methods
  void _toggleDarkMode() {
    // if (_isDarkMode) {
    //   _isDarkMode = false;
    // } else {
    //   _isDarkMode = true;
    // }
    // better syntax from course:
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // he also provides a getter for the theme itself:
  ThemeData get currentTheme {
    // if (_isDarkMode) {
    //   return ThemeData.dark();
    // } else {
    //   return ThemeData.light();
    // }

    // or, using ternary operator...
    // I REALLY should use this more often!
    return _isDarkMode ? ThemeData.dark() : ThemeData.light();
  }

  // and the toggle dark mode function we can utilise:
  void toggleDarkMode() {
    _toggleDarkMode();
    // return ValueChanged<bool>(_isDarkMode);
  }

  // and what do we init()?
  ThemeProvider();
}

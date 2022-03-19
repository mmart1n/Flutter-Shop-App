import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  String _themeMode = 'System';

  Future<String> getSelectedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('theme')) {
      return 'system';
    }

    final extractedUserData = prefs.getString('theme') as String;

    _themeMode = extractedUserData;
    notifyListeners();
    return extractedUserData;
  }

  String get themeMode {
    return _themeMode;
  }

  void setSelectedTheme(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = mode;
    prefs.setString('theme', mode);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  Color? _colorText ;
  Color? _colorBackground;
  Color? _containerBackg;
  Color? _colorBtn ;
  bool isDark = false;

  Color? get colorText => _colorText;
  Color? get colorBackground => _colorBackground;
  Color? get containerBackg => _containerBackg;
  Color? get colorBtn => _colorBtn;

  
  Future<bool> loadStatus()async{
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool("isDark") ?? false;
    _updateColors();
    return isDark;
  }
 
   changeTheme() async{
    isDark = !isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDark",isDark);
    _updateColors();
    await loadStatus();
    notifyListeners();
  }

  void _updateColors() {
    _colorText = isDark ? Colors.grey[200] : null;
    _colorBackground = isDark ? const Color(0xFF121212) : null;
    _containerBackg = isDark ? const Color.fromARGB(226, 29, 29, 29) : null;
    _colorBtn = isDark ? Colors.white : null;
  }
}

//color sombre 0xFF090D1F , 0xFF000000, 0xFF121212, 0xFF2A2F4C, 0xFF22222E

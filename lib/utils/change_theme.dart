import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false; // Изначально светлая тема

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

// Иконка для смены темы солнце/луна
class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return IconButton(
      onPressed: () {
        themeProvider.toggleTheme(); // Изменение темы при нажатии кнопки
      },
      icon: Icon(
        themeProvider.isDarkMode ? Icons.nightlight_round : CupertinoIcons.brightness_solid,
      ),
    );
  }
}

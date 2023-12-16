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

// Кнопка для смены темы
// class ThemeSwitchButton extends StatelessWidget {
//   const ThemeSwitchButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return ElevatedButton.icon(
//       onPressed: () {
//         themeProvider.toggleTheme(); // Изменение темы при нажатии кнопки
//       },
//       icon: Icon(
//         themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
//       ),
//       label: Text(
//         themeProvider.isDarkMode ? 'Светлая тема' : 'Темная тема',
//       ),
//     );
//   }
// }

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
        themeProvider.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
      ),
    );
  }
}


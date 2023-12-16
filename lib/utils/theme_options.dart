import 'package:flutter/material.dart';

class MyAppTheme {
  // Параметры для светлой темы
  static ThemeData lightTheme = ThemeData.light().copyWith(
    // Межстрочный интервал(после обновления Flutter по умолчанию 1.5 или 2 по ощущениям)
    // Поэтому вручную меняю на 1.2
    textTheme: const TextTheme(
      bodyLarge: TextStyle(height: 1.2, color: Colors.black),
      bodyMedium: TextStyle(height: 1.2, color: Colors.black),
    ),
    appBarTheme: AppBarTheme(
      toolbarHeight: 40.0,
      color: Colors.amber[300],
      shadowColor: Colors.black,
      elevation: 4,
    ),
    // тень AppBar
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // Стили других кнопок если потребуется прописать тут
      ),
    ),
  );

  // Параметры для темной темы
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    textTheme: const TextTheme(
      bodyLarge: TextStyle(height: 1.2),
      bodyMedium: TextStyle(height: 1.2),
    ),
    appBarTheme: AppBarTheme(
      toolbarHeight: 40.0,
      color: Colors.grey[800],
      shadowColor: Colors.black,
      elevation: 4,
    ),
    // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );
}
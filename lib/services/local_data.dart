import 'dart:convert';
import 'package:travel_app/screens/cart_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/screens/favourites_screen.dart';

// Метод для загрузки корзины и избранного из SharedPreferences
Future<void> loadData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final cartItemsJson = prefs.getString('cartItems');
  final List<int> favouritesData = prefs.getStringList('favouritesData')?.map((e) => int.parse(e)).toList() ?? [];
  
  if (cartItemsJson != null) {
    // Декодирование JSON
    final cartItemsList = jsonDecode(cartItemsJson);
    // Преобразование списка в Map<int, int>
    // cartItems = Map<int, int>.fromIterable(cartItemsList, key: (item) => item['regionId'], value: (item) => item['quantity']);
    cartItems = {for (var item in cartItemsList) item['regionId'] : item['quantity']}; 
  }

  if (favouritesData.isNotEmpty) {
    favouritesRegionID = Set<int>.from(favouritesData);
  }

}

// Метод для сохранения корзины в SharedPreferences
Future<void> saveCartItems() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Преобразование cartItems в список пар ключ-значение
  final cartItemsList = cartItems.entries.map((entry) {
    return {
      'regionId': entry.key,
      'quantity': entry.value,
    };
  }).toList();
  
  // Сериализация в JSON и сохранение
  await prefs.setString('cartItems', jsonEncode(cartItemsList));
}

// Метод для сохранения Избранного
Future<void> saveFavouritesItems() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> favouritesData = favouritesRegionID.map((e) => e.toString()).toList();
  await prefs.setStringList('favouritesData', favouritesData);
}

// Метод для очистки корзины в SharedPreferences
Future<void> clearCartItems() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('cartItems'); // Удалить данные о корзине
  cartItems = {}; // Очистить локальную переменную
}

// Метод для очистки Избранного в SharedPreferences
Future<void> clearFavourites() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('favouritesData'); // Удалить данные об избранном
  favouritesRegionID.clear(); // Очистить локальную переменную
}

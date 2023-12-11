import 'package:travel_app/screens/cart_screen.dart';
import 'package:travel_app/services/local_data.dart';

// Метод для добавления товара в корзину
void addToCart(int regionId) {
  if (cartItems.containsKey(regionId)) {
    // Если товар уже есть в корзине, увеличиваем количество на 1
    cartItems[regionId] = (cartItems[regionId] ?? 0) + 1;
  } else {
    // Если товара нет в корзине, добавляем его с количеством 1
    cartItems[regionId] = 1;
  }
  saveCartItems();
}

// Метод для удаления товара из корзины
void removeFromCart(int regionId) {
  if (cartItems.containsKey(regionId)) {
    // Уменьшаем количество на 1
    cartItems[regionId] = (cartItems[regionId] ?? 0) - 1;
    if (cartItems[regionId] != null && cartItems[regionId]! <= 0) {
      // Если количество достигло 0 или меньше, удаляем товар из корзины
      cartItems.remove(regionId);
    }
  }
  saveCartItems();
}
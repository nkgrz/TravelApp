import 'package:flutter/material.dart';
import 'package:travel_app/screens/favourites_screen.dart';
import 'package:travel_app/screens/regions_screen.dart';
import 'package:intl/intl.dart';

// List<int> cartRegionID = [];
Map<int, int> cartItems = {};

// Метод для добавления товара в корзину
void addToCart(int regionId) {
  if (cartItems.containsKey(regionId)) {
    // Если товар уже есть в корзине, увеличиваем количество на 1
    cartItems[regionId] = (cartItems[regionId] ?? 0) + 1;
  } else {
    // Если товара нет в корзине, добавляем его с количеством 1
    cartItems[regionId] = 1;
  }
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
}

class CartList extends StatefulWidget {
  const CartList({super.key});

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  double getTotalCost() {
    double totalCost = 0.0;
    // Вычисляем общую стоимость на основе количества каждого товара
    cartItems.forEach((regionId, quantity) {
      final regionInfo = regions.firstWhere((region) => region.id == regionId);
      totalCost += regionInfo.price * quantity;
    });
    return totalCost;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: cartItems.isEmpty
              ? const Center(
                  child: Text('Корзина пуста'),
                )
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final regionId = cartItems.keys.elementAt(index);
                    final quantity = cartItems[regionId];
                    final regionInfo =
                        regions.firstWhere((region) => region.id == regionId);

                    String description = regionInfo.description;
                    if (description.length > 35) {
                      description = '${description.substring(0, 35)}...';
                    }

                    return Column(
                      children: [
                        Container(
                          height: 102,
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  regionInfo.imageAsset,
                                  height: 80,
                                  width: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Название, цена и описание товара
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Название товара
                                    Text(
                                      regionInfo.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Описание товара
                                    SizedBox(
                                      height:
                                          // Если Название слишком большое и количество 2 и больше,
                                          // то сократить место под описание(иначе с Санкт-Петербургом проблемы)
                                          (regionInfo.name.length > 14 &&
                                                  ((quantity ?? 1) > 1))
                                              ? 15
                                              : 30,
                                      child: Text(
                                        description,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Цена товара
                                    Text(
                                      '${NumberFormat("#,###", "ru").format(regionInfo.price.toInt())} ₽',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 70),
                                  ],
                                ),
                              ),
                              // Кнопки избранное и + -
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Кнопка избранное
                                    // SizedBox(
                                    //   width: 40,
                                    //   height: 40,
                                    //   child: IconButton(
                                    //     onPressed: () {
                                    //       if (favouritesRegionID
                                    //           .contains(regionInfo.id)) {
                                    //         // Если элемент находится в избранном, удаляем его из избранного
                                    //         setState(() {
                                    //           favouritesRegionID
                                    //               .remove(regionInfo.id);
                                    //         });
                                    //       } else {
                                    //         // Если элемент не находится в избранном, добавляем его в избранное
                                    //         setState(() {
                                    //           favouritesRegionID
                                    //               .add(regionInfo.id);
                                    //         });
                                    //       }
                                    //     },
                                    //     icon: Icon(
                                    //       favouritesRegionID
                                    //               .contains(regionInfo.id)
                                    //           ? Icons
                                    //               .favorite // Если в избранном
                                    //           : Icons
                                    //               .favorite_border, // Если не в избранном
                                    //     ),
                                    //   ),
                                    // ),
                                    FavoriteButton(regionId: regionInfo.id),

                                    const SizedBox(height: 10),
                                    // Кнопки + -
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Кнопка "-" для уменьшения количества
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              removeFromCart(regionId);
                                            });
                                          },
                                          child: Container(
                                            width:
                                                24, // Установка ширины и высоты  кнопки
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .grey, // Цвет фона кнопки
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8.0), // Форма кнопки
                                            ),
                                            child: const Icon(
                                              Icons.remove,
                                              color:
                                                  Colors.white, // Цвет иконки
                                              size: 16, // Размер иконки
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        // Количество товара
                                        Text('$quantity'),
                                        const SizedBox(width: 4),

                                        // Кнопка "+" для увеличения количества
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              addToCart(regionId);
                                            });
                                          },
                                          child: Container(
                                            width:
                                                24, // Установите желаемую ширину и высоту для кнопки
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .grey, // Цвет фона кнопки
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8.0), // Форма кнопки
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color:
                                                  Colors.white, // Цвет иконки
                                              size: 16, // Размер иконки
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ]),
                            ],
                          ),
                        ),
                        const Divider(
                            thickness: 1.5, indent: 10, endIndent: 10),
                      ],
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                  'Итого: ${NumberFormat("#,###", "ru").format(getTotalCost())} ₽'),
              ElevatedButton(
                onPressed: () {
                  // Реализация кнопки "Оформить заказ"
                },
                child: const Text('Оформить заказ'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final int regionId;

  const FavoriteButton({Key? key, required this.regionId}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Установите начальное состояние isFavorite на основе favouritesRegionID
    isFavorite = favouritesRegionID.contains(widget.regionId);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          if (isFavorite) {
            favouritesRegionID.remove(widget.regionId);
          } else {
            favouritesRegionID.add(widget.regionId);
          }
          isFavorite = !isFavorite;
        });
      },
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        // color: Colors.red, // Вы можете установить свой цвет
      ),
    );
  }
}
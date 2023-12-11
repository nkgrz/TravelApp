import 'package:flutter/material.dart';
import 'package:travel_app/screens/regions_screen.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/utils/add_remove_from_cart.dart';
import 'package:travel_app/widgets/favorite_button.dart';
import 'package:travel_app/widgets/product_info_widget.dart';
import 'package:travel_app/widgets/quantity_control_widget.dart';

Map<int, int> cartItems = {};

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
                              // Картинка региона
                              ProductImageWidget(
                                  imageAsset: regionInfo.imageAsset),

                              // Отутуп от картинки до названия, описания и цены товара
                              const SizedBox(width: 10),

                              // Название, цена и описание товара
                              ProductDetailsWidget(
                                  name: regionInfo.name,
                                  description: description,
                                  price: regionInfo.price,
                                  quantity: (quantity ?? 1)),

                              // Кнопки избранное и + -
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Кнопка избранное
                                    FavoriteButton(regionId: regionInfo.id),

                                    const SizedBox(height: 10),

                                    // Кнопки + -
                                    QuantityControlWidget(
                                      quantity: (quantity ?? 1),
                                      onAdd: () {
                                        setState(() {
                                          addToCart(regionId);
                                        });
                                      },
                                      onRemove: () {
                                        setState(() {
                                          removeFromCart(regionId);
                                        });
                                      },
                                    ),
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

        // Сумма заказа и кнопка оформить заказ
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

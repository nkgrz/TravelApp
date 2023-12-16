import 'package:flutter/material.dart';
import 'package:travel_app/models/regions.dart';
import 'package:travel_app/screens/cart_screen.dart';
import 'package:travel_app/screens/regions_screen.dart';
import 'package:travel_app/utils/add_remove_from_cart.dart';
import 'package:travel_app/widgets/favorite_button.dart';

class RegionDetailScreen extends StatelessWidget {
  final RegionInfo regionInfo;
  final cartlist = const CartList();
  const RegionDetailScreen({super.key, required this.regionInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(regionInfo.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(regionInfo.imageAsset),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                regionInfo.description,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),

      // Нижняя подложка с кнопками "Добавить в корзину" и "Избранное"
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0, // Убираем стандартную тень
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Подложка и кнопка "Добавить в корзину"
            Material(
              elevation: 5, // Тень для Material
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                child: Container(
                  color: Colors.amber[100],
                  child: ElevatedButton(
                    onPressed: () {
                      if (authService.currentUser == null) {
                        Navigator.of(context).pushNamed('/profile');
                      } else {
                        // Добавить продукт в корзину
                        addToCart(regionInfo.id);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Добавить в корзину'),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 25.0),

            // Подложка и кнопка "Избранное"
            Material(
              elevation: 5, // Тень для Material
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                child: Container(
                  color: Colors.amber[100],
                  child: FavoriteButton(regionId: regionInfo.id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

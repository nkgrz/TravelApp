import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/models/const.dart'; // Для форматирования чисел
import 'package:cached_network_image/cached_network_image.dart';


// Картинка товара
class ProductImageWidget extends StatelessWidget {
  final String imageAsset;

  const ProductImageWidget({super.key, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        imageUrl: '$getImage$imageAsset',
        height: 80,
        width: 140,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}

// Название, описание и цена товара
class ProductDetailsWidget extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final int quantity; // Для условия отображения описания

  const ProductDetailsWidget({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    this.quantity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Название товара
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          // Описание товара
          // quantity = 0 подается из избранного, там больше места, поэтому виджет использую другой
          // quantity = 1 или больше подается их корзины, там места меньше
          quantity == 0
              ? Text(
                  description,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                )
              : SizedBox(
                  // Если название слишком большое и количество 2 и больше,
                  // то сократить место под описание(иначе с Санкт-Петербургом проблемы)
                  height:
                      (name.length > 14 || (name.length > 14 && quantity > 1))
                          ? 15
                          : 32,
                  child: Text(
                    description,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                ),
          const SizedBox(height: 5),
          // Цена товара
          Text(
            '${NumberFormat("#,###", "ru").format(price.toInt())} ₽',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 70),
        ],
      ),
    );
  }
}

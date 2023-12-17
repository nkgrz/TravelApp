import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Кнопки добавть в корзину и удалить из избранного
class CartAndFavoriteButtonsWidget extends StatelessWidget {
  final Function onAddToCart;
  final Function onDeleteFavorite;
  final int regionId;

  const CartAndFavoriteButtonsWidget({
    super.key,
    required this.onAddToCart,
    required this.onDeleteFavorite,
    required this.regionId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
            onPressed: () => onAddToCart(regionId),
            icon: const Icon(CupertinoIcons.cart_badge_plus),
          ),
        ),
        SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
            onPressed: () => onDeleteFavorite(regionId),
            icon: const Icon(CupertinoIcons.delete),
          ),
        ),
      ],
    );
  }
}

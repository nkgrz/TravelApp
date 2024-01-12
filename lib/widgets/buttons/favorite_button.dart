
import 'package:flutter/material.dart';
import 'package:travel_app/screens/favourites_screen.dart';
import 'package:travel_app/services/local_data.dart';

class FavoriteButton extends StatefulWidget {
  final int regionId;

  const FavoriteButton({Key? key, required this.regionId}) : super(key: key);

  @override
  FavoriteButtonState createState() => FavoriteButtonState();
}

class FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Установлено начальное состояние isFavorite на основе favouritesRegionID
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
          saveFavouritesItems();
        });
      },
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        // color: Colors.red,
      ),
    );
  }
}
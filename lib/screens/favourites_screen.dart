import 'package:flutter/material.dart';
import 'package:travel_app/screens/regions_screen.dart';
import 'package:travel_app/services/local_data.dart';
import 'package:travel_app/utils/add_remove_from_cart.dart';
import 'package:travel_app/widgets/buttons/cart_and_favorite_buttons_widget.dart';
import 'package:travel_app/widgets/product_info_widget.dart';

Set<int> favouritesRegionID = {};

class FavouritesList extends StatefulWidget {
  const FavouritesList({super.key});

  @override
  State<FavouritesList> createState() => _FavouritesListState();
}

class _FavouritesListState extends State<FavouritesList> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: favouritesRegionID.isEmpty
              ? const Center(
                  child: Text('В избранном пока пусто'),
                )
              : ListView.builder(
                  itemCount: favouritesRegionID.length,
                  itemBuilder: (context, index) {
                    final regionInfo = regions.firstWhere((region) =>
                        region.id == favouritesRegionID.elementAt(index));

                    String description = regionInfo.description;
                    if (description.length > 30) {
                      description = '${description.substring(0, 30)}...';
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
                              const SizedBox(width: 10),

                              // Название, цена и описание товара
                              ProductDetailsWidget(
                                  name: regionInfo.name,
                                  description: description,
                                  price: regionInfo.price,
                                  quantity: 0),

                              // Кнопки добавть в корзину и удалить из избранного
                              CartAndFavoriteButtonsWidget(
                                onAddToCart: (regionId) {
                                  addToCart(regionId);
                                },
                                onDeleteFavorite: (regionId) {
                                  setState(() {
                                    favouritesRegionID.remove(regionId);
                                    saveFavouritesItems();
                                  });
                                },
                                regionId: regionInfo.id,
                              ),
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
      ],
    );
  }
}

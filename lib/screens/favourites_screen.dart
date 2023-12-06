import 'package:flutter/material.dart';
import 'package:travel_app/screens/cart_screen.dart';
import 'package:travel_app/screens/regions_screen.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/services/local_data.dart';

Set<int> favouritesRegionID = {};

class FavouritesList extends StatefulWidget {
  const FavouritesList({super.key});

  @override
  State<FavouritesList> createState() => _FavouritesListState();
}

class _FavouritesListState extends State<FavouritesList> {
  double getTotalCost() {
    double totalCost = 0.0;
    for (int regionId in favouritesRegionID) {
      totalCost += regions.firstWhere((region) => region.id == regionId).price;
    }
    return totalCost;
  }

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
                    final regionInfo = regions.firstWhere(
                        (region) => region.id == favouritesRegionID.elementAt(index));

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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      regionInfo.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      description,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '${NumberFormat("#,###", "ru").format(regionInfo.price.toInt())} ₽',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,

                                children: [
                                  
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: 
                                      IconButton(
                                        onPressed: () {
                                          // cartRegionID.add(regionInfo.id);
                                          addToCart(regionInfo.id);
                                        },
                                        icon: const Icon(Icons.add_shopping_cart),
                                      ),
                                  ),

                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child:
                                      IconButton(
                                        // padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          setState(() {
                                            favouritesRegionID.remove(regionInfo.id);
                                            saveFavouritesItems();
                                          });
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                  ),
                                ],
                              )
                              
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
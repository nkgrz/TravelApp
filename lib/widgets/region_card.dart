import 'package:flutter/material.dart';
import 'package:travel_app/models/regions.dart';
import 'package:travel_app/screens/region_detail_screen.dart';

class RegionCard extends StatelessWidget {
  final RegionInfo regionInfo;

  const RegionCard({super.key, required this.regionInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0), // промежуток между карточками
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RegionDetailScreen(regionInfo: regionInfo),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: Image.asset(
                  regionInfo.imageAsset,
                  height: 125,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(
                    5.5), // Отступы от текста со всех сторон в названии карточки
                child: Text(
                  regionInfo.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
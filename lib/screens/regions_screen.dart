import 'package:flutter/material.dart';
import 'package:travel_app/models/regions.dart';
import 'package:travel_app/widgets/region_card.dart';
import 'package:travel_app/services/auth_service.dart';
import 'package:travel_app/services/download_regions.dart';

final AuthService authService = AuthService();
List<RegionInfo> regions = [];

class RegionsList extends StatefulWidget {
  const RegionsList({super.key});

  @override
  RegionsListState createState() => RegionsListState();
}

class RegionsListState extends State<RegionsList> {
  @override
  void initState() {
    super.initState();
    loadRegions().then((loadedRegions) {
      setState(() {
        regions = loadedRegions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // отступы сверху, снизу и по бокам
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Количество колонок
          childAspectRatio:
              1.06, // Соотношение сторон (ширина / высота) для каждой ячейки
        ),
        itemCount: regions.length,
        itemBuilder: (context, index) {
          return RegionCard(regionInfo: regions[index]);
        },
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:travel_app/screens/cart_screen.dart';

final AuthService authService = AuthService();
List<RegionInfo> regions = [];

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

class RegionInfo {
  final int id;
  final String name;
  final String description;
  final String imageAsset;
  final double price;

  RegionInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.price,
  });

  factory RegionInfo.fromJson(Map<String, dynamic> json) {
    return RegionInfo(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageAsset: json['imageAsset'],
      price: json['price'].toDouble(),
    );
  }
}

class RegionsList extends StatefulWidget {
  const RegionsList({super.key});

  @override
  RegionsListState createState() => RegionsListState();
}

class RegionsListState extends State<RegionsList> {
  @override
  void initState() {
    super.initState();
    loadRegionsFromJson(context).then((loadedRegions) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Кнопка избранное
                FavoriteButton(regionId: regionInfo.id),
                // Кнопка добавить в корзину
                ElevatedButton(
                  onPressed: () {
                    if (authService.currentUser == null) {
                      Navigator.of(context).pushNamed(
                          '/profile'); // или другой маршрут к экрану авторизации
                    } else {
                      // Добавить продукт в корзину
                      addToCart(regionInfo.id);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Добавить в корзину'),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

Future<List<RegionInfo>> loadRegionsFromJson(BuildContext context) async {
  final String jsonStr =
      await DefaultAssetBundle.of(context).loadString('assets/regions.json');
  final List<dynamic> jsonList = json.decode(jsonStr);
  return jsonList.map((json) => RegionInfo.fromJson(json)).toList();
}

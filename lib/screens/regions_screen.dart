import 'package:flutter/material.dart';
import 'dart:convert';

class RegionCard extends StatelessWidget {
  final RegionInfo regionInfo;

  RegionCard({required this.regionInfo});

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
                borderRadius: BorderRadius.only(
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
                padding: const EdgeInsets.all(6.0), // высота подложки для названий карточек
                child: Text(
                  regionInfo.name,
                  style: TextStyle(
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
  final String name;
  final String description;
  final String imageAsset;

  RegionInfo({
    required this.name,
    required this.description,
    required this.imageAsset,
  });

  factory RegionInfo.fromJson(Map<String, dynamic> json) {
    return RegionInfo(
      name: json['name'],
      description: json['description'],
      imageAsset: json['imageAsset'],
    );
  }
}

class RegionsList extends StatefulWidget {
  @override
  _RegionsListState createState() => _RegionsListState();
}

class _RegionsListState extends State<RegionsList> {
  List<RegionInfo> regions = [];

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
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: regions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 0.0), // Отступ между карточками
        itemBuilder: (context, index) {
          return RegionCard(regionInfo: regions[index]);
        },
      ),
    );
  }
}

class RegionDetailScreen extends StatelessWidget {
  final RegionInfo regionInfo;

  RegionDetailScreen({required this.regionInfo});

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
                            style: TextStyle(fontSize: 18),
                        ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            ElevatedButton(
                            onPressed: () {
                                // Добавить в корзину
                            },
                            child: Text('Добавить в корзину'),
                            ),
                        ],
                    ),
                ],
            ),
        ),
    );

  }
}


Future<List<RegionInfo>> loadRegionsFromJson(BuildContext context) async {
  final String jsonStr = await DefaultAssetBundle.of(context).loadString('assets/regions.json');
  final List<dynamic> jsonList = json.decode(jsonStr);
  return jsonList.map((json) => RegionInfo.fromJson(json)).toList();
}
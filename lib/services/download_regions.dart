import 'dart:convert';
import 'package:travel_app/models/const.dart';
import 'package:travel_app/models/regions.dart';
import 'package:http/http.dart' as http;

// Метод для загрузки регионов из сервера
Future<List<RegionInfo>> loadRegions() async {
  final response = await http.get(Uri.parse(getRegions));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((json) => RegionInfo.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data from the server');
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/category_count.dart';

class CategoryCountProvider with ChangeNotifier {
  List<CategoryCount> _counts = [];

  List<CategoryCount> get counts => _counts;

  Future<void> fetchCategoryCounts(String block) async {
    final url =
        Uri.parse('http://54.177.10.216:5000/api/complaints/category/count');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'block': block}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _counts = data.map((item) => CategoryCount.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch category counts');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  int getCountByCategory(String category) {
    return _counts
        .firstWhere((c) => c.category.toLowerCase() == category.toLowerCase(),
            orElse: () => CategoryCount(category: category, count: 0))
        .count;
  }
}

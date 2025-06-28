import 'package:flutter/material.dart';
import 'package:homescreeen/servies/category_service.dart';
import 'package:provider/provider.dart';

class BlockCategoryTabsScreen extends StatefulWidget {
  final String blockId;

  const BlockCategoryTabsScreen({super.key, required this.blockId});

  @override
  State<BlockCategoryTabsScreen> createState() =>
      _BlockCategoryTabsScreenState();
}

class _BlockCategoryTabsScreenState extends State<BlockCategoryTabsScreen> {
  final List<String> categories = [
    'electricity',
    'plumber',
    'food',
    'furniture',
    'wifi',
    'others'
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CategoryCountProvider>(context, listen: false)
          .fetchCategoryCounts(widget.blockId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Block ${widget.blockId} Complaints'),
          bottom: TabBar(
            isScrollable: true,
            tabs: categories.map((category) => Tab(text: category)).toList(),
          ),
        ),
        body: Consumer<CategoryCountProvider>(
          builder: (context, provider, child) {
            return TabBarView(
              children: categories.map((category) {
                int count = provider.getCountByCategory(category);
                return Center(
                  child: Text(
                    '$category complaints: $count',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

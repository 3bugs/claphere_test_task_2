import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task2/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static const numCategory = 10;
  static const colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.yellow,
  ];
  static var _startProductId = 1;

  final _categoryList = List.generate(numCategory, (i) => i + 1).map(
    (n) {
      return Category(
        id: n,
        name: 'Category $n',
        color: colorList[(n - 1) % colorList.length],
        productList: List.generate(Random().nextInt(5) + 1, (i) => i + 1).map(
          (_) {
            var productId = _startProductId++;
            return Product(id: productId, name: 'Product $productId');
          },
        ).toList(),
      );
    },
  ).toList();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _categoryList.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildCategoryList(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildProductList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      onTap: _handleClickTab,
      tabs: [
        for (final category in _categoryList)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: category.color,
                  ),
                ),
                Text(category.name),
              ],
            ),
          ),
      ],
    );
  }

  void _handleClickTab(int tabIndex) {
    debugPrint('Tab $tabIndex selected.');

    Scrollable.ensureVisible(
      GlobalObjectKey(_categoryList[tabIndex].id).currentContext!,
      duration: const Duration(milliseconds: 500),
      alignment: 0, // 0 mean, scroll to the top, 0.5 mean, half
      curve: Curves.easeInOutCubic,
    );
  }

  Widget _buildProductList() {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        debugPrint('List position: ${notification.metrics.pixels}');

        var scrollDistance = notification.metrics.pixels;
        for (var i = 0; i < _categoryList.length; i++) {
          var topPosition = 0.0;
          for (var j = 0; j <= i; j++) {
            topPosition += _categoryList[j].height ?? 0.0;
          }
          if (scrollDistance < topPosition) {
            _tabController.animateTo(i);
            break;
          }
        }

        // Return true to cancel the notification bubbling. Return false (or null) to
        // allow the notification to continue to be dispatched to further ancestors.
        return true;
      },
      // Replace the ListView with SingleChildScrollView and the Column,
      // to work around the issue of being unable to scroll to an item that is
      // not yet built (because it is outside the viewport).
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (final category in _categoryList)
              MeasureSize(
                onChange: (size) => _measureSize(category, size),
                child: Column(
                  key: GlobalObjectKey(category.id),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 32.0, bottom: 16.0),
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: category.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: category.productList
                          .map(
                            (product) => Card(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(product.name),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 500.0),
            const Text('End of list'),
          ],
        ),
      ),
    );
  }

  void _measureSize(Category category, Size size) {
    debugPrint('${category.name} height: ${size.height}');
    category.height = size.height;
  }
}

class Category {
  final int id;
  final String name;
  final Color color;
  final List<Product> productList;
  double? height;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.productList,
  });
}

class Product {
  final int id;
  final String name;

  Product({required this.id, required this.name});
}

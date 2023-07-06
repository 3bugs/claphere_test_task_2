import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  final _categoryList = [
    Category(
      key: GlobalKey(),
      name: 'Category 1',
      color: Colors.red,
      productList: [
        Product(name: 'Product 1'),
        Product(name: 'Product 2'),
        Product(name: 'Product 3'),
        Product(name: 'Product 4'),
        Product(name: 'Product 5'),
      ],
    ),
    Category(
      key: GlobalKey(),
      name: 'Category 2',
      color: Colors.green,
      productList: [
        Product(name: 'Product 6'),
        Product(name: 'Product 7'),
        Product(name: 'Product 8'),
      ],
    ),
    Category(
      key: GlobalKey(),
      name: 'Category 3',
      color: Colors.blue,
      productList: [
        Product(name: 'Product 9'),
        Product(name: 'Product 10'),
      ],
    ),
    Category(
      key: GlobalKey(),
      name: 'Category 4',
      color: Colors.orange,
      productList: [
        Product(name: 'Product 11'),
        Product(name: 'Product 12'),
        Product(name: 'Product 13'),
      ],
    ),
    Category(
      key: GlobalKey(),
      name: 'Category 5',
      color: Colors.pink,
      productList: [
        Product(name: 'Product 14'),
        Product(name: 'Product 15'),
      ],
    ),
    Category(
      key: GlobalKey(),
      name: 'Category 6',
      color: Colors.yellow,
      productList: [
        Product(name: 'Product 16'),
        Product(name: 'Product 17'),
        Product(name: 'Product 18'),
      ],
    ),
  ];

  late TabController _tabController;

  //final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _categoryList.length);
    //_scrollController.addListener(() {});
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
      tabs: _categoryList
          .map(
            (category) => Padding(
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
          )
          .toList(),
    );
  }

  void _handleClickTab(int tabIndex) {
    debugPrint('Tab $tabIndex selected.');

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Scrollable.ensureVisible(_categoryList[tabIndex].key.currentContext!));
  }

  Widget _buildProductList() {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        debugPrint('List position: ${notification.metrics.pixels}');

        // Return true to cancel the notification bubbling. Return false (or null) to
        // allow the notification to continue to be dispatched to further ancestors.
        return true;
      },
      child: ListView(
        children: _categoryList
            .map(
              (category) => Column(
                key: category.key,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            _tabController
                                .animateTo(_categoryList.indexOf(category));
                          },
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: category.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: category.productList
                        .map((product) => Card(
                                child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(product.name),
                                ),
                              ],
                            )))
                        .toList(),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class Category {
  final GlobalKey key;
  final String name;
  final Color color;
  final List<Product> productList;

  Category({
    required this.key,
    required this.name,
    required this.color,
    required this.productList,
  });
}

class Product {
  final String name;

  Product({required this.name});
}

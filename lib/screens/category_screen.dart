import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category.dart';
import '../widgets/cart_icon.dart';
import '../widgets/bottom_bar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<Category>> futureCategories;
  String? _errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final apiService = ApiService(apiUrl: 'categories/');
    futureCategories = apiService.fetchCategories(args['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          CartIcon(), // Add the CartIcon here
        ]
      ),
      body: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            _errorMessage = 'Error: ${snapshot.error}';
            return Center(child: Text(_errorMessage!));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          final categories = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              crossAxisSpacing: 10.0, // Horizontal spacing between grid items
              mainAxisSpacing: 10.0, // Vertical spacing between grid items
              childAspectRatio: 3 / 2, // Aspect ratio of each grid item
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/sub_category',
                    arguments: {'id': category.uid},
                  );
                },
                child: GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    title: Text(
                      category.categoryName,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  child: Image.network(
                    category.categoryImage,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomBar()
    );
  }
}

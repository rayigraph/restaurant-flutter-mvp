import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/sub_category.dart';
import '../widgets/cart_icon.dart';
import '../widgets/bottom_bar.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key});

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  late Future<List<SubCategory>> fetchSubCategories;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final apiService = ApiService(apiUrl: 'sub_categories/');
    fetchSubCategories = apiService.fetchSubCategories(args['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sub Categories'),
        actions: [
          CartIcon(), // Add the CartIcon here
        ],
      ),
      body: FutureBuilder<List<SubCategory>>(
        future: fetchSubCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sub categories found'));
          }

          final subCategories = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
            ),
            itemCount: subCategories.length,
            itemBuilder: (context, index) {
              final subCategory = subCategories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/items',
                    arguments: {'id': subCategory.uid},
                  );
                },
                child: Card(
                  child: GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    title: Text(
                      subCategory.subCategoryName,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  child: Image.network(
                    subCategory.subCategoryImage,
                    fit: BoxFit.cover,
                  ),
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

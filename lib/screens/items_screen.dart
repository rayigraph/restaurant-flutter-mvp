import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/item.dart';
import '../widgets/cart_icon.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/bottom_bar.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  Future<List<Item>>? fetchItems; // Nullable Future

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetching arguments passed to this screen
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // Initialize the fetchItems future if not already initialized
    if (fetchItems == null) {
      final apiService = ApiService(apiUrl: 'items/');
      fetchItems = apiService.fetchItems(args['id']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          CartIcon(), // Show cart icon in the app bar
        ],
      ),
      body: fetchItems == null
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator if fetchItems is null
          : FutureBuilder<List<Item>>(
              future: fetchItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No items found'));
                }

                final items = snapshot.data!;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item.itemName),
                      leading: Image.network(
                        item.itemImage,
                        fit: BoxFit.cover,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AED ${item.itemPrice}'),
                          const SizedBox(height: 4),
                          ElevatedButton(
                            onPressed: () => _handleAddToCart(context, item),
                            child: const Text('Add to Cart'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: BottomBar(),
    );
  }

  void _handleAddToCart(BuildContext context, Item item) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final status = cartProvider.addItem(item, 0);

    if (status == 1) {
      // Item successfully added to cart
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.itemName} added to cart'),
          duration: const Duration(milliseconds: 5)
        ),
      );
    } else {
      // Show warning dialog
      _showWarningDialog(context, item);
    }
  }

  void _showWarningDialog(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Warning'),
        content: const Text(
            'You are trying to add an item from a different supplier. This will remove existing items. Do you want to continue?'),
        actions: [
          TextButton(
            onPressed: () {
              final cartProvider = Provider.of<CartProvider>(context, listen: false);
              cartProvider.addItem(item, 1);
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

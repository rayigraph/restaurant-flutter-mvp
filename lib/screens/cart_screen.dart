import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';
import '../widgets/bottom_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final isCartEmpty = cart.items.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: isCartEmpty
                ? const Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      final cartItem = cart.items.values.toList()[i];
                      return ListTile(
                        leading: Image.network(cartItem.imageUrl),
                        title: Text(cartItem.title),
                        subtitle: Text('Total: AED ${cartItem.price * cartItem.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (cartItem.quantity > 1) {
                                  cart.updateItemQuantity(cartItem.itemId, cartItem.quantity - 1);
                                } else {
                                  cart.removeItem(cartItem.itemId);
                                }
                              },
                            ),
                            Text('${cartItem.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                cart.updateItemQuantity(cartItem.itemId, cartItem.quantity + 1);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                cart.removeItem(cartItem.itemId);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Text(
            'Total: AED ${cart.totalAmount}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isCartEmpty
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CheckoutScreen()),
                    );
                  },
            child: const Text('Checkout'),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar()
    );
  }
}

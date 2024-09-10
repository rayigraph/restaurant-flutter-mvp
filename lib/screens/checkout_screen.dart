import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../widgets/bottom_bar.dart';

class CheckoutScreen extends StatelessWidget {
  final apiService = ApiService(apiUrl: 'orders');

  CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final cartItem = cart.items.values.toList()[i];
                return ListTile(
                  leading: Image.network(cartItem.imageUrl),
                  title: Text(cartItem.title),
                  subtitle: Text('Total: AED ${cartItem.price * cartItem.quantity}'),
                  trailing: Text('${cartItem.quantity} x AED ${cartItem.price}'),
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
            onPressed: () {
              _handleCheckout(context, cart);
            },
            child: const Text('Proceed to Payment'),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar()
    );
  }

  Future<void> _handleCheckout(BuildContext context, CartProvider cart) async {
    try {
      final orderItems = cart.items.entries.map((entry) {
        return {
          'product_id': entry.value.itemId,
          'quantity': entry.value.quantity,
        };
      }).toList();

      String orderId = await Provider.of<AuthProvider>(context, listen: false).checkout(cart.totalAmount,'credit_card', orderItems,1);

      _showSuccessDialog(context,orderId);
    } catch (error) {
      _showErrorDialog(context, error.toString());
    }
  }

  void _showSuccessDialog(BuildContext context,String orderId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Payment Successful'),
        content: Text('Thank you for your purchase! Your order id is : $orderId'),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).clearCart();
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Payment Failed'),
        content: Text('Error: $message'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

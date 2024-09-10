import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/order.dart';
import '../widgets/cart_icon.dart';
import '../widgets/bottom_bar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<List<Order>> futureOrders;
  String? _errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the API service and fetch orders
    futureOrders = Provider.of<AuthProvider>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          CartIcon(), // Add the CartIcon here
        ]
      ),
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            _errorMessage = 'Error: ${snapshot.error}';
            return Center(child: Text(_errorMessage!));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text(
                  '#${order.uid}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  )
                ),
                leading: Text(order.status),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(order.orderDate),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/order_details',
                    arguments: {'id': order.uid},
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

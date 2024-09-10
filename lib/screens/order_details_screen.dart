import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/cart_icon.dart';
import '../widgets/bottom_bar.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Future<Map<String, dynamic>> fetchOrderDetails;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetching arguments passed through Navigator
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // Fetching order details using the AuthProvider
    fetchOrderDetails = Provider.of<AuthProvider>(context, listen: false).fetchOrderDetails(args['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          CartIcon(), // Adding the CartIcon here
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchOrderDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No order details found'));
          }

          final Map<String, dynamic> orderDetails = snapshot.data!;

          if (orderDetails['status'] == "success") {
            final details = orderDetails['order'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: # ${details['uid']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  const SizedBox(height: 8),
                  Text('Status: ${details['status']}'),
                  const SizedBox(height: 8),
                  Text('Order Date: ${details['order_date']}'),
                  const SizedBox(height: 16),
                  const Text(
                    'Items:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...details['items'].map<Widget>((item) => ListTile(
                        title: Text(
                          item['item_name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        subtitle: Text('${item['quantity']} x ${item['unit_price']}'),
                        trailing: Text('AED ${item['total_price']}'),
                      )),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(orderDetails['message']),
            );
          }
        },
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

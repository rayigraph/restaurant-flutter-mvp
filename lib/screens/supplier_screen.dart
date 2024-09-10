import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/supplier.dart';
import '../widgets/cart_icon.dart';
import '../widgets/bottom_bar.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  late Future<List<Supplier>> futureSuppliers;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Initialize the API service and fetch suppliers
    final apiService = ApiService(apiUrl: 'suppliers');
    futureSuppliers = apiService.fetchSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [
          CartIcon(), // Add the CartIcon here
        ]
      ),
      body: FutureBuilder<List<Supplier>>(
        future: futureSuppliers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            _errorMessage = 'Error: ${snapshot.error}';
            return Center(child: Text(_errorMessage!));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No suppliers found'));
          }

          final suppliers = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              crossAxisSpacing: 10.0, // Horizontal spacing between grid items
              mainAxisSpacing: 10.0, // Vertical spacing between grid items
              childAspectRatio: 3 / 2, // Aspect ratio of each grid item
            ),
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              final supplier = suppliers[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/category',
                    arguments: {'id': supplier.uid},
                  );
                },
                child: GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    title: Text(
                      supplier.supplierName,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  child: Image.network(
                    supplier.supplierImage,
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

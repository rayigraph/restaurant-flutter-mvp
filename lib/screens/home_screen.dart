import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/cart_icon.dart';
import '../widgets/bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          CartIcon(), // Added const
        ],
      ),
      body: Center( // Center aligns the Column vertically and horizontally
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensures the Column takes minimal vertical space
            children: [
              const Padding(
                padding: EdgeInsets.all( 30.0),
                child: Text(
                  "Logged in!",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
              ListTile(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Icon(Icons.local_shipping),
                      Text('Suppliers',
                      style: TextStyle(fontSize: 20)
                    )
                  ]
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/supplier');
                },
              ),
              ListTile(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag),
                    Text(
                      'Orders',
                      style: TextStyle(fontSize: 20)
                      )
                  ]
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/orders');
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Log the user out by calling the logout method from the provider
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  
                  // Then navigate to the login screen
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(), // Added const
    );
  }
}

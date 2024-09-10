import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth_provider.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/home_screen.dart';
import './screens/category_screen.dart';
import './screens/sub_category_screen.dart';
import './screens/supplier_screen.dart';
import './screens/order_screen.dart';
import './screens/order_details_screen.dart';
import './screens/items_screen.dart';
import './services/api_service.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(apiService: ApiService(apiUrl: '/login')),
        ),
      ],
      child: MaterialApp(
        title: 'Auth App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginScreen(),
        routes: {
          '/signup': (_) => const SignupScreen(),
          '/home': (_) => const HomeScreen(),
          '/login': (_) => const LoginScreen(),
          '/category': (_) => const CategoryScreen(),
          '/sub_category': (_) => const SubCategoryScreen(),
          '/items': (_) => ItemScreen(),
          '/supplier': (_) => const SupplierScreen(),
          '/orders': (_) => const OrderScreen(),
          '/order_details': (_) => const OrderDetailsScreen(),
        },
      ),
    );
  }
}

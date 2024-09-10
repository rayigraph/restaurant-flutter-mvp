import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/order.dart';

class AuthProvider with ChangeNotifier {
  final ApiService apiService;
  String? _token;

  AuthProvider({required this.apiService});

  String? get token => _token;

  Future<Map<String, dynamic>> signup(String name,String email, String password, String confirmpassword, String phone) async {
    try {
      final response = await apiService.signup(name, email, password, confirmpassword, phone);
      if (response.containsKey('auth_token')) {
        _token = response['auth_token'];
        notifyListeners();
      }
      return response;
    } catch (e) {
      // Handle login errors
      rethrow;
    }
  }
  Future<String> login(String email, String password) async {
    try {
      final response = await apiService.login(email, password);
      if (response.containsKey('auth_token')) {
        _token = response['auth_token'];
        notifyListeners();
      }
      return response['status'];
    } catch (e) {
      // Handle login errors
      rethrow;
    }
  }
  Future<String> checkout(double totalPrice, String paymentMethod, List<Map<String, dynamic>> orderItems, int tableId) async {
    try {
      final apiService = ApiService(apiUrl: 'orders');
      final response = await apiService.checkout(
                          totalPrice: totalPrice,
                          paymentMethod: 'credit_card',
                          orderItems: orderItems,
                          tableId: tableId,
                          token: token.toString()
                        );
      if (response.containsKey('auth_token')) {
        _token = response['auth_token'];
        notifyListeners();
      }
      if(response['status'] == "fail")
      {
        return response['message'];
      }
      return response['order_id'].toString();
    } catch (e) {
      // Handle login errors
      rethrow;
    }
  }
  Future<List<Order>> fetchOrders() async {
    try {
      final response = await apiService.fetchOrders(token);
      return response;
    } catch (e) {
      // Handle login errors
      rethrow;
    }
  }
  Future<Map<String, dynamic>> fetchOrderDetails(id) async {
    try {
      final response = await apiService.fetchOrderDetails(id, token);
      if(response['status'] == "success")
      {
        return response;
      }
      throw Exception(response['order']);
    } catch (e) {
      // Handle login errors
      rethrow;
    }
  }

  void logout() {
    _token = null;
    notifyListeners();
    // Additional logout logic if needed
  }
}

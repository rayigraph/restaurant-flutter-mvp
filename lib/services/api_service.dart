import 'dart:convert';
import 'package:auth_app/models/order_details.dart';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../models/supplier.dart';
import '../models/category.dart';
import '../models/item.dart';
import '../models/sub_category.dart';

class ApiService {
  final String baseUrl = 'http://13.126.109.202/api/';
  final String apiUrl;
  
  ApiService({required this.apiUrl});
  

  Future<Map<String, dynamic>> login(String email, String password) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/login'));
    request.fields['email_or_phone'] = email;
    request.fields['password'] = password;
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> signup(String name, String email, String password, String confirmpassword, String phone) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/signup'));
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['confirm_password'] = confirmpassword;
    request.fields['phone'] = phone;
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return _processResponse(response);
  }
  Future<List<Order>> fetchOrders(token) async {
      // Define your headers
    final Map<String, String> headers = {'Authorization': token};

    // Make the GET request with headers
    final response = await http.get(
      Uri.parse('${baseUrl}orders/'),
      headers: headers,
    );
    // throw Exception(response.body);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['orders'];
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      if(response.statusCode == 404)
      {
        return [];
      }
      throw Exception('Failed to load orders');
    }
  }
  Future<List<Supplier>> fetchSuppliers() async {
    
    final response = await http.get(Uri.parse(baseUrl+apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['suppliers'];
      return data.map((json) => Supplier.fromJson(json)).toList();
    } else {
      if(response.statusCode == 404)
      {
        return [];
      }
      throw Exception('Failed to load suppliers');
    }
  }
  Future<List<Category>> fetchCategories(id) async {
    
    final response = await http.get(Uri.parse(baseUrl+apiUrl+id));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['categories'];
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      if(response.statusCode == 404)
      {
        return [];
      }
      throw Exception('Failed to load categories');
    }
  }
  Future<List<SubCategory>> fetchSubCategories(id) async {
    
    final response = await http.get(Uri.parse(baseUrl+apiUrl+id));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['sub_categories'];
      return data.map((json) => SubCategory.fromJson(json)).toList();
    } else {
      if(response.statusCode == 404)
      {
        return [];
      }
      throw Exception('Failed to load sub categories');
    }
  }
  Future<List<OrderDetails>> fetchOrderDetails1(id) async {
    
    final response = await http.get(Uri.parse(baseUrl+apiUrl+id));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['sub_categories'];
      return data.map((json) => OrderDetails.fromJson(json)).toList();
    } else {
      if(response.statusCode == 404)
      {
        return [];
      }
      throw Exception('Failed to load sub categories');
    }
  }
  Future<Map<String,dynamic>> fetchOrderDetails(id, token) async {
      // Define your headers
    final Map<String, String> headers = {'Authorization': token};

    // Make the GET request with headers
    final response = await http.get(
      Uri.parse('${baseUrl}orders/'+id),
      headers: headers,
    );
    // throw Exception(response.body);

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      return responseBody;
    } else {
      throw Exception('Failed to load orders');
    }
  }
  Future<List<Item>> fetchItems(id) async {
    
    final response = await http.get(Uri.parse(baseUrl+apiUrl+id));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['items'];
      return data.map((json) => Item.fromJson(json)).toList();
    } else {
      if(response.statusCode == 404)
      {
        return [];
      }
      throw Exception('Failed to load items');
    }
  }
  Future<Map<String, dynamic>> checkout({
    required double totalPrice,
    required String paymentMethod,
    required List<Map<String, dynamic>> orderItems,
    required int tableId,
    required String token,
  }) async {
    final url = Uri.parse(baseUrl+apiUrl);
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = token;
    // Add fields to the request
    request.fields['total_price'] = totalPrice.toString();
    request.fields['payment_method'] = paymentMethod;
    request.fields['table_id'] = tableId.toString();

    // Add order items as JSON string in a field
    request.fields['order_items'] = jsonEncode(orderItems);

    // Optionally, you can add files to the request if needed
    // For example: request.files.add(await http.MultipartFile.fromPath('file', 'path/to/file'));

    // Send the request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201) {
      throw Exception('Failed to process checkout');
    }
    var orderResponse = json.decode(response.body);
    return orderResponse;
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to communicate with the server');
    }
  }
}

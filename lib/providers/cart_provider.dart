import 'package:flutter/material.dart';
import '../models/item.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  int addItem(Item item, int confirm) {
    if(confirm == 1) {
      clearCart();
    }
    if(itemCount > 0)
    {
      var sup = _items.values.first.supplier;
      if (sup == item.itemSupplier) {
        addNewItem(item);
      } else {
        return 0;
      }
    }
    addNewItem(item);
    notifyListeners();
    return 1;
  }
  
  void addNewItem(Item item) {
    if (_items.containsKey(item.itemId)) {
      _items.update(
        item.itemId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          itemId: existingCartItem.itemId,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
          supplier: item.itemSupplier,
        ),
      );
    } else {
      _items.putIfAbsent(
        item.itemId,
        () => CartItem(
          id: DateTime.now().toString(),
          itemId: item.itemId,
          title: item.itemName,
          quantity: 1,
          price: double.parse(item.itemPrice),
          imageUrl: item.itemImage,
          supplier: item.itemSupplier,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.remove(itemId);
    notifyListeners();
  }
  void updateItemQuantity(String productId, int newQuantity) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          itemId: existingCartItem.itemId,
          title: existingCartItem.title,
          quantity: newQuantity,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
          supplier: existingCartItem.supplier,
        ),
      );
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}

class CartItem {
  final String id;
  final String itemId;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  final String supplier;

  CartItem({
    required this.id,
    required this.itemId,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.supplier,
  });
}

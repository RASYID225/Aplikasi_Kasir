import 'package:flutter/material.dart';
import 'package:aplikasi_kasir/Models/Cart.dart';
import 'package:aplikasi_kasir/Services/DBHelper.dart';

class CartProvider extends ChangeNotifier {
  int counter = 0;
  var dBHelper = DBHelper();

  List<Cart> cart = [];

  Future<List<Cart>> getData() async {
    cart = await DBHelper().getCartList();
    notifyListeners();
    return cart;
  }

  void addCounter() {
    getData();
    counter = cart.length;
    notifyListeners();
  }

  void removeCounter() {
    counter--;
    counter = cart.length;
    notifyListeners();
  }

  void getCounter() {
    getData();
    counter = cart.length;
    notifyListeners();
  }

  void removeItem(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart.removeAt(index);
    notifyListeners();
  }

  // Method baru untuk tambah quantity
  Future<void> addQuantity(int id) async {
    final index = cart.indexWhere((element) => element.id == id);
    if (index != -1) {
      cart[index].quantity = (cart[index].quantity ?? 1) + 1;
      await dBHelper.updateQuantity(id, cart[index].quantity);
      notifyListeners();
    }
  }

  // Method baru untuk kurangi quantity
  Future<void> deleteQuantity(int id) async {
    final index = cart.indexWhere((element) => element.id == id);
    if (index != -1) {
      int currentQty = cart[index].quantity ?? 1;
      if (currentQty > 1) {
        cart[index].quantity = currentQty - 1;
        await dBHelper.updateQuantity(id, cart[index].quantity);
        notifyListeners();
      } else {
        // Auto-delete jika quantity = 1
        await dBHelper.deleteCartItem(id);
        cart.removeAt(index);
        notifyListeners();
      }
    }
  }

  Future<void> clearAllCart() async {
  await dBHelper.clearCart(); // Hapus data di SQLite
  cart.clear();               // Kosongkan list di UI
  counter = 0;                // Reset jumlah badge keranjang jadi 0
  notifyListeners();          // Beritahu UI untuk berubah
}
}

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:aplikasi_kasir/Controller/cartProvider.dart';
import 'package:aplikasi_kasir/Services/DBHelper.dart';
import 'package:aplikasi_kasir/Services/cart_screen.dart';
import 'package:aplikasi_kasir/Widgets/Alert.dart';
import 'package:aplikasi_kasir/Widgets/tombol_plus_minus.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var dBHelper = DBHelper();
  final cartProvider = CartProvider();

  void updateCount() async {
    await cartProvider.getData();
    setState(() {
      cartProvider.counter = cartProvider.cart.length;
    });
  }

  @override
  void initState() {
    super.initState();
    updateCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text(
          'Keranjang',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: cartProvider,
        builder: (context, child) {
          if (cartProvider.cart.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Keranjang Kosong',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartProvider.cart.length,
              itemBuilder: (context, index) {
                var item = cartProvider.cart[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.image!,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 70,
                                  width: 70,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nama_barang!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              PlusMinusButtons(
                                addQuantity: () async {
                                  await cartProvider.addQuantity(item.id!);
                                  updateCount();
                                },
                                deleteQuantity: () async {
                                  await cartProvider.deleteQuantity(item.id!);
                                  updateCount();
                                },
                                text: item.quantity.toString(),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            dBHelper.deleteCartItem(item.id!);
                            cartProvider.removeItem(item.id!);
                            cartProvider.removeCounter();
                          },
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red[400],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: cartProvider.cart.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  List dataList = cartProvider.cart
                      .map((i) => {"barang_id": i.id, "qty": i.quantity})
                      .toList();
                  var data = {"pesan": dataList};
                  var result = await Pesan().saveToDB(data);
                  if (result.status == true) {
                    AlertMessage().showAlert(
                      context,
                      "Transaksi berhasil disimpan",
                      true,
                    );
                    await cartProvider.clearAllCart();
                    cartProvider.cart.clear();
                    cartProvider.notifyListeners();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/history',
                      (_) => false,
                    );
                  } else {
                    AlertMessage().showAlert(context, result.message, false);
                  }
                },
                icon: const Icon(Icons.shopping_cart_checkout_rounded),
                label: const Text(
                  "Checkout Sekarang",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }
}

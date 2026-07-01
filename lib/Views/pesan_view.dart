import 'package:aplikasi_kasir/Widgets/bottom_Nav.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_kasir/Controller/cartProvider.dart';
import 'package:aplikasi_kasir/Models/Cart.dart';
import 'package:aplikasi_kasir/Services/DBHelper.dart';
import 'package:aplikasi_kasir/Services/Toko.dart';
import 'package:badges/badges.dart' as badges;

class PesanView extends StatefulWidget {
  const PesanView({super.key});

  @override
  State<PesanView> createState() => _PesanViewState();
}

class _PesanViewState extends State<PesanView> {
  var dBHelper = DBHelper();
  final cartProvider = CartProvider();
  List? produk;

  @override
  void initState() {
    super.initState();
    getbarang(); 
    updateCount(); 
  }

  getbarang() async { 
    var result = await TokoService().getBarangUser(); 
    setState(() { produk = result.data; }); 
  }

  void updateCount() async {
    await cartProvider.getData();
    setState(() {
      cartProvider.counter = cartProvider.cart.length;
    });
  }

  void saveData(int index) async {
    var product = produk![index];
    int productId = product.id;
    var detail = await dBHelper.getCartListDetail(productId);
    var qty = 0;
    if (detail != null && detail.isNotEmpty) {
      qty = (detail[0].quantity ?? 1) + 1;
      await dBHelper.updateQuantity(productId, qty);
    } else {
      await dBHelper.insert(
        Cart(
          id: productId,
          nama_barang: product.nama_barang ?? "",
          deskripsi: product.deskripsi ?? "",
          stok: product.stok ?? 0,
          harga: product.harga ?? 0,
          image: product.image ?? "",
          quantity: 1,
        ),
      );
    }
    updateCount();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.nama_barang} ditambah ke keranjang!"),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text('Menu Produk', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          badges.Badge(
            badgeContent: ListenableBuilder(
              listenable: cartProvider,
              builder: (context, child) {
                return Text(
                  cartProvider.cart.isEmpty ? '0' : '${cartProvider.counter}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                );
              },
            ),
            position: badges.BadgePosition.topEnd(top: 0, end: 2),
            badgeStyle: badges.BadgeStyle(badgeColor: Colors.orangeAccent),
            child: IconButton(
              onPressed: () => Navigator.pushNamed(context, "/cartScreen"),
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: produk != null
          ? ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: produk!.length,
              itemBuilder: (context, index) {
                var item = produk![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8, spreadRadius: 2, offset: const Offset(0, 4)
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            "${item.image}",
                            height: 80, width: 80, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 80, width: 80, color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nama_barang.toString(),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.deskripsi.toString(),
                                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Rp ${item.harga}',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.teal[700]),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => saveData(index),
                          icon: const Icon(Icons.add_circle),
                          color: Colors.teal,
                          iconSize: 36,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator(color: Colors.teal)),
      bottomNavigationBar: const BottomNav(1),
    );
  }
}
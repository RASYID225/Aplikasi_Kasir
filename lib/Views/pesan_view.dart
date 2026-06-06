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

  // ======= 1. TAMBAHKAN INITSTATE DI SINI =======
  @override
  void initState() {
    super.initState();
    getbarang(); // Memanggil API barang saat halaman dibuka
    updateCount(); // Memperbarui jumlah item di keranjang
  }
  // =============================================

  getbarang() async { 
  var result = await TokoService().getBarangUser(); 
  print("HASIL API: ${result.data}"); // Tambahkan baris ini untuk melihat di Log Console
  setState(() { 
    produk = result.data; 
  }); 
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
      print('Product quantity updated to $qty');
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
      SnackBar(content: Text("${product.nama_barang} ditambah ke keranjang!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Product List'),
        actions: [
          badges.Badge(
            badgeContent: ListenableBuilder(
              listenable: cartProvider,
              builder: (context, child) {
                if (cartProvider.cart.isEmpty) {
                  return const Text(
                    '0',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return Text(
                    '${cartProvider.counter}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            ),

            position: badges.BadgePosition.topEnd(top: 0, end: 2),

            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/cartScreen");
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: produk != null
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 8.0,
              ),
              shrinkWrap: true,
              itemCount: produk!.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.blueGrey.shade200,
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image(
                          height: 80,
                          width: 80,
                          image: NetworkImage("${produk![index].image}"),
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5.0),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                  text: 'Name: ',
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${produk![index].nama_barang.toString()}\n',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                maxLines: 1,
                                text: TextSpan(
                                  text: 'Overview: ',
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${produk![index].deskripsi.toString()}\n',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                maxLines: 1,
                                text: TextSpan(
                                  text: 'Price: Rp. ',
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${produk![index].harga.toString()}\n',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            iconColor: Colors.blueGrey.shade900,
                          ),
                          onPressed: () {
                            saveData(index);
                          },
                          child: const Text('Add to Cart'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: Text("data kosong")),
      bottomNavigationBar: BottomNav(1),
    );
  }
}

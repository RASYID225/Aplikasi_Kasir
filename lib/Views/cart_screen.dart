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
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Cart'),
        actions: [
          badges.Badge(
            badgeContent: ListenableBuilder(
              listenable: cartProvider,
              builder: (context, child) {
                if (cartProvider.cart.isEmpty) {
                  return Text(
                    '0',
                    style: const TextStyle(
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
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: cartProvider,
              builder: (context, child) {
                if (cartProvider.cart.isEmpty) {
                  return const Center(
                    child: Text(
                      'Your Cart is Empty',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartProvider.cart.length,
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
                                image: NetworkImage(
                                  cartProvider.cart[index].image!,
                                ),
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
                                                '${cartProvider.cart[index].nama_barang!}\n',
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
                              PlusMinusButtons(
                                addQuantity: () async {
                                  await cartProvider.addQuantity(
                                    cartProvider.cart[index].id!,
                                  );
                                  updateCount(); // ✅ BARU: Refresh UI setelah add quantity
                                },
                                deleteQuantity: () async {
                                  await cartProvider.deleteQuantity(
                                    cartProvider.cart[index].id!,
                                  );
                                  updateCount(); // ✅ BARU: Refresh UI setelah delete quantity
                                },
                                text: cartProvider.cart[index].quantity
                                    .toString(),
                              ),
                              IconButton(
                                onPressed: () {
                                  dBHelper.deleteCartItem(
                                    cartProvider.cart[index].id!,
                                  );
                                  cartProvider.removeItem(
                                    cartProvider.cart[index].id!,
                                  );
                                  cartProvider.removeCounter();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade800,
                                ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: "Settings",
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        onPressed: () async {
          List dataList = cartProvider.cart.map((i) {
            return {"barang_id": i.id, "qty": i.quantity}; // ✅ Sesuai API spec
          }).toList();
          var data = {"pesan": dataList};
          var result = await Pesan().saveToDB(data);
          if (result.status == true) {
            AlertMessage().showAlert(
              context,
              "Transaksi berhasil disimpan",
              true,
            );

            await cartProvider.clearAllCart();

            cartProvider.cart.clear(); // ✅ Clear cart setelah sukses
            cartProvider.notifyListeners();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/history',
              (_) => false,
            ); // ✅ Navigasi ke history setelah checkout
          } else {
            AlertMessage().showAlert(
              context,
              result.message,
              false,
            ); // ✅ Show error message
          }
        },
        icon: const Icon(
          Icons.shopping_cart_checkout_rounded,
          color: Colors.white,
        ),
        label: const Text("Checkout"),
      ),
    );
  }
}

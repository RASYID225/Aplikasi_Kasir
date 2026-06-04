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
  List? movie; 
  getMoview() async { 
    var result = await TokoService().getMovieUser(); 
    setState(() { 
      movie = result.data; 
    }); 
  } 
 
  void updateCount() async { 
    await cartProvider.getData(); 
    setState(() { 
      cartProvider.counter = cartProvider.cart.length; 
    }); 
  } 
 
  void saveData(int index) async { 
    var product = movie![index];
    int productId = product.id;
    var detail = await dBHelper.getCartListDetail(productId); 
    var qty = 0; 
    if (detail != null && detail.isNotEmpty) { 
      qty = detail[0].quantity; 
    } 
 
    dBHelper 
        .insert( 
          Cart( 
            id: productId, 
            id_movie: productId.toString(), 
            title: product.nama_barang ?? "", 
            voteaverage: product.harga?.toDouble() ?? 0.0, 
            overview: product.deskripsi ?? "", 
            quantity: qty + 1, 
            posterpath: product.image ?? "", 
          ), 
        ) 
        .then((value) { 
          updateCount(); 
          print('Product Added to cart'); 
        }); 
  } 
 
  @override 
  void initState() { 
    super.initState(); 
    getMoview(); 
    updateCount(); 
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
      body: 
          movie != null 
              ? ListView.builder( 
                padding: const EdgeInsets.symmetric( 
                  vertical: 10.0, 
                  horizontal: 8.0, 
                ), 
                shrinkWrap: true, 
                itemCount: movie!.length, 
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
                            image: NetworkImage("${movie![index].image}"), 
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
                                            '${movie![index].nama_barang.toString()}\n', 
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
                                            '${movie![index].deskripsi.toString()}\n', 
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
                                    text: 
                                        'Price: Rp. ', 
                                    style: TextStyle( 
                                      color: Colors.blueGrey.shade800, 
                                      fontSize: 16.0, 
                                    ), 
                                    children: [ 
                                      TextSpan( 
                                        text: '${movie![index].harga.toString()}\n', 
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
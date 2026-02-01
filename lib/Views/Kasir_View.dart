import 'package:aplikasi_kasir/Views/View_Dashboard.dart';
import 'package:flutter/material.dart';

class KasirView extends StatelessWidget {
  const KasirView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kasir"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // ===== DAFTAR PRODUK =====
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _itemProduk("Produk A", "Rp 10.000"),
                  _itemProduk("Produk B", "Rp 15.000"),
                  _itemProduk("Produk C", "Rp 20.000"),
                  _itemProduk("Produk D", "Rp 25.000"),
                  _itemProduk("Produk E", "Rp 30.000"),
                ],
              ),
            ),
          ),
          Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/Dashboard');
                      },
                      child: const Text("Kembali ke Dashboard"),
                    ),
                  ],
                ),

          // ===== TOTAL & BAYAR =====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rp 100.000",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "BAYAR",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ===== WIDGET ITEM PRODUK =====
  Widget _itemProduk(String nama, String harga) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          color: Colors.grey,
          child: const Icon(Icons.shopping_bag),
        ),
        title: Text(nama),
        subtitle: Text(harga),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.remove),
            ),
            const Text("1"),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

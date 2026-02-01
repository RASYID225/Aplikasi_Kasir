import 'package:aplikasi_kasir/Widgets/bottom_Nav.dart';
import 'package:flutter/material.dart';

class ProdukView extends StatefulWidget {
  const ProdukView({super.key});

  @override
  State<ProdukView> createState() => _ProdukViewState();
}

class _ProdukViewState extends State<ProdukView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Produk"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                "Halaman Produk",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            // PRODUK 1
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey,
                  child: const Icon(Icons.image),
                ),
                title: const Text("kepiting saus padang"),
                subtitle: const Text("Rp 100.000"),
                isThreeLine: true,
              ),
            ),

            // PRODUK 2
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey,
                  child: const Icon(Icons.image),
                ),
                title: const Text("nasi goreng"),
                subtitle: const Text("Rp 100.000.000"),
                isThreeLine: true,
              ),
            ),

            // PRODUK 3
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey,
                  child: const Icon(Icons.image),
                ),
                title: const Text("babi panggang"),
                subtitle: const Text("Rp 10.000.000.000"),
                isThreeLine: true,
              ),
            ),

            // PRODUK 4
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey,
                  child: const Icon(Icons.image),
                ),
                title: const Text("sate ayam"),
                subtitle: const Text("Rp 1.000.000.000.000"),
                isThreeLine: true,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}

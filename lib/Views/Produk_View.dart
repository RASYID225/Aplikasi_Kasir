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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30),
              color: Colors.teal,
              child: Center(
                child: Text(
                  "Halaman Produk",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            // PRODUK 1
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: const Icon(Icons.image),
                ),
                title: const Text("kepiting saus padang"),
                subtitle: const Text("Rp 100.000"),
                isThreeLine: true,
              ),
            ),

            SizedBox(height: 15),
            // PRODUK 2
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: const Icon(Icons.image),
                ),
                title: const Text("nasi goreng"),
                subtitle: const Text("Rp 100.000.000"),
                isThreeLine: true,
              ),
            ),

            SizedBox(height: 15),
            // PRODUK 3
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: const Icon(Icons.image),
                ),
                title: const Text("babi panggang"),
                subtitle: const Text("Rp 10.000.000.000"),
                isThreeLine: true,
              ),
            ),

            SizedBox(height: 15),
            // PRODUK 4
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: const Icon(Icons.image),
                ),
                title: const Text("sate ayam"),
                subtitle: const Text("Rp 1.000.000.000.000"),
                isThreeLine: true,
              ),
            ),

            SizedBox(height: 15),
            // PRODUK 4
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: const Icon(Icons.image),
                ),
                title: const Text("sate ayam"),
                subtitle: const Text("Rp 1.000.000.000.000"),
                isThreeLine: true,
              ),
            ),

            SizedBox(height: 15),
            // PRODUK 4
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: const Icon(Icons.image),
                ),
                title: const Text("sate ayam"),
                subtitle: const Text("Rp 1.000.000.000.000"),
                isThreeLine: true,
              ),
            ),

            SizedBox(height: 15),
            // PRODUK 4
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: const Icon(Icons.image),
                ),
                title: const Text("sate ayam"),
                subtitle: const Text("Rp 1.000.000.000.000"),
                isThreeLine: true,
              ),
            ),

            SizedBox(height: 15),
            // PRODUK 4
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: const Icon(Icons.image),
                ),
                title: const Text("sate ayam"),
                subtitle: const Text("Rp 1.000.000.000.000"),
                isThreeLine: true,
              ),
            ),

            SizedBox(height: 15),
            // PRODUK 4
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: Container(
                  width: 100,
                  height: 100,
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

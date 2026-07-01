import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasi_kasir/Widgets/bottom_Nav.dart';
import 'package:aplikasi_kasir/Models/User_Login.dart';
import 'package:aplikasi_kasir/Services/Url.dart' as url;

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List historyList = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchHistoryTransaksi(); 
  }

  Future<void> fetchHistoryTransaksi() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      setState(() {
        isLoading = false;
        errorMessage = "Anda belum login atau token kedaluwarsa.";
      });
      return;
    }

    var uri = Uri.parse(url.BaseUrl + "/user/history_trans");
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
      'Content-Type': "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          historyList = data['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Gagal memuat riwayat (${response.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Terjadi kesalahan koneksi: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("History Transaksi", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
          : historyList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text("Belum ada riwayat transaksi.", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            ) 
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                var item = historyList[index];
                String nama_barang = item['nama_barang'] ?? 'Produk Kasir';
                String qty = item['qty']?.toString() ?? '0';
                int harga = int.tryParse(item['harga']?.toString() ?? '0') ?? 0;
                String tanggal = item['created_at']?.toString().split('T')[0] ?? '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.receipt_rounded, color: Colors.teal),
                    ),
                    title: Text(nama_barang, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Jumlah: $qty pcs\nTotal: Rp $harga",
                        style: TextStyle(color: Colors.grey[700], height: 1.4),
                      ),
                    ),
                    trailing: Text(
                      tanggal,
                      style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      bottomNavigationBar: const BottomNav(2),
    );
  }
}
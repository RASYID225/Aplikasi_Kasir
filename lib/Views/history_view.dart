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
    fetchHistoryTransaksi(); // Jalankan fungsi ambil data saat halaman dibuka
  }

  // Fungsi untuk mengambil data history transaksi dari API Backend
  Future<void> fetchHistoryTransaksi() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    // Validasi token login
    if (user.status == false) {
      setState(() {
        isLoading = false;
        errorMessage = "Anda belum login atau token kedaluwarsa.";
      });
      return;
    }

    // Endpoint sesuai spesifikasi Postman kamu: /user/history_trans
    var uri = Uri.parse(url.BaseUrl + "/user/history_trans");
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
      'Content-Type': "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);
      print("STATUS HISTORY: ${response.statusCode}");
      print("BODY HISTORY: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          // Menyesuaikan array data dari response API milikmu
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
      appBar: AppBar(
        title: const Text("History Transaksi"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      // Kondisi Pengkondisian Tampilan Layar
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // 1. Loading pas ambil API
          : errorMessage.isNotEmpty
          ? Center(
              child: Text(errorMessage),
            ) // 2. Jika ada error jaringan/token
          : historyList.isEmpty
          ? const Center(
              child: Text("Belum ada riwayat transaksi."),
            ) // 3. Jika data kosong
          : ListView.builder(
              // 4. Jika sukses, render datanya di sini
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                var item = historyList[index];

                // Catatan: Sesuaikan nama key JSON ini ('nama_barang', 'qty', 'harga')
                // dengan field database asli yang dikembalikan oleh server kamu.
                String nama_barang = item['nama_barang'] ?? 'Produk Kasir';
                String qty = item['qty']?.toString() ?? '0';
                int harga = int.tryParse(item['harga']?.toString() ?? '0') ?? 0;
                String tanggal =
                    item['created_at']?.toString().split('T')[0] ?? '';

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.receipt_long, color: Colors.white),
                    ),
                    title: Text(
                      nama_barang,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Jumlah: $qty pcs\nTotal: Rp $harga"),
                    trailing: Text(
                      tanggal,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNav(2),
    );
  }
}

import 'package:aplikasi_kasir/Models/response_data_list.dart';
import 'package:aplikasi_kasir/Models/Toko_Models.dart';
import 'package:aplikasi_kasir/Services/Toko.dart';
import 'package:aplikasi_kasir/Views/Tambah_Toko_View.dart';
import 'package:aplikasi_kasir/Widgets/Alert.dart';
import 'package:aplikasi_kasir/Widgets/bottom_Nav.dart';
import 'package:flutter/material.dart';

class TokoView extends StatefulWidget {
  const TokoView({super.key});

  @override
  State<TokoView> createState() => _TokoViewState();
}

class _TokoViewState extends State<TokoView> {
  TokoService tokoService = TokoService();
  List<TokoModels>? tokoList;
  bool isLoading = true;
  String? errorMessage;

  // Fungsi untuk mengambil data barang
  Future<void> fetchToko() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      ResponseDataList response = await tokoService.getToko();

      setState(() {
        if (response.status == true && response.data != null) {
          tokoList = response.data as List<TokoModels>;
        } else {
          tokoList = [];
          errorMessage = response.message;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Terjadi kesalahan: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchToko();
  }

  // Fungsi untuk delete barang
  Future<void> deleteBarang(int id, String namaBarang) async {
    // Tampilkan dialog konfirmasi
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Barang?'),
          content: Text('Apakah Anda yakin ingin menghapus "$namaBarang"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                var result = await tokoService.hapusToko(id);

                if (mounted) {
                  if (result.status == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result.message),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    // Refresh data setelah delete
                    fetchToko();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal menghapus: ${result.message}'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        title: Text(
          "Daftar Produk",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                tokoList != null ? "${tokoList!.length} Item" : "0 Item",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFF5F5F5),
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF1E88E5),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Memuat data produk...",
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              )
            : errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    SizedBox(height: 16),
                    Text(
                      "Terjadi Kesalahan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        errorMessage ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: fetchToko,
                      icon: Icon(Icons.refresh),
                      label: Text("Coba Lagi"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : tokoList == null || tokoList!.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Belum Ada Produk",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Tambahkan produk baru untuk memulai",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: fetchToko,
                color: Color(0xFF1E88E5),
                child: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: tokoList!.length,
                  itemBuilder: (context, index) {
                    TokoModels barang = tokoList![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TambahTokoView(
                                title: "Edit Produk",
                                item: barang,
                              ),
                            ),
                          ).then((_) {
                            fetchToko(); // Refresh setelah edit
                          });
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                // Image Section
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    color: Colors.grey[200],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    child:
                                        barang.image != null &&
                                            barang.image!.isNotEmpty
                                        ? Image.network(
                                            barang.image!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey[400],
                                                    size: 40,
                                                  );
                                                },
                                          )
                                        : Icon(
                                            Icons.image,
                                            color: Colors.grey[400],
                                            size: 40,
                                          ),
                                  ),
                                ),
                                // Content Section
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Nama Barang
                                        Text(
                                          barang.nama_barang ?? "-",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        // Harga
                                        Text(
                                          "Rp ${(barang.harga ?? 0).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1E88E5),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        // Stok
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: (barang.stok ?? 0) > 0
                                                ? Colors.green[50]
                                                : Colors.red[50],
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            "Stok: ${barang.stok ?? 0}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: (barang.stok ?? 0) > 0
                                                  ? Colors.green[700]
                                                  : Colors.red[700],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Action Buttons
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, size: 20),
                                      color: Colors.amber[700],
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TambahTokoView(
                                                  title: "Edit Produk",
                                                  item: barang,
                                                ),
                                          ),
                                        ).then((_) {
                                          fetchToko();
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, size: 20),
                                      color: Colors.red[400],
                                      onPressed: () {
                                        deleteBarang(
                                          barang.id ?? 0,
                                          barang.nama_barang ?? "Produk",
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahTokoView(title: "Tambah Produk"),
            ),
          ).then((_) {
            fetchToko(); // Refresh setelah tambah
          });
        },
        backgroundColor: Color(0xFF1E88E5),
        label: Text("Tambah Produk"),
        icon: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}

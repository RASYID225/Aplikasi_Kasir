import 'package:aplikasi_kasir/Services/Url.dart' as url;

class TokoModels {
  int? id;
  String? nama_barang;
  String? deskripsi;
  int? stok;
  int? harga;
  String? image;
  TokoModels({
    required this.id,
    required this.nama_barang,
    this.deskripsi,
    this.stok,
    this.harga,
    required this.image,
  });
  TokoModels.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    nama_barang = parsedJson["nama_barang"];
    deskripsi = parsedJson["deskripsi"];
    stok = int.tryParse(parsedJson["stok"].toString() ?? "0") ?? 0;
    harga = int.tryParse(parsedJson["harga"].toString() ?? "0") ?? 0;
    image = "${url.BaseUrlImage}/${parsedJson["image"]}";
  }
}

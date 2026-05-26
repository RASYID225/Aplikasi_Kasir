import 'package:aplikasi_kasir/services/url.dart' as url;

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
    id = int.parse(parsedJson["id"].toString());
    nama_barang = parsedJson["nama_barang"];
    deskripsi = parsedJson["deskripsi"];
    stok = int.parse(parsedJson["stok"].toString());
    harga = int.parse(parsedJson["harga"].toString());
    image = "${url.BaseUrlImage}/${parsedJson["image"]}";
  }
}

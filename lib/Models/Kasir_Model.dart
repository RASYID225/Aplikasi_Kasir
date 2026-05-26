import 'package:aplikasi_kasir/Services/url.dart' as url;

class KasirModel {
  int? id;
  String? nama_barang;
  String? deskripsi;
  int? stok;
  int? harga;
  String? image;
  KasirModel({
    required this.id,
    required this.nama_barang,
    this.deskripsi,
    this.stok,
    this.harga,
    required this.image,
  });
  KasirModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    nama_barang = parsedJson["nama_barang"];
    deskripsi = parsedJson["deskripsi"];
    stok = int.parse(parsedJson["stok"].toString());
    harga = int.parse(parsedJson["harga"].toString());
    image = "${url.BaseUrlImage}/${parsedJson["image"]}";
  }
}

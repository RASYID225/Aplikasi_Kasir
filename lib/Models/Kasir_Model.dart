import 'package:aplikasi_kasir/Services/url.dart' as url;

class KasirModel {
  int? id;
  String? nama_barang;
  String? deskripsi;
  double? stok;
  double? harga;
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
    stok = double.parse(parsedJson["stok"].toString());
    harga = double.parse(parsedJson["harga"].toString());
    image = "${url.BaseUrlTanpaApi}/${parsedJson["image"]}";
  }
}

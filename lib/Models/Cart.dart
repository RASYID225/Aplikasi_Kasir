import 'package:aplikasi_kasir/Services/Url.dart' as url;

class Cart {
  int? id;
  String? nama_barang;
  String? deskripsi;
  int? stok;
  int? harga;
  String? image;
  int? quantity = 1;
  Cart({
    required this.id,
    required this.nama_barang,
    required this.deskripsi,
    required this.stok,
    required this.harga,
    required this.image,
    required this.quantity,
  });

  factory Cart.fromMap(Map<dynamic, dynamic> data) {
    return Cart(
      id: data['id'],
      nama_barang: data['nama_barang'],
      deskripsi: data['deskripsi'],
      stok: int.tryParse(data['stok'].toString()),
      harga: int.tryParse(data['harga'].toString()),
      image: data['image'],
      quantity: int.tryParse(data['quantity'].toString()) ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_barang': nama_barang,
      'deskripsi': deskripsi,
      'stok': stok,
      'harga': harga,
      'image': image,
      'quantity': quantity,
    };
  }

  Map<String, dynamic> fromMap() {
    return {
      'id': id,
      'nama_barang': nama_barang,
      'deskripsi': deskripsi,
      'stok': stok,
      'harga': harga,
      'image': image,
      'quantity': quantity,
    };
  }
}

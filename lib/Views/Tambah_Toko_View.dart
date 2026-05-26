import 'package:aplikasi_kasir/Models/Kasir_Model.dart';
import 'package:aplikasi_kasir/Services/kasir.dart';
import 'package:flutter/material.dart';

class TambahTokoView extends StatefulWidget {
  final String title;
  final Map item;

  const TambahTokoView({super.key, required this.title, required this.item});

  @override
  State<TambahTokoView> createState() => _TambahTokoViewState();
}

class _TambahTokoViewState extends State<TambahTokoView> {
  get title => null;
  
  get item => null;

  @override
  Widget build(BuildContext context) {
    String title;
    KasirModel? item;
    TambahTokoView( title: 'tambah toko',item: {},);
    TokoService toko = TokoService();
    return const Placeholder();
  }
}

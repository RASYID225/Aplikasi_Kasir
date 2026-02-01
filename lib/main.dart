import 'package:aplikasi_kasir/Views/Login_View.dart';
import 'package:aplikasi_kasir/Views/Produk_View.dart';
import 'package:aplikasi_kasir/Views/Kasir_View.dart';
import 'package:aplikasi_kasir/Views/RegisKasir.dart';
import 'package:aplikasi_kasir/Views/View_Dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => RegisterUserView(),
        '/Login': (context) => LoginView(),
        '/Dashboard': (context) => DashboardView(),
        '/Produk': (context) => ProdukView(),
        '/Kasir': (context) => KasirView(),
      },  
    );
  }
}

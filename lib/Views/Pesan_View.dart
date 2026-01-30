import 'package:aplikasi_kasir/Widgets/bottom_Nav.dart';
import 'package:flutter/material.dart'; 
 
class PesanView extends StatefulWidget { 
  const PesanView({super.key}); 
 
  @override 
  State<PesanView> createState() => _PesanViewState(); 
} 
 
class _PesanViewState extends State<PesanView> { 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text("Pesan"), 
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white, 
      ), 
      body: Center(
        child: Text("SELAMAT DATANG TEMAN-TEMAN TERIMAKASIH SUDAH MENGGUNAKAN APLIKASI INI", 
        style: TextStyle(fontSize: 40, fontWeight:FontWeight.bold), textAlign: TextAlign.center, 
        ),
      ),
      bottomNavigationBar: BottomNav(1),
    ); 
  } 
} 
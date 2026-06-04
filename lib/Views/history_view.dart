import 'package:flutter/material.dart'; 
import 'package:aplikasi_kasir/Widgets/bottom_Nav.dart'; 
 
class HistoryView extends StatefulWidget { 
  const HistoryView({super.key}); 
 
  @override 
  State<HistoryView> createState() => _HistoryViewState(); 
} 
 
class _HistoryViewState extends State<HistoryView> { 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text("History Transaksi"), 
        backgroundColor: Colors.green, 
        foregroundColor: Colors.white, 
      ), 
      body: Center(child: Text("Selamat Datang ")), 
      bottomNavigationBar: BottomNav(2), 
    ); 
  } 
} 
import 'package:aplikasi_kasir/Models/User_Login.dart';
import 'package:aplikasi_kasir/Widgets/bottom_Nav.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  UserLogin userLogin = UserLogin();

  String? nama;
  String? role;
  getUserLogin() async {
    var user = await userLogin.getUserLogin();
    print(user.status);
    if (user.status != false) {
      setState(() {
        nama = user.nama_user;
        role = user.role;
      });
    } else {
      print("object");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Dashboard"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/login');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(child: Text("Selamat Datang $nama role anda $role")),
      bottomNavigationBar: BottomNav(0),
    );
  }
}

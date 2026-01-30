import 'package:aplikasi_kasir/Models/User_Login.dart';
import 'package:flutter/material.dart'; 
 
class BottomNav extends StatefulWidget { 
  int activePage; 
  BottomNav(this.activePage); 
 
  @override 
  State<BottomNav> createState() => _BottomNavState(); 
} 
 
class _BottomNavState extends State<BottomNav> { 
  UserLogin userLogin = UserLogin(); 
  String? role; 
  getDataLogin() async { 
    var user = await userLogin!.getUserLogin(); 
    if (user!.status != false) { 
      setState(() { 
        role = user.role; 
      }); 
    } else { 
      Navigator.popAndPushNamed(context, '/Login'); 
    } 
  } 
 
  @override 
  void initState() { 
    // TODO: implement initState 
    super.initState(); 
    getDataLogin(); 
  } 
 
  void getLink(index) { 
    if (role == "admin") { 
      if (index == 0) { 
        Navigator.pushReplacementNamed(context, '/Dashboard'); 
      } else if (index == 1) { 
        Navigator.pushReplacementNamed(context, '/Produk'); 
      } 
    } else if (role == "user") { 
      if (index == 0) { 
        Navigator.pushReplacementNamed(context, '/Dashboard'); 
      } else if (index == 1) { 
        Navigator.pushReplacementNamed(context, '/Pesan'); 
      } 
    } 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return role == "admin" 
        ? BottomNavigationBar( 
            selectedItemColor: Colors.black, 
            unselectedItemColor: Colors.grey, 
            currentIndex: widget.activePage, 
            onTap: (index) => {getLink(index)}, 
            items: [ 
                BottomNavigationBarItem( 
                  icon: Icon(Icons.home), 
                  label: 'Home', 
                ), 
                BottomNavigationBarItem( 
                  icon: Icon(Icons.file_copy), 
                  label: 'Produk', 
                ), 
              ]) 
        : role == "user" 
            ? BottomNavigationBar( 
                selectedItemColor: Colors.black, 
                unselectedItemColor: Colors.grey, 
                currentIndex: widget.activePage, 
                onTap: (index) => {getLink(index)}, 
                items: [ 
                    BottomNavigationBarItem( 
                      icon: Icon(Icons.home), 
                      label: 'Home', 
                    ), 
                    BottomNavigationBarItem( 
                      icon: Icon(Icons.card_giftcard), 
                      label: 'Pesan', 
                    ), 
                  ]) 
            : Text(""); 
  } 
} 
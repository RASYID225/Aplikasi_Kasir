import 'package:aplikasi_kasir/Models/response_data_list.dart';
import 'package:aplikasi_kasir/Services/kasir.dart';
import 'package:aplikasi_kasir/Views/Kasir_View.dart';
import 'package:aplikasi_kasir/Widgets/bottom_Nav.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_kasir/Models/Toko_Models.dart';

class TokoView extends StatefulWidget {
  const TokoView({super.key});

  @override
  State<TokoView> createState() => _TokoViewState();
}

class _TokoViewState extends State<TokoView> {
  TokoService tokoService = TokoService();
  List? kasir;
  getFilm() async {
    ResponseDataList getKasir = await tokoService.getKasir();
    setState(() {
      kasir = getKasir.data;
    });
  }

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    getFilm();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kasir"),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
      ),
      body: kasir != null
          ? ListView.builder(
              itemCount: kasir!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image(
                      image: NetworkImage(kasir![index].posterpath),
                    ),
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNav(2),
    );
  }
}

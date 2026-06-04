import 'package:aplikasi_kasir/Models/response_data_list.dart';
import 'package:aplikasi_kasir/Services/Toko.dart';
import 'package:aplikasi_kasir/Views/Tambah_Toko_View.dart';
import 'package:aplikasi_kasir/Widgets/Alert.dart';
import 'package:aplikasi_kasir/Widgets/bottom_Nav.dart';
import 'package:flutter/material.dart';


class TokoView extends StatefulWidget {
  const TokoView({super.key});

  @override
  State<TokoView> createState() => _TokoViewState();
}

class _TokoViewState extends State<TokoView> {
  TokoService tokoService = TokoService();
  List action = ["Update", "Hapus"];
  List? toko;
  getToko() async {
    ResponseDataList getToko = await tokoService.getToko();
    setState(() {
      toko = getToko.data;
    });
    print(getToko.data);
  }

  @override
  void initState() {
    super.initState();
    getToko();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produks"),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TambahTokoView(title: "Tambah Toko"),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: toko != null
          ? ListView.builder(
              itemCount: toko!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image(image: NetworkImage(toko![index].image)),
                    title: Text(toko![index].nama_barang ?? ""),
                    trailing: PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return action.map((r) {
                          return PopupMenuItem(
                            onTap: () async {
                              if (r == "Update") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TambahTokoView(
                                      title: "Update Toko",
                                      item: toko![index],
                                    ),
                                  ),
                                );
                              } else {
                                var results = await AlertMessage()
                                    .showAlertDialog(context);
                                if (results != null &&
                                    results.containsKey('status')) {
                                  if (results['status'] == true) {
                                    var res = await tokoService.hapusToko(
                                      context,
                                      toko![index].id,
                                    );
                                    if (res.status == true) {
                                      AlertMessage().showAlert(
                                        context,
                                        res.message,
                                        true,
                                      );
                                      getToko();
                                    } else {
                                      AlertMessage().showAlert(
                                        context,
                                        res.message,
                                        false,
                                      );
                                    }
                                  }
                                }
                              }
                            },
                            value: r,
                            child: Text(r),
                          );
                        }).toList();
                      },
                    ),
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNav(1),
    );
  }
}

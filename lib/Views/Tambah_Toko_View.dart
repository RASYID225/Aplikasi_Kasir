import 'dart:io';
import 'package:aplikasi_kasir/Models/Toko_Models.dart';
import 'package:aplikasi_kasir/Services/Toko.dart';
import 'package:aplikasi_kasir/Widgets/Alert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahTokoView extends StatefulWidget {
  final String title;
  final TokoModels? item;
  const TambahTokoView({super.key, required this.title, this.item});

  @override
  State<TambahTokoView> createState() => _TambahTokoViewState();
}

class _TambahTokoViewState extends State<TambahTokoView> {
  TokoService tokoService = TokoService();
  final formKey = GlobalKey<FormState>();
  TextEditingController namaBarangController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  File? selectedImage;
  bool isLoading = false;

  Future getImage() async {
    setState(() {
      isLoading = true;
    });
    var img = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (img != null) {
        selectedImage = File(img.path);
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      namaBarangController.text = widget.item!.nama_barang ?? "";
      hargaController.text = widget.item!.harga?.toString() ?? "";
      deskripsiController.text = widget.item!.deskripsi ?? "";
      selectedImage = null;
    } else {
      namaBarangController.clear();
      hargaController.clear();
      deskripsiController.clear();
      selectedImage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: namaBarangController,
                    decoration: InputDecoration(label: Text("Nama Barang")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'harus diisi';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    controller: hargaController,
                    decoration: InputDecoration(label: Text("Harga")),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'harus diisi';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    controller: deskripsiController,
                    decoration: InputDecoration(label: Text("Deskripsi")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'harus diisi';
                      } else {
                        return null;
                      }
                    }),
                SizedBox(height: 10),
                TextButton(
                    onPressed: () {
                      getImage();
                    },
                    child: Text("Select Picture")),
                selectedImage != null
                    ? Container(
                        height: 200,
                        width: double.infinity,
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      )
                    : isLoading == true
                        ? CircularProgressIndicator()
                        : Center(child: Text("Please Get the Images")),
                SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var data = {
                          "nama_barang": namaBarangController.text,
                          "harga": hargaController.text,
                          "deskripsi": deskripsiController.text,
                        };
                        var result;
                        if (widget.item != null) {
                          result = await tokoService.insertToko(
                              data, selectedImage, widget.item!.id!);
                        } else {
                          result = await tokoService.insertToko(
                              data, selectedImage, null);
                        }

                        if (result.status == true) {
                          AlertMessage()
                              .showAlert(context, result.message, true);
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/Produk');
                        } else {
                          AlertMessage()
                              .showAlert(context, result.message, false);
                        }
                      }
                    },
                    child: Text("Simpan"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

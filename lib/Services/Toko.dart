import 'dart:convert';
import 'dart:io';
import 'package:aplikasi_kasir/Models/response_data_list.dart';
import 'package:aplikasi_kasir/Models/Toko_Models.dart';
import 'package:aplikasi_kasir/Models/response_data_map.dart';
import 'package:aplikasi_kasir/Models/User_Login.dart';
import 'package:aplikasi_kasir/Services/Url.dart' as url;
import 'package:http/http.dart' as http;

class TokoService {
  // ✅ GET - Ambil semua barang
  Future<ResponseDataList> getToko() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataList(
        status: false,
        message: 'Anda belum login / token invalid',
      );
    }

    try {
      var uri = Uri.parse("${url.BaseUrl}/admin/getbarang");
      Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};

      var response = await http
          .get(uri, headers: headers)
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data["status"] == true) {
          List<TokoModels> toko = (data["data"] as List)
              .map((r) => TokoModels.fromJson(r))
              .toList();

          return ResponseDataList(
            status: true,
            message: data["message"] ?? 'Berhasil mengambil data',
            data: toko,
          );
        } else {
          return ResponseDataList(
            status: false,
            message: data["message"] ?? 'Gagal mengambil data',
          );
        }
      } else {
        return ResponseDataList(
          status: false,
          message: "Error: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ResponseDataList(status: false, message: "Error: ${e.toString()}");
    }
  }

  // ✅ POST - Insert/Update barang dengan gambar
  Future<ResponseDataMap> insertToko({
    required Map<String, dynamic> request,
    File? image,
    int? id,
  }) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataMap(
        status: false,
        message: 'Anda belum login / token invalid',
      );
    }

    try {
      // Tentukan URL berdasarkan insert atau update
      String endpoint = id == null
          ? "/admin/insertbarang"
          : "/admin/updatebarang/$id";

      var multipartRequest = http.MultipartRequest(
        'POST',
        Uri.parse("${url.BaseUrl}$endpoint"),
      );

      // Tambahkan headers
      multipartRequest.headers.addAll({
        "Authorization": 'Bearer ${user.token}',
      });

      // Tambahkan fields dari request
      request.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          multipartRequest.fields[key] = value.toString();
        }
      });

      // Tambahkan gambar jika ada
      if (image != null) {
        var stream = http.ByteStream(image.openRead());
        var length = await image.length();
        var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: image.path.split('/').last,
        );
        multipartRequest.files.add(multipartFile);
      }

      // Send request
      var response = await multipartRequest.send().timeout(
        Duration(seconds: 30),
      );

      var result = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(result.body);

        if (data["status"] == true) {
          return ResponseDataMap(
            status: true,
            message: data["message"] ?? 'Data berhasil disimpan',
          );
        } else {
          return ResponseDataMap(
            status: false,
            message: data["message"] ?? 'Gagal menyimpan data',
          );
        }
      } else {
        return ResponseDataMap(
          status: false,
          message: "Error: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ResponseDataMap(status: false, message: "Error: ${e.toString()}");
    }
  }

  // ✅ DELETE - Hapus barang
  Future<ResponseDataList> hapusToko(int id) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataList(
        status: false,
        message: 'Anda belum login / token invalid',
      );
    }

    try {
      var uri = Uri.parse("${url.BaseUrl}/admin/hapusbarang/$id");
      Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};

      var response = await http
          .delete(uri, headers: headers)
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        if (result["status"] == true) {
          return ResponseDataList(
            status: true,
            message: result["message"] ?? 'Data berhasil dihapus',
          );
        } else {
          return ResponseDataList(
            status: false,
            message: result["message"] ?? 'Gagal menghapus data',
          );
        }
      } else {
        return ResponseDataList(
          status: false,
          message: "Error: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ResponseDataList(status: false, message: "Error: ${e.toString()}");
    }
  }

  // ✅ GET - Ambil barang untuk user
  Future<ResponseDataList> getBarangUser() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataList(
        status: false,
        message: 'Anda belum login / token invalid',
      );
    }

    try {
      var uri = Uri.parse("${url.BaseUrl}/user/getbarang");
      Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};

      var response = await http
          .get(uri, headers: headers)
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data["status"] == true) {
          List<TokoModels> barang = (data["data"] as List)
              .map((r) => TokoModels.fromJson(r))
              .toList();

          return ResponseDataList(
            status: true,
            message: data["message"] ?? 'Berhasil mengambil data',
            data: barang,
          );
        } else {
          return ResponseDataList(
            status: false,
            message: data["message"] ?? 'Gagal mengambil data',
          );
        }
      } else {
        return ResponseDataList(
          status: false,
          message: "Error: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ResponseDataList(status: false, message: "Error: ${e.toString()}");
    }
  }
}

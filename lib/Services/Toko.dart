import 'dart:convert';
import 'package:aplikasi_kasir/Models/response_data_list.dart';
import 'package:aplikasi_kasir/Models/Toko_Models.dart';
import 'package:aplikasi_kasir/Models/response_data_map.dart';
import 'package:aplikasi_kasir/Models/User_Login.dart';
import 'package:aplikasi_kasir/Services/Url.dart' as url;
import 'package:http/http.dart' as http;

class TokoService {
  Future<ResponseDataList> getToko() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
        status: false,
        message: 'anda belum login / token invalid',
      );
      return response;
    }
    var uri = Uri.parse("${url.BaseUrl}/admin/getbarang");
    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};
    var getToko = await http.get(uri, headers: headers);
    // print(getToko.body);
    if (getToko.statusCode == 200) {
      var data = json.decode(getToko.body);
      // print(data);
      if (data["status"] == true) {
        // print(data["data"]);
        List toko = data["data"].map((r) => TokoModels.fromJson(r)).toList();
        print(toko);
        ResponseDataList response = ResponseDataList(
          status: true,
          message: 'success load data',
          data: toko,
        );
        return response;
      } else {
        ResponseDataList response = ResponseDataList(
          status: false,
          message: 'Failed load data',
        );
        return response;
      }
    } else {
      ResponseDataList response = ResponseDataList(
        status: false,
        message: "gagal load toko dengan code error ${getToko.statusCode}",
      );
      return response;
    }
  }

  Future insertToko(request, image, id) async {
    UserLogin userLogin = UserLogin();
      var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
          status: false, message: 'anda belum login / token invalid');
      return response;
    }
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
      "Content-type": "multipart/form-data",
    };
    var reponse;
    if (id == null) {
      reponse = http.MultipartRequest(
        'POST',
        Uri.parse("${url.BaseUrl}/admin/insertbarang"),
      );
    } else {
      reponse = http.MultipartRequest(
        'POST',
        Uri.parse("${url.BaseUrl}/admin/updatebarang/$id"),
      );
    }
    if (image != null) {
      reponse.files.add(http.MultipartFile(
          'image', image.readAsBytes().asStream(), image.lengthSync(),
          filename: image.path.split('/').last));
    }
    reponse.headers.addAll(headers);
    reponse.fields['nama_barang'] = request["nama_barang"] ?? "";
    reponse.fields['deskripsi'] = request["deskripsi"] ?? "";
    if (request["image"] != null) {
      reponse.fields['image'] = request["image"].toString();
    }
    if (request["harga"] != null) {
      reponse.fields['harga'] = request["harga"].toString();
    }
    if (request["stok"] != null) {
      reponse.fields['stok'] = request["stok"].toString();
    }

    var res = await reponse.send();
    var result = await http.Response.fromStream(res);

    if (res.statusCode == 200) {
      var data = json.decode(result.body);
      if (data["status"] == true) {
        ResponseDataMap response = ResponseDataMap(
            status: true, message: 'success insert / update data');
        return response;
      } else {
        ResponseDataMap response = ResponseDataMap(
            status: false, message: 'Failed insert / update data');
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
          status: false,
          message: "gagal load movie dengan code error ${res.statusCode}");
      return response;
    }
  }

  Future hapusToko(context, id) async {
    UserLogin userLogin = UserLogin();
    var uri = Uri.parse(url.BaseUrl + "/admin/hapusbarang/$id");
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
          status: false, message: 'anda belum login / token invalid');
      return response;
    }
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
    };
    var hapusToko = await http.delete(uri, headers: headers);

    if (hapusToko.statusCode == 200) {
      var result = json.decode(hapusToko.body);
      if (result["status"] == true) {
        ResponseDataList response =
            ResponseDataList(status: true, message: 'success hapus data barang');
        return response;
      } else {
        ResponseDataList response =
            ResponseDataList(status: false, message: 'Failed hapus data barang');
        return response;
      }
    } else {
      ResponseDataList response = ResponseDataList(
          status: false,
          message:
              "gagal hapus movie dengan code error ${hapusToko.statusCode}");
      return response;
    }

  }

  Future getMovieUser() async { 
    UserLogin userLogin = UserLogin();
  var uri = Uri.parse(url.BaseUrl + "/user/getmovie"); 
  var user = await userLogin.getUserLogin(); 
  if (user.status == false) { 
    ResponseDataList response = ResponseDataList( 
      status: false, 
      message: 'anda belum login / token invalid', 
    ); 
    return response; 
  } 
  Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'}; 
  var getMovie = await http.get(uri, headers: headers); 
 
  if (getMovie.statusCode == 200) { 
    var data = json.decode(getMovie.body); 
    if (data["status"] == true) { 
      List movie = data["data"].map((r) => TokoModels.fromJson(r)).toList(); 
      ResponseDataList response = ResponseDataList( 
        status: true, 
        message: 'success load data', 
        data: movie, 
      ); 
      return response; 
    } else { 
      ResponseDataList response = ResponseDataList( 
        status: false, 
        message: 'Failed load data', 
      ); 
      return response; 
    } 
  } else { 
    ResponseDataList response = ResponseDataList( 
      status: false, 
      message: "gagal load movie dengan code error ${getMovie.statusCode}", 
    ); 
    return response; 
  } 
} 

}


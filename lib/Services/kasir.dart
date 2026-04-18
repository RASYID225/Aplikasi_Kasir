import 'dart:convert';
import 'package:aplikasi_kasir/Models/response_data_list.dart';
import 'package:aplikasi_kasir/Models/Toko_Models.dart';
import 'package:aplikasi_kasir/Models/response_data_map.dart';
import 'package:aplikasi_kasir/models/user_login.dart';
import 'package:aplikasi_kasir/services/url.dart' as url;
import 'package:http/http.dart' as http;

class TokoService {
  Future getKasir() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
        status: false,
        message: 'anda belum login / token invalid',
      );
      return response;
    }
    var uri = Uri.parse(url.BaseUrl + "/admin/getmovie");
    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};
    var getKasir = await http.get(uri, headers: headers);

    if (getKasir.statusCode == 200) {
      var data = json.decode(getKasir.body);
      if (data["status"] == true) {
        List kasir = data["data"].map((r) => TokoModels.fromJson(r)).toList();
        ResponseDataList response = ResponseDataList(
          status: true,
          message: 'success load data',
          data: kasir,
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
        message: "gagal load movie dengan code error ${getKasir.statusCode}",
      );
      return response;
    }
    Future insertKasir(request, image, id) async {
      var user = await userLogin.getUserLogin();

      if (user.status == false) {
        ResponseDataList response = ResponseDataList(
          status: false,
          message: 'anda belum login / token invalid',
        );
        return response;
      }
      Map<String, String> headers = {
        "Authorization": 'Bearer ${user.token}',
        "Content-type": "multipart/form-data",
      };
      var response;

      if (id == null) {
        response = http.MultipartRequest(
          'POST',
          Uri.parse("${url.BaseUrl}/admin/insertkasir"),
        );
      } else {
        response = http.MultipartRequest(
          'POST',
          Uri.parse("${url.BaseUrl}/admin/updatekasir/$id"),
        );
      }
      if (image != null) {
        response.files.add(
          http.MultipartFile(
            'posterpath',
            image.readAsBytes().asStream(),
            image.lengthSync(),
            filename: image.path.split('/').last,
          ),
        );
      }
      response.headers.addAll(headers);
      response.fields['title'] = request["title"];
      response.fields['voteaverage'] = request["voteaverage"];
      response.fields['overview'] = request["overview"];

      var res = await response.send();
      var result = await http.Response.fromStream(res);
      if (res.statusCode == 200) {
        var data = json.decode(result.body);
        if (data["status"] == true) {
          ResponseDataMap response = ResponseDataMap(
            status: true,
            message: 'success insert / update data',
          );
          return response;
        } else {
          ResponseDataMap response = ResponseDataMap(
            status: false,
            message: 'Failed insert / update data',
          );
          return response;
        }
      } else {
        ResponseDataMap response = ResponseDataMap(
          status: false,
          message: "gagal load kasir dengan code error ${res.statusCode}",
        );
        return response;
      }
    }

    Future hapusKasir(context, id) async {
      var uri = Uri.parse(url.BaseUrl + "/admin/hapuskasir/$id");
      var user = await userLogin.getUserLogin();
      if (user.status == false) {
        ResponseDataList response = ResponseDataList(
          status: false,
          message: 'anda belum login / token invalid',
        );
        return response;
      }
      Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};
      var hapusKasir = await http.delete(uri, headers: headers);

      if (hapusKasir.statusCode == 200) {
        var result = json.decode(hapusKasir.body);
        if (result["status"] == true) {
          ResponseDataList response = ResponseDataList(
            status: true,
            message: 'success hapus data',
          );
          return response;
        } else {
          ResponseDataList response = ResponseDataList(
            status: false,
            message: 'Failed hapus data',
          );
          return response;
        }
      } else {
        ResponseDataList response = ResponseDataList(
          status: false,
          message:
              "gagal hapus kasir dengan code error ${hapusKasir.statusCode}",
        );
        return response;
      }
    }
  }
}

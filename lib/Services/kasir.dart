import 'dart:convert';
import 'package:aplikasi_kasir/Models/response_data_list.dart';
import 'package:aplikasi_kasir/Models/Toko_Models.dart';
import 'package:aplikasi_kasir/Models/response_data_map.dart';
import 'package:aplikasi_kasir/models/user_login.dart';
import 'package:aplikasi_kasir/services/url.dart' as url;
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
}

import 'dart:convert'; 
import 'package:aplikasi_kasir/Models/response_data_list.dart';
import 'package:aplikasi_kasir/Models/Toko_Models.dart'; 
import 'package:aplikasi_kasir/Models/response_data_list.dart'; 
import 'package:aplikasi_kasir/models/user_login.dart'; 
import 'package:aplikasi_kasir/services/url.dart' as url; 
import 'package:http/http.dart' as http; 
 
class TokoService { 
  Future getKasir() async { 
    UserLogin userLogin = UserLogin(); 
    var user = await userLogin.getUserLogin(); 
    if (user.status == false) { 
      ResponseDataList response = ResponseDataList( 
          status: false, message: 'anda belum login / token invalid'); 
      return response; 
    } 
    var uri = Uri.parse(url.BaseUrl + "/admin/getmovie"); 
    Map<String, String> headers = { 
      "Authorization": 'Bearer ${user.token}', 
    }; 
    var getKasir = await http.get(uri, headers: headers); 
 
    if (getKasir.statusCode == 200) { 
      var data = json.decode(getKasir.body); 
      if (data["status"] == true) { 
        List kasir = data["data"].map((r) => TokoModels.fromJson(r)).toList(); 
        ResponseDataList response = ResponseDataList( 
            status: true, message: 'success load data', data: kasir); 
        return response; 
      } else { 
        ResponseDataList response = 
            ResponseDataList(status: false, message: 'Failed load data'); 
        return response; 
      } 
    } else { 
      ResponseDataList response = ResponseDataList( 
          status: false, 
          message: "gagal load movie dengan code error ${getKasir.statusCode}"); 
      return response; 
    } 
  } 
}
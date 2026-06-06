import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:aplikasi_kasir/Models/User_Login.dart'; 
import 'package:aplikasi_kasir/Services/Url.dart' as url; 
 
class BarangService { 
  UserLogin userLogin = UserLogin(); 
 
  // Fungsi untuk mengambil list barang dari API Postman
  Future<Map<String, dynamic>> fetchDaftarBarang() async { 
    var uri = Uri.parse(url.BaseUrl + "/user/getbarang"); 
    var user = await userLogin.getUserLogin(); 
    
    // Validasi token login
    if (user.status == false) { 
      return {
        "status": false,
        "message": "Anda belum login / token invalid"
      };
    } 

    // Header wajib menyertakan Authorization Bearer Token
    Map<String, String> headers = { 
      "Authorization": 'Bearer ${user.token}', 
      'Content-Type': "application/json", 
    }; 
 
    try { 
      var response = await http.get( 
        uri, 
        headers: headers, 
      ); 
      var data = json.decode(response.body); 
 
      if (response.statusCode == 200) { 
        return {
          "status": true,
          "data": data // Ini akan berisi list barang dari database backend kamu
        };
      } else { 
        return {
          "status": false,
          "message": "Gagal memuat data dengan kode error ${response.statusCode}"
        };
      } 
    } catch (e) { 
      print(e); 
      return {
        "status": false,
        "message": "Fatal error terjadi: $e"
      };
    } 
  } 
}
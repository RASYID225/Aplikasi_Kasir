import 'package:aplikasi_kasir/Models/Kasir_Model.dart';

class ResponseDataList { 
  bool status; 
  String message; 
  List? data; 
  ResponseDataList({required this.status, required this.message, this.data}); 
}
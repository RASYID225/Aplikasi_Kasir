import 'package:aplikasi_kasir/Services/url.dart' as url;

class KasirModel {
  int? id;
  String? title;
  double? voteAverage;
  String? overview;
  String? posterpath;
  KasirModel({
    required this.id,
    required this.title,
    this.voteAverage,
    this.overview,
    required this.posterpath,
  });
  KasirModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    title = parsedJson["title"];
    voteAverage = double.parse(parsedJson["voteaverage"].toString());
    overview = parsedJson["overview"];
    posterpath = "${url.BaseUrlTanpaApi}/${parsedJson["posterpath"]}";
  }
}

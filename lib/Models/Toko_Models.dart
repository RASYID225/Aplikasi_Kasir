import 'package:aplikasi_kasir/services/url.dart' as url;

class TokoModels {
  int? id;
  String? title;
  double? voteAverage;
  String? overview;
  String? posterPath;
  TokoModels({
    required this.id,
    required this.title,
    this.voteAverage,
    this.overview,
    required this.posterPath,
  });
  TokoModels.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    title = parsedJson["title"];
    voteAverage = double.parse(parsedJson["voteaverage"].toString());
    overview = parsedJson["overview"];
    posterPath = "${url.BaseUrlImage}/${parsedJson["posterpath"]}";
  }
}

class WisataResponse {
  WisataResponse({
    required this.error,
    required this.founded,
    required this.data,
  });

  bool error;
  int founded;
  List<Wisata> data;

  factory WisataResponse.fromJson(Map<String, dynamic> json) => WisataResponse(
        error: json["error"],
        founded: json["founded"],
        data: List<Wisata>.from(json["data"].map((x) => Wisata.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Wisata {
  Wisata({
    required this.id,
    required this.name,
    required this.description,
    required this.province,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.urlImage,
  });

  String id;
  String name;
  String description;
  String province;
  String category;
  String latitude;
  String longitude;
  String urlImage;

  factory Wisata.fromJson(Map<String, dynamic> json) => Wisata(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        province: json["province"],
        category: json["category"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        urlImage: json["url_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "province": province,
        "category": category,
        "latitude": latitude,
        "longitude": longitude,
        "url_image": urlImage,
      };
}

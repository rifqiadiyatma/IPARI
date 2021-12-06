import 'dart:convert';
import 'package:ipari/data/model/wisata.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl =
      'https://ipariwisata.000webhostapp.com/wisata/';

  Future<WisataResponse> getList({String query = ""}) async {
    final response = await http.get(Uri.parse(_baseUrl + 'search/' + query));
    if (response.statusCode == 200) {
      return WisataResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load list wisata');
    }
  }
}

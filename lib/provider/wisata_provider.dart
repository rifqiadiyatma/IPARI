import 'package:flutter/material.dart';
import 'package:ipari/data/api/api_service.dart';
import 'package:ipari/data/model/wisata.dart';
import 'package:ipari/utils/result_state.dart';

class WisataProvider extends ChangeNotifier {
  final ApiService apiService;

  WisataProvider({required this.apiService}) {
    _fetchDataWisata();
  }

  void search(String query) {
    _query = query;
    _fetchDataWisata();
  }

  late WisataResponse _wisataResponse;
  late ResultState _state;
  String _query = '';
  String _message = '';

  String get message => _message;
  WisataResponse get response => _wisataResponse;
  ResultState get state => _state;

  Future<dynamic> _fetchDataWisata() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final wisata = await apiService.getList(query: _query);
      if (wisata.data.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data Not Found';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _wisataResponse = wisata;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}

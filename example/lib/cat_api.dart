import 'dart:convert';

import 'package:http/http.dart';

import 'models/cat.dart';

class CatApi {
  final Client _http = Client();
  final String _url = 'https://api.thecatapi.com/v1';

  Future<Cat> getRandomCat() async {
    Response resp = await _http.get(Uri.parse('$_url/images/search'));
    return Cat.fromJson(jsonDecode(resp.body)[0] as Map<String, dynamic>);
  }
}
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class API {
  postRequest({
    required String route,
    required Map<String, String> data,
  }) async {
    String apiUrl = 'https://meari.aquaconsulting.it/api/';

    String url = apiUrl + route;
    try {
      return await http.post(Uri.parse(url),
          body: jsonEncode(data), headers: _setTokenHeaders());
    } catch (e) {
      return e;
    }
  }

  Future<String> getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '$token';
  }

  _setTokenHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer 1|Ii1AClo2zKCx0z8Qt3LYt6m9NYMe8ZCGl23nuAnT',
      };
}

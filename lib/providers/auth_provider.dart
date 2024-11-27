import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skypay/hostApi.dart';

class AuthProvider with ChangeNotifier {
  Future login(String nomorhp, String password) async {
    try {
      var body = {'phone_number': nomorhp, 'password': password};

      var response = await http
          .post(Uri.parse('$hostApi/api/v2/auth/customer/login'), body: body);

      var data = [];

      if (response.statusCode == 200) {
        data = [response.statusCode, 'success', jsonDecode(response.body)];
        return data;
      } else {
        data = [response.statusCode, response.reasonPhrase, null];
        return data;
      }
    } catch (e) {
      var data = [505, 'Internal Server Error', null];
      return data;
    }
  }

  Future logout(String accessToken) async {
    try {
      var response = await http.post(
          Uri.parse('$hostApi/api/v2/auth/customer/logout'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

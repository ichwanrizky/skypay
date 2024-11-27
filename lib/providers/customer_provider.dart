import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;
import 'package:skypay/hostApi.dart';
import 'package:skypay/models/user_model.dart';
import 'package:skypay/pages/splash_page.dart';

class CustomerProvider with ChangeNotifier {
  Future<UserModel> customerMe(String accessToken, BuildContext context) async {
    try {
      var response = await http.post(Uri.parse('$hostApi/api/v2/customer/me'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body)['data']);
      } else if (response.statusCode == 401) {
        // ignore: use_build_context_synchronously
        redirectToLoginPage(context);
        throw Exception('Unauthorized. Status code: ${response.statusCode}');
      } else {
        throw Exception(
            'Failed to fetch customer data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch customer data: $e');
    }
  }

  void redirectToLoginPage(BuildContext context) {
    // You can use Navigator to navigate to your login page
    GetStorage box = GetStorage('skypay');
    box.remove('token');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashPage()),
    );
  }
}

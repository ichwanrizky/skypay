import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skypay/hostApi.dart';

class AccountProvider with ChangeNotifier {
  Future changePassword(String accessToken, String oldPassword,
      String newPassword, String confirmNewPassword) async {
    try {
      var body = {
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_new_password': confirmNewPassword,
      };

      var response = await http.post(
          Uri.parse('$hostApi/api/v2/customer/change-password'),
          headers: {'Authorization': 'Bearer $accessToken'},
          body: body);

      if (response.statusCode == 200) {
        return [
          jsonDecode(response.body)['success'],
          jsonDecode(response.body)['message']
        ];
      } else {
        return [false, jsonDecode(response.body)['message']!];
      }
    } catch (e) {
      return [false, e.toString()];
    }
  }

  Future changePhoneNumber(String accessToken, String phoneNumber) async {
    try {
      var body = {
        'new_phone_number': phoneNumber,
      };

      var response = await http.post(
          Uri.parse('$hostApi/api/v2/customer/change-phone-number'),
          headers: {'Authorization': 'Bearer $accessToken'},
          body: body);

      if (response.statusCode == 200) {
        return [
          jsonDecode(response.body)['success'],
          jsonDecode(response.body)['message']
        ];
      } else {
        return [false, 'status code: ${response.statusCode}'];
      }
    } catch (e) {
      return [false, e.toString()];
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skypay/hostApi.dart';
import 'package:http/http.dart' as http;
import 'package:skypay/models/perangkat_model.dart';

class PerangkatProvider with ChangeNotifier {
  Future<PerangkatModel> getPerangkatModem(
      String accessToken, String id) async {
    try {
      var response = await http.get(
          Uri.parse(
              '$hostApi/api/v2/customer/subscriptions/$id/get-modem-assoc-devices'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);

        PerangkatModel perangkatData = PerangkatModel.fromJson(
            decodedJson['data'] as Map<String, dynamic>);

        return perangkatData;
      } else {
        throw Exception(
            'Faild to fetch data perangkat. status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Faild to fetch data perangkat: $e');
    }
  }

  Future changeSsid(String accessToken, String serviceId, String deviceId,
      String ssidId, String ssid, String password) async {
    try {
      var body = {
        'service_id': serviceId,
        'device_id': deviceId,
        'ssid_id': ssidId,
        'ssid': ssid,
        'password': password,
      };

      var response = await http.post(
          Uri.parse('$hostApi/api/v2/customer/change-ssid-password'),
          headers: {'Authorization': 'Bearer $accessToken'},
          body: body);

      if (response.statusCode == 200) {
        return [true, jsonDecode(response.body)['message']];
      } else {
        return [false, jsonDecode(response.body)['message']!];
      }
    } catch (e) {
      return [false, e.toString()];
    }
  }
}

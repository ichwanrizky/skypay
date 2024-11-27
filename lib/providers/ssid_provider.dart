import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skypay/hostApi.dart';
import 'package:http/http.dart' as http;
import 'package:skypay/models/ssid_model.dart';

class SsidProvider with ChangeNotifier {
  Future<List<SsidModel>> getListSsid(String accessToken, String id) async {
    try {
      var response = await http.get(
          Uri.parse(
              '$hostApi/api/v2/customer/subscriptions/$id/get-modem-ssid'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        // return AnnouncementModel.fromJson(jsonDecode(response.body)['data'][0]);
        List<SsidModel> ssidData = [];
        List parsedJson = jsonDecode(response.body)['data'];

        // ignore: avoid_function_literals_in_foreach_calls
        parsedJson.forEach((element) {
          ssidData.add(SsidModel.fromJson(element));
        });

        return ssidData;
      } else {
        throw Exception(
            'Faild to fetch data list SSID. status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Faild to fetch data list SSID: $e');
    }
  }
}

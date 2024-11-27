import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skypay/hostApi.dart';
import 'package:skypay/models/modem_model.dart';
import 'package:http/http.dart' as http;

class ModemProvider with ChangeNotifier {
  Future<List<ModemModel>> getStatusModem(String accessToken) async {
    try {
      var response = await http.get(
          Uri.parse('$hostApi/api/v2/customer/subscriptions/get-modem-status'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        // return AnnouncementModel.fromJson(jsonDecode(response.body)['data'][0]);
        List<ModemModel> announcementData = [];
        List parsedJson = jsonDecode(response.body)['data'];

        // ignore: avoid_function_literals_in_foreach_calls
        parsedJson.forEach((element) {
          announcementData.add(ModemModel.fromJson(element));
        });

        return announcementData;
      } else {
        throw Exception(
            'Faild to fetch data status modem. status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Faild to fetch data status modem: $e');
    }
  }
}

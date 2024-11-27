import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skypay/hostApi.dart';
import 'package:skypay/models/announcement_model.dart';
import 'package:http/http.dart' as http;

class AnnouncemenProvider with ChangeNotifier {
  Future<List<AnnouncementModel>> getAnnouncement(String accessToken) async {
    try {
      var response = await http.post(
          Uri.parse('$hostApi/api/v2/customer/announcements'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        // return AnnouncementModel.fromJson(jsonDecode(response.body)['data'][0]);
        List<AnnouncementModel> announcementData = [];
        List parsedJson = jsonDecode(response.body)['data'];

        // ignore: avoid_function_literals_in_foreach_calls
        parsedJson.forEach((element) {
          announcementData.add(AnnouncementModel.fromJson(element));
        });

        return announcementData;
      } else {
        throw Exception(
            'Faild to fetch data announcement. status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Faild to fetch data announcement: $e');
    }
  }
}

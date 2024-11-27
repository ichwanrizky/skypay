import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skypay/hostApi.dart';
import 'package:skypay/models/instruction_model.dart';
import 'package:skypay/models/invoice_model.dart';
import 'package:http/http.dart' as http;
import 'package:skypay/models/payment_model.dart';
import 'package:skypay/pages/splash_page.dart';

class InvoiceProvider with ChangeNotifier {
  Future<List<InvoiceModel>> getInvoiceThisMonth(String accessToken) async {
    try {
      var body = {'order': 'desc', 'period': 'this_month'};

      var response = await http.post(
          Uri.parse('$hostApi/api/v2/customer/invoices'),
          body: body,
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        List<InvoiceModel> invoiceData = [];
        List parsedJson = jsonDecode(response.body)['data']['data'];

        parsedJson.forEach((element) {
          invoiceData.add(InvoiceModel.fromJson(element));
        });

        return invoiceData;
      } else {
        throw Exception(
            'Failed to fetch invoice data. status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch invoice data: $e');
    }
  }

  Future<List<InvoiceModel>> getAllInvoice(
      String accessToken, BuildContext context) async {
    try {
      var body = {'status': 'paid', 'order': 'desc'};
      var response = await http.post(
          Uri.parse('$hostApi/api/v2/customer/invoices'),
          body: body,
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        List<InvoiceModel> invoiceData = [];
        List parsedJson = jsonDecode(response.body)['data']['data'];

        // ignore: avoid_function_literals_in_foreach_calls
        parsedJson.forEach((element) {
          invoiceData.add(InvoiceModel.fromJson(element));
        });
        return invoiceData;
      } else if (response.statusCode == 401) {
        // ignore: use_build_context_synchronously
        redirectToLoginPage(context);
        throw Exception('Unauthorized. Status code: ${response.statusCode}');
      } else {
        throw Exception(
            'Failed to fetch invoice data. status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch invoice data: $e');
    }
  }

  Future<InvoiceModel> getInvoiceById(
      String accessToken, String id, BuildContext context) async {
    try {
      var response = await http.post(
          Uri.parse('$hostApi/api/v2/customer/invoices/$id'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        return InvoiceModel.fromJson(jsonDecode(response.body)['data']);
      } else if (response.statusCode == 401) {
        // ignore: use_build_context_synchronously
        redirectToLoginPage(context);
        throw Exception('Unauthorized. Status code: ${response.statusCode}');
      } else {
        throw Exception(
            'Failed to fetch invoice data. status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch invoice data: $e');
    }
  }

  Future<List<PaymentModel>> getPaymentMethods(
      String accessToken, String subscriptionId) async {
    try {
      var body = {'subscription_id': subscriptionId};

      var response = await http.post(
          Uri.parse('$hostApi/api/v2/customer/payment-methods'),
          body: body,
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        List<PaymentModel> paymentMethodData = [];
        List parsedJson = jsonDecode(response.body)['data'];

        // ignore: avoid_function_literals_in_foreach_calls
        parsedJson.forEach((element) {
          paymentMethodData.add(PaymentModel.fromJson(element));
        });
        return paymentMethodData;
      } else {
        throw Exception(
            'Failed fetch data payment method. status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed fetch data payment method: $e');
    }
  }

  Future<List<InstructionModel>> getInstructionPayment(
      String pgCode, String subscriptionId, String accessToken) async {
    try {
      var body = {'subscription_id': subscriptionId};

      var response = await http.post(
          Uri.parse('$hostApi/api/v2/customer/payment-methods/$pgCode'),
          body: body,
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        List<InstructionModel> instructionData = [];
        List parsedJson =
            jsonDecode(response.body)['data']["paymentDetails"]["instructions"];

        // ignore: avoid_function_literals_in_foreach_calls
        parsedJson.forEach((element) {
          instructionData.add(InstructionModel.fromJson(element));
        });
        return instructionData;
      } else {
        throw Exception(
            'Failed fetch instruction payment method. status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed fetch instruction payment method: $e');
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

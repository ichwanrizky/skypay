import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:skypay/pages/login_page.dart';
import 'package:skypay/pages/main/account/password.dart';
import 'package:skypay/pages/main/account/phone_number.dart';
import 'package:skypay/pages/main/connection/detail_connection.dart';
import 'package:skypay/pages/main/connection/device_connected.dart';
import 'package:skypay/pages/main/connection/update_ssid.dart';
import 'package:skypay/pages/main/payment/detail_payment.dart';
import 'package:skypay/pages/main/payment/payment.dart';
import 'package:skypay/pages/main/riwayat/detail_riwayat.dart';
import 'package:skypay/pages/main_page.dart';
import 'package:skypay/pages/splash_page.dart';
import 'package:skypay/providers/account_provider.dart';
import 'package:skypay/providers/announcement_provider.dart';
import 'package:skypay/providers/auth_provider.dart';
import 'package:skypay/providers/customer_provider.dart';
import 'package:skypay/providers/invoice_provider.dart';
import 'package:skypay/providers/modem_provider.dart';
import 'package:skypay/providers/perangkat_provider.dart';
import 'package:skypay/providers/ssid_provider.dart';

void main() async {
  await GetStorage.init('skypay');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
        ChangeNotifierProvider(create: (context) => InvoiceProvider()),
        ChangeNotifierProvider(create: (context) => AnnouncemenProvider()),
        ChangeNotifierProvider(create: (context) => AccountProvider()),
        ChangeNotifierProvider(create: (context) => ModemProvider()),
        ChangeNotifierProvider(create: (context) => PerangkatProvider()),
        ChangeNotifierProvider(create: (context) => SsidProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/main': (context) => const MainPage(),
          '/changePhonenumber': (context) => const ChangePhoneNumber(),
          '/changePassword': (context) => const ChangePassword(),
          '/detailRiwayat': (context) => const DetailRiwayat(),
          '/payment': (context) => const Payment(),
          '/payment-detail': (context) => const DetailPayment(),
          '/connection-detail': (context) => const DetailConnection(),
          '/device-connected': (context) => const DeviceConneted(),
          '/update-ssid': (context) => const UpdateSsid(),
        },
      ),
    );
  }
}

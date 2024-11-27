// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:skypay/pages/main/account_page.dart';
import 'package:skypay/pages/main/bantuan_page.dart';
import 'package:skypay/pages/main/connection_page.dart';
import 'package:skypay/pages/main/home_page.dart';
import 'package:skypay/pages/main/riwayat_page.dart';
import 'package:skypay/providers/auth_provider.dart';
import 'package:skypay/theme.dart';

enum ListMenu { menu1, menu2, menu3, menu4, menu5, menu6 }

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ListMenu? selectedMenu = ListMenu.menu1;
  GetStorage box = GetStorage('skypay');

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    Widget page() {
      switch (selectedMenu) {
        case ListMenu.menu1:
          return HomePage();
        case ListMenu.menu2:
          return AccountPage();
        case ListMenu.menu3:
          return RiwayatPage();
        case ListMenu.menu4:
          return BantuanPage();
        case ListMenu.menu5:
          return ConnectionPage();
        default:
          return HomePage();
      }
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              'assets/img/skypaymentlogo.png',
              width: 160,
              fit: BoxFit.contain,
            ),
            Expanded(child: Text('')),
            PopupMenuButton<ListMenu>(
                icon: Image.asset(
                  'assets/icon/menu.png',
                  width: 24,
                  fit: BoxFit.contain,
                ),
                initialValue: selectedMenu,
                onSelected: (ListMenu item) {
                  if (item == ListMenu.menu6) {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Logout'),
                          content: const Text(
                            'Logout dari aplikasi SkyPay ?',
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                  textStyle: textStyle3,
                                  foregroundColor: textColor2),
                              child: const Text(
                                'Cancel',
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: textStyle1.copyWith(
                                    fontWeight: FontWeight.w700),
                                foregroundColor: primaryColor,
                              ),
                              child: const Text('Logout'),
                              onPressed: () async {
                                authProvider.logout(box.read('token'));
                                box.remove('token');
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/', (route) => false);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    setState(() {
                      selectedMenu = item;
                    });
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<ListMenu>>[
                      const PopupMenuItem<ListMenu>(
                        value: ListMenu.menu1,
                        child: Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const PopupMenuItem<ListMenu>(
                        value: ListMenu.menu2,
                        child: Text(
                          'Akun',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const PopupMenuItem<ListMenu>(
                        value: ListMenu.menu3,
                        child: Text(
                          'Riwayat',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const PopupMenuItem<ListMenu>(
                        value: ListMenu.menu4,
                        child: Text(
                          'Bantuan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const PopupMenuItem<ListMenu>(
                        value: ListMenu.menu5,
                        child: Text(
                          'Koneksi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const PopupMenuItem<ListMenu>(
                        value: ListMenu.menu6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              thickness: 3,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Keluar',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ])
          ],
        ),
      ),
      body: page(),
    );
  }
}

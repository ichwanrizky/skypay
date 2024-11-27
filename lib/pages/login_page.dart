// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:skypay/providers/auth_provider.dart';
import 'package:skypay/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = false;
  bool isLoading = false;

  TextEditingController nomorhpController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  GetStorage box = GetStorage('skypay');
  @override
  void initState() {
    super.initState();
    if (box.read('token') != null) {
      // ignore: curly_braces_in_flow_control_structures
      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    void showError(String message, color) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: color,
      ));
    }

    Widget usernameInput() {
      return Container(
        margin: EdgeInsets.only(top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nomor HP',
              style: textStyle2.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: textColor2)),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: nomorhpController,
                    decoration: InputDecoration.collapsed(
                        hintText: 'masukan nomor hp anda',
                        hintStyle: textStyle3.copyWith(fontSize: 10)),
                  ),
                ))
          ],
        ),
      );
    }

    Widget passwordInput() {
      return Container(
        margin: EdgeInsets.only(top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style: textStyle2.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: textColor2)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: showPassword ? false : true,
                      decoration: InputDecoration.collapsed(
                          hintText: 'masukan password anda',
                          hintStyle: textStyle3.copyWith(fontSize: 10)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      showPassword = showPassword ? false : true;
                    }),
                    child: Image.asset(
                      'assets/icon/show_password.png',
                      width: 18,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    Widget buttonLogin() {
      return Column(
        children: [
          GestureDetector(
            onTap: () async {
              if (!isLoading) {
                setState(() {
                  isLoading = true;
                });

                if (nomorhpController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  showError(
                      'Nomor Hp atau Password Tidak Boleh Kosong', dangerColor);
                } else {
                  var response = await authProvider.login(
                      nomorhpController.text, passwordController.text);

                  if (response[0] == 200) {
                    if (response[2]['success']) {
                      showError(response[2]['message'], successColor);
                      box.write('token', response[2]['data']['access_token']);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/main', (route) => false);
                    } else {
                      showError(response[2]['message'], dangerColor);
                    }
                  } else {
                    showError(response[1], dangerColor);
                  }
                }

                setState(() {
                  isLoading = false;
                });
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 25),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Loading',
                            style: textStyle2.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        ],
                      )
                    : Text(
                        'Login',
                        style: textStyle2.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tidak bisa login? ',
                style: textStyle3,
              ),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(
                      "https://api.whatsapp.com/send/?phone=6281364420961&text&type=phone_number&app_absent=0");

                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch ${url.toString()}');
                  }
                },
                child: Text(
                  'Klik di sini',
                  style: textStyle1.copyWith(fontWeight: FontWeight.w700),
                ),
              )
            ],
          )
        ],
      );
    }

    return Scaffold(
        backgroundColor: bgColor,
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Container(),
                Expanded(
                    child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 35,
                        child: Image.asset(
                          'assets/img/skypaymentlogo.png',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: textColor2,
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: Offset(0, 3),
                              )
                            ]),
                        padding: EdgeInsets.all(20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Masuk Sky Payment',
                                style: textStyle1.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              usernameInput(),
                              passwordInput(),
                              buttonLogin()
                            ]),
                      )
                    ],
                  ),
                ))
              ],
            )));
  }
}

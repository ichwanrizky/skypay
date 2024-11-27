// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:skypay/providers/account_provider.dart';
import 'package:skypay/theme.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController password3Controller = TextEditingController();
  bool isLoading = false;
  GetStorage box = GetStorage('skypay');

  @override
  Widget build(BuildContext context) {
    var accountProvider = Provider.of<AccountProvider>(context);

    void showError(String message, color) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: color,
      ));
    }

    Widget formPassword1() {
      return Container(
        margin: EdgeInsets.only(top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password Lama',
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
                      controller: password1Controller,
                      obscureText: true,
                      decoration: InputDecoration.collapsed(
                          hintText: 'masukan password lama anda',
                          hintStyle: textStyle3.copyWith(fontSize: 10)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {}),
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

    Widget formPassword2() {
      return Container(
        margin: EdgeInsets.only(top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password Baru',
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
                      obscureText: true,
                      controller: password2Controller,
                      decoration: InputDecoration.collapsed(
                          hintText: 'masukan password baru anda',
                          hintStyle: textStyle3.copyWith(fontSize: 10)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {}),
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

    Widget formPassword3() {
      return Container(
        margin: EdgeInsets.only(top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ulangi Password Baru',
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
                      obscureText: true,
                      controller: password3Controller,
                      decoration: InputDecoration.collapsed(
                          hintText: 'ulangi password baru anda',
                          hintStyle: textStyle3.copyWith(fontSize: 10)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {}),
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

    Widget buttonSubmit() {
      return Column(
        children: [
          GestureDetector(
            onTap: () async {
              if (!isLoading) {
                setState(() {
                  isLoading = true;
                });

                if (password1Controller.text.isEmpty ||
                    password2Controller.text.isEmpty ||
                    password3Controller.text.isEmpty) {
                  showError('Password Tidak Boleh Kosong', dangerColor);
                } else {
                  var response = await accountProvider.changePassword(
                      box.read('token'),
                      password1Controller.text,
                      password2Controller.text,
                      password3Controller.text);

                  if (!response[0]) {
                    showError(response[1], dangerColor);
                  } else {
                    showError(response[1], successColor);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
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
                        'Simpan Password',
                        style: textStyle2.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Image.asset(
          'assets/img/logo.png',
          width: 121,
          fit: BoxFit.contain,
        ),
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ubah Password',
                  style: textStyle2.copyWith(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                formPassword1(),
                formPassword2(),
                formPassword3(),
                buttonSubmit(),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

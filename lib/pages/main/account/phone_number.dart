// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:skypay/providers/account_provider.dart';
import 'package:skypay/theme.dart';

class ChangePhoneNumber extends StatefulWidget {
  const ChangePhoneNumber({super.key});

  @override
  State<ChangePhoneNumber> createState() => _ChangePhoneNumberState();
}

class _ChangePhoneNumberState extends State<ChangePhoneNumber> {
  TextEditingController phoneNumber = TextEditingController(text: '');
  GetStorage box = GetStorage('skypay');
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    void showError(String message, color) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: color,
      ));
    }

    var accountProvider = Provider.of<AccountProvider>(context);

    Widget formInput() {
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
                    controller: phoneNumber,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration.collapsed(
                        hintText: 'masukan nomor hp anda',
                        hintStyle: textStyle3.copyWith(fontSize: 10)),
                  ),
                ))
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

                if (phoneNumber.text.isEmpty) {
                  showError('Nomor Hp Tidak Boleh Kosong', dangerColor);
                } else {
                  var response = await accountProvider.changePhoneNumber(
                      box.read("token"), phoneNumber.text);

                  if (response[0] == false) {
                    showError(response[1], dangerColor);
                  } else {
                    showError(response[1], successColor);
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
                        'Simpan Nomor HP',
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
                  'Ubah Nomor HP',
                  style: textStyle2.copyWith(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                formInput(),
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

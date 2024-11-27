// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skypay/theme.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage('skypay');

    Widget button1() {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/changePhonenumber'),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ubah Nomor HP',
                    style: textStyle1.copyWith(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
                Icon(Icons.arrow_right)
              ],
            ),
            Divider(
              thickness: 1,
            )
          ],
        ),
      );
    }

    Widget button2() {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/changePassword'),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ubah Password',
                    style: textStyle1.copyWith(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
                Icon(Icons.arrow_right)
              ],
            ),
            Divider(
              thickness: 1,
            )
          ],
        ),
      );
    }

    Widget card() {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      color: primaryColor, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      box.read('nama_pelanggan').substring(0, 2).toUpperCase(),
                      style: textStyle1.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        box.read('nama_pelanggan'),
                        style: textStyle2.copyWith(
                            fontSize: 18, fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        box.read('nomor_pelanggan'),
                        style: textStyle3.copyWith(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                // button1(),
                // SizedBox(
                //   height: 10,
                // ),
                button2()
              ],
            )
          ],
        ),
      );
    }

    return ListView(
      children: [card()],
    );
  }
}

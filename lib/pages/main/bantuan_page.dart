// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:skypay/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kantor Pusat',
                style: textStyle2.copyWith(
                    fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Batam',
                style: textStyle2.copyWith(
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Perumahan bambu kuning c12 no 18 \nKec.Batu Aji, Kel. Bukit Tempayan \nBatam 29438 ',
                style: textStyle2,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Pusat Bantuan',
                style: textStyle2.copyWith(
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 5,
              ),
              GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(
                        "https://api.whatsapp.com/send/?phone=6281364420961&text&type=phone_number&app_absent=0");

                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch ${url.toString()}');
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.call,
                        color: primaryColor,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '+62 813 6442 0961',
                        style: textStyle2.copyWith(
                            color: primaryColor, fontWeight: FontWeight.w700),
                      ),
                    ],
                  )),
              SizedBox(
                height: 5,
              ),
              Text(
                'Senin - Sabtu 09.00-18.00',
                style: textStyle2,
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  'Hubungi Kami',
                  style: textStyle2.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: primaryColor),
                ),
              ),
              Center(
                child: Text(
                  'Tim Support Kami Siap Membantu Anda',
                  style: textStyle2.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: primaryColor),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

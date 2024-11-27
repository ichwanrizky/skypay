// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skypay/models/perangkat_model.dart';
import 'package:skypay/models/ssid_model.dart';
import 'package:skypay/providers/perangkat_provider.dart';
import 'package:skypay/providers/ssid_provider.dart';
import 'package:skypay/theme.dart';

class DetailConnection extends StatefulWidget {
  const DetailConnection({super.key});

  @override
  State<DetailConnection> createState() => _DetailConnectionState();
}

class _DetailConnectionState extends State<DetailConnection> {
  GetStorage box = GetStorage('skypay');

  @override
  Widget build(BuildContext context) {
    var perangkatProvider = Provider.of<PerangkatProvider>(context);
    var ssidProvider = Provider.of<SsidProvider>(context);

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    Widget section1() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ID Pelanggan',
            style:
                textStyle2.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: textColor2),
                borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(arguments['serviceId'].toString(),
                      style: textStyle2.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: arguments['status'].toString() == 'Online'
                          ? successColor
                          : dangerColor,
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: Center(
                    child: Text(arguments['status'].toString(),
                        style: textStyle1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }

    Widget section2({
      List<SsidModel>? listSsid,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Perangkat',
            style:
                textStyle2.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: textColor2),
                  borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: listSsid != null && listSsid.isNotEmpty
                        ? listSsid
                            .asMap()
                            .map((index, item) => MapEntry(
                                index,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Nama SSID ${index + 1} : ',
                                                style: textStyle2.copyWith(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                item.ssid.toString(),
                                                style: textStyle2.copyWith(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/update-ssid',
                                                arguments: {
                                                  'deviceId':
                                                      arguments['deviceId'],
                                                  'serviceId':
                                                      arguments['serviceId'],
                                                  'ssidId': item.id,
                                                  'ssidName': item.ssid
                                                }).then((_) {
                                              setState(() {});
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                size: 15,
                                                color: primaryColor,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Edit',
                                                style: textStyle1.copyWith(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                )))
                            .values
                            .toList()
                        : [],
                  ),
                ],
              )),
        ],
      );
    }

    Widget section3({
      int? totalWifi,
      int? totalLan,
      List<AssociatedDevice>? deviceConnected,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perangkat Terhubung',
            style:
                textStyle2.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: textColor2),
                  borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('WIFI',
                              style: textStyle2.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                        ),
                        Text(
                          totalWifi.toString(),
                          style: textStyle2.copyWith(
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Wired/LAN',
                              style: textStyle2.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                        ),
                        Text(
                          totalLan.toString(),
                          style: textStyle2.copyWith(
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/device-connected', arguments: {
                'device_connected': deviceConnected,
              });
            },
            child: Text('Lihat Detail',
                style: textStyle1.copyWith(
                    fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ],
      );
    }

    Widget listLoading() {
      return Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: const Color.fromARGB(255, 210, 210, 210),
          child: Container(
            margin: EdgeInsets.only(top: 20),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors
                      .transparent, // Make the shadow transparent during shimmer
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ));
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
      body: Center(
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  section1(),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  FutureBuilder<List<SsidModel>>(
                      future: ssidProvider.getListSsid(
                          box.read('token'), arguments['id'].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return section2(listSsid: snapshot.data);
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Informasi Perangkat',
                                  style: textStyle2.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: textColor2),
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                    'Tidak Ada Perangkat Terhubung',
                                                    style: textStyle3.copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
                            );
                          }
                        }
                        return listLoading();
                      }),
                  Divider(),
                  SizedBox(height: 20),
                  FutureBuilder<PerangkatModel>(
                      future: perangkatProvider.getPerangkatModem(
                          box.read('token'), arguments['id'].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData &&
                              (snapshot.data!.totalAssociations! > 0 ||
                                  snapshot.data!.totalLan! > 0)) {
                            return section3(
                              totalWifi: snapshot.data?.totalAssociations,
                              totalLan: snapshot.data?.totalLan,
                              deviceConnected: snapshot.data?.associatedDevices,
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Perangkat Terhubung',
                                  style: textStyle2.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: textColor2),
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                    'Tidak Ada Perangkat Terhubung',
                                                    style: textStyle3.copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
                            );
                          }
                        }

                        return listLoading();
                      }),
                  SizedBox(height: 50),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

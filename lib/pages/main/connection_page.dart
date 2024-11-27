// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skypay/models/modem_model.dart';
import 'package:skypay/providers/modem_provider.dart';
import 'package:skypay/theme.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  GetStorage box = GetStorage('skypay');

  @override
  Widget build(BuildContext context) {
    var modemProvider = Provider.of<ModemProvider>(context);

    Widget ListConnection(
        {int? id, String? serviceId, String? status, String? deviceId}) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/connection-detail', arguments: {
            'id': id,
            'serviceId': serviceId,
            'status': status,
            'deviceId': deviceId
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID Pelanggan: ',
                          style: textStyle3.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '$serviceId',
                          style: textStyle2.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color:
                                status == 'Online' ? successColor : dangerColor,
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                        child: Center(
                          child: Text('$status',
                              style: textStyle1.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                      Icon(
                        Icons.arrow_right,
                        color: primaryColor,
                        size: 30,
                      )
                    ],
                  )
                ],
              ),
              const Divider(
                thickness: 1,
                color: Colors.black45,
              )
            ],
          ),
        ),
      );
    }

    Widget ListLoading() {
      return Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: const Color.fromARGB(255, 210, 210, 210),
          child: Container(
            margin: const EdgeInsets.only(top: 20),
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

    return ListView(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Koneksi',
                style: textStyle2.copyWith(
                    fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<List<ModemModel>>(
                  future: modemProvider.getStatusModem(box.read('token')),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return Column(
                            children: snapshot.data!
                                .map((item) => ListConnection(
                                    id: item.id,
                                    serviceId: item.serviceId,
                                    status: item.status,
                                    deviceId: item.deviceId))
                                .toList());
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Tidak ada koneksi yang tersedia',
                                style: textStyle3.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        );
                      }
                    }

                    return Column(
                      children: [
                        ListLoading(),
                        ListLoading(),
                        ListLoading(),
                        ListLoading(),
                        ListLoading(),
                        ListLoading(),
                        ListLoading(),
                        ListLoading(),
                        ListLoading(),
                      ],
                    );
                  })
            ],
          ),
        )
      ],
    );
  }
}

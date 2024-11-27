// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skypay/models/invoice_model.dart';
import 'package:skypay/providers/invoice_provider.dart';
import 'package:skypay/theme.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  GetStorage box = GetStorage('skypay');

  @override
  Widget build(BuildContext context) {
    var invoiceProvider = Provider.of<InvoiceProvider>(context);

    Widget listTagihan(
        {int? id,
        int? price,
        String? invoiceDate,
        String? subscriptionId,
        String? serviceId}) {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/detailRiwayat',
            arguments: {'id': id}),
        child: Container(
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(color: Colors.transparent),
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
                          // ignore: unnecessary_string_interpolations
                          '${DateFormat('MMMM yyyy').format(DateTime.parse(invoiceDate.toString()))}',
                          style: textStyle3.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          'Rp. ${NumberFormat('#,###').format(price)}',
                          style: textStyle2.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'ID Langganan: ${serviceId}',
                          style: textStyle2.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              color: textColor2),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_right,
                    color: primaryColor,
                    size: 30,
                  )
                ],
              ),
              Divider(
                thickness: 1,
                color: Colors.black45,
              )
            ],
          ),
        ),
      );
    }

    Widget listTagihanLoading() {
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

    return ListView(
      children: [
        Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.all(24),
            child: FutureBuilder<List<InvoiceModel>>(
              future: invoiceProvider.getAllInvoice(box.read('token'), context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Column(
                      children: snapshot.data!
                          .map((invoiceData) => listTagihan(
                              id: invoiceData.id,
                              price: invoiceData.price,
                              invoiceDate: invoiceData.invoiceDate,
                              subscriptionId:
                                  invoiceData.subscriptionId.toString(),
                              serviceId: invoiceData.subscription.serviceId))
                          .toList(),
                    );
                  } else {
                    return Center(
                      child: Text('Tidak Ada Tagihan Yang Tersedia',
                          style: textStyle3.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    );
                  }
                }
                return Column(
                  children: [
                    listTagihanLoading(),
                    listTagihanLoading(),
                    listTagihanLoading(),
                    listTagihanLoading(),
                    listTagihanLoading(),
                    listTagihanLoading(),
                    listTagihanLoading(),
                    listTagihanLoading(),
                    listTagihanLoading(),
                  ],
                );
              },
            ))
      ],
    );
  }
}

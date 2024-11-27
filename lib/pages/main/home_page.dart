// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skypay/models/announcement_model.dart';
import 'package:skypay/models/invoice_model.dart';
import 'package:skypay/models/user_model.dart';
import 'package:skypay/providers/announcement_provider.dart';
import 'package:skypay/providers/customer_provider.dart';
import 'package:skypay/providers/invoice_provider.dart';
import 'package:skypay/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GetStorage box = GetStorage('skypay');

  @override
  Widget build(BuildContext context) {
    var customerProvider = Provider.of<CustomerProvider>(context);
    var invoiceProvider = Provider.of<InvoiceProvider>(context);
    var announcementProvider = Provider.of<AnnouncemenProvider>(context);
    bool statusBayar = false;

    Widget section1() {
      return FutureBuilder<UserModel>(
        future: customerProvider.customerMe(box.read('token'), context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              box.write('nama_pelanggan', snapshot.data!.name);
              box.write('nomor_pelanggan', snapshot.data!.phoneNumber);

              return Container(
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
                padding: EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                          color: primaryColor, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          snapshot.data!.name.substring(0, 2).toUpperCase(),
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
                            snapshot.data!.name,
                            style: textStyle2.copyWith(
                                fontSize: 18, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            snapshot.data!.phoneNumber,
                            style: textStyle3.copyWith(
                                fontSize: 18, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Text('');
            }
          }

          return Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: const Color.fromARGB(
                  255, 210, 210, 210), // Shimmer highlight color
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width: double.infinity,
                height: 100,
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
        },
      );
    }

    Widget section2() {
      return FutureBuilder<List<InvoiceModel>>(
          future: invoiceProvider.getInvoiceThisMonth(box.read('token')),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!.map((invoiceData) {
                    List<SubPayment>? items = invoiceData.subscriptionPayments;
                    items!.map((e) {
                      if (e.status == 1) {
                        statusBayar = true;
                      } else {
                        statusBayar = false;
                      }
                    }).toList();

                    return Container(
                      margin: EdgeInsets.only(top: 15),
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
                      padding: EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tagihan bulan ini',
                                      style: textStyle2.copyWith(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      child: Text(
                                        '${invoiceData.subscription.serviceId}',
                                        style: textStyle2.copyWith(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: statusBayar
                                        ? successColor
                                        : dangerColor,
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 8),
                                child: Text(
                                  statusBayar ? 'Sudah Lunas' : 'Belum Lunas',
                                  style: textStyle1.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Rp. ${NumberFormat('#,###').format(invoiceData!.price)}',
                            style: textStyle2.copyWith(
                                fontWeight: FontWeight.w700, fontSize: 24),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  statusBayar
                                      ? 'Tanggal Invoice'
                                      : 'Bayar Sebelum',
                                  style: textStyle2.copyWith(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                statusBayar
                                    ? DateFormat('dd MMMM yyyy').format(
                                        DateTime.parse(
                                            invoiceData.invoiceDate.toString()))
                                    : (invoiceData.dueDate != null
                                        ? DateFormat('dd MMMM yyyy').format(
                                            DateTime.parse(
                                                invoiceData.dueDate.toString()))
                                        : '-'),
                                style: textStyle2.copyWith(
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context,
                                statusBayar ? '/detailRiwayat' : '/payment',
                                arguments: {'id': invoiceData!.id}),
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color:
                                      statusBayar ? successColor : primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(
                                  statusBayar
                                      ? 'Lihat Detail'
                                      : 'Bayar Sekarang',
                                  style: textStyle1.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Text('');
              }
            }
            return Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: const Color.fromARGB(
                    255, 210, 210, 210), // Shimmer highlight color
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: 180,
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
          });
    }

    Widget pengumuman() {
      return FutureBuilder<List<AnnouncementModel>>(
        future: announcementProvider.getAnnouncement(box.read('token')),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                children: snapshot.data!
                    .map((announcementData) => Container(
                          margin: EdgeInsets.only(top: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: announcementData.type == 'info'
                                ? primaryColor
                                : announcementData.type == 'warning'
                                    ? warningColor
                                    : dangerColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icon/warning.png',
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '${announcementData.title}',
                                    style: textStyle2.copyWith(
                                        color:
                                            announcementData.type == 'warning'
                                                ? textColor1
                                                : Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                '${announcementData.content}',
                                style: textStyle2.copyWith(
                                    color: announcementData.type == 'warning'
                                        ? textColor1
                                        : Colors.white),
                                textAlign: TextAlign.left,
                              )
                            ],
                          ),
                        ))
                    .toList(),
              );
            } else {
              return Text('');
            }
          }
          return Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: const Color.fromARGB(
                  255, 210, 210, 210), // Shimmer highlight color
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width: double.infinity,
                height: 100,
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
        },
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: ListView(
        children: [
          section1(),
          pengumuman(),
          section2(),
        ],
      ),
    );
  }
}

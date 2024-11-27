// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skypay/models/invoice_model.dart';
import 'package:skypay/providers/invoice_provider.dart';
import 'package:skypay/theme.dart';

class DetailRiwayat extends StatelessWidget {
  const DetailRiwayat({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    GetStorage box = GetStorage('skypay');
    var invoiceProvider = Provider.of<InvoiceProvider>(context);
    bool statusBayar = false;
    int jumlahBayar = 0;
    String metodeBayar = "";
    DateTime? tanggalBayar;
    int totalRincian = 0;

    Widget section1(
        {String? invoiceNumber,
        String? invoiceDate,
        int? price,
        bool? bayar,
        String? metodeBayar,
        DateTime? tanggalBayar}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pembayaran Berhasil',
            style:
                textStyle2.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                color: successColor, borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text(
              'Invoice # : ${invoiceNumber}',
              style: textStyle3.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'Periode Tagihan',
            style:
                textStyle3.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            // ignore: unnecessary_string_interpolations
            '${DateFormat('MMMM yyyy').format(DateTime.parse(invoiceDate.toString()))}',
            style:
                textStyle2.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'Di bayar pada',
            style:
                textStyle3.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            '${DateFormat('dd MMMM yyyy - HH:mm:ss').format(DateTime.parse(tanggalBayar.toString()))}',
            style:
                textStyle2.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'Jumlah yang dibayar',
            style:
                textStyle3.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            'Rp. ${NumberFormat('#,###').format(price)}',
            style:
                textStyle2.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'Metode Pembayaran',
            style:
                textStyle3.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            '${metodeBayar}',
            style:
                textStyle2.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ],
      );
    }

    Widget section2({List<Item>? items, int? price}) {
      items?.map((e) => totalRincian += e.totalPrice!).toList();

      return Container(
        margin: EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rincian Tagihan',
              style: textStyle2.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              children: items!
                  .map(
                    (e) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${e.name}',
                            style: textStyle3.copyWith(fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Rp. ${NumberFormat('#,###').format(e.totalPrice)}',
                          style: textStyle2.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  )
                  .toList(),
            ),
            if (totalRincian != price && totalRincian != 0)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      (price! - totalRincian < 0
                          ? "Potongan Harga"
                          : "Biaya Admin"),
                      style: textStyle3.copyWith(fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Rp. ${NumberFormat('#,###').format(price! - totalRincian)}',
                    style: textStyle2.copyWith(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Total',
                    style: textStyle2.copyWith(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Rp. ${NumberFormat('#,###').format(price)}',
                  style: textStyle2.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w600),
                )
              ],
            ),
            SizedBox(
              height: 24,
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       color: primaryColor, borderRadius: BorderRadius.circular(5)),
            //   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            //   child: Center(
            //     child: Text(
            //       'Download Invoice',
            //       style: textStyle2.copyWith(
            //           color: Colors.white,
            //           fontSize: 12,
            //           fontWeight: FontWeight.w700),
            //     ),
            //   ),
            // )
          ],
        ),
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
                child: FutureBuilder<InvoiceModel>(
                  future: invoiceProvider.getInvoiceById(
                      box.read('token'), arguments['id'].toString(), context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        List<SubPayment>? items =
                            snapshot.data!.subscriptionPayments;

                        items!.map((e) {
                          if (e.status == 1) {
                            statusBayar = true;
                            jumlahBayar = e.paymentAmount!;
                            metodeBayar = e.paymentMethod!;
                            tanggalBayar = e.paidAt;
                          } else {
                            statusBayar = false;
                            jumlahBayar = 0;
                            metodeBayar = "";
                            tanggalBayar = null;
                          }
                        }).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            section1(
                                invoiceNumber: snapshot.data!.invoiceNumber,
                                invoiceDate: snapshot.data!.invoiceDate,
                                price: statusBayar
                                    ? jumlahBayar
                                    : snapshot.data!.price,
                                bayar: statusBayar,
                                metodeBayar: metodeBayar,
                                tanggalBayar: tanggalBayar),
                            section2(
                                items: snapshot.data!.items,
                                price: statusBayar
                                    ? jumlahBayar
                                    : snapshot.data!.price)
                          ],
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
                          height: 400,
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
                )),
          ],
        ));
  }
}

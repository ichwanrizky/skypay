// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skypay/models/invoice_model.dart';
import 'package:skypay/models/payment_model.dart';
import 'package:skypay/providers/invoice_provider.dart';
import 'package:skypay/theme.dart';

class Payment extends StatelessWidget {
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    GetStorage box = GetStorage('skypay');
    var invoiceProvider = Provider.of<InvoiceProvider>(context);
    bool statusBayar = false;
    int jumlahBayar = 0;
    String metodeBayar = "";
    int totalRincian = 0;

    void showError(String message, color) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
        backgroundColor: color,
      ));
    }

    Widget listPayment(
        {String? pgCode,
        String? pgName,
        String? paymentCode,
        int? subscriptionId,
        String? dueDate,
        int? price,
        int? feeAmount}) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: textColor2)),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/payment/${pgCode}.png",
                  width: 50,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    // Here you can return any widget that you want to show if the image fails to load
                    return Icon(Icons.error); // Example: an error icon
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    '${pgName}',
                    style: textStyle2.copyWith(
                        fontSize: 16, fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kode Bayar: ',
                        style: textStyle2.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(
                              ClipboardData(text: '${paymentCode}'));
                          showError('Kode Bayar ${pgName} Berhasil Disalin',
                              successColor);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.copy,
                              size: 25,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                '${paymentCode}',
                                style: textStyle2.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w800),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/payment-detail', arguments: {
                      'pg_code': pgCode,
                      'pg_name': pgName,
                      'payment_code': paymentCode,
                      'subscription_id': subscriptionId,
                      'due_date': dueDate,
                      'price': price,
                      'fee_amount': feeAmount
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                        color: successColor,
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Text(
                      'Bayar',
                      style: textStyle3.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget section1(
        {String? invoiceDate,
        String? dueDate,
        int? price,
        bool? bayar,
        String? metodeBayar}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tagihan Anda',
                  style: textStyle2.copyWith(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    color: bayar! ? successColor : dangerColor,
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text(
                  bayar ? 'Sudah Lunas' : 'Belum Lunas',
                  style: textStyle3.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ],
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
            'Batas Waktu Pembayaran',
            style:
                textStyle3.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            // ignore: unnecessary_string_interpolations
            dueDate != null
                ? '${DateFormat('dd MMMM yyyy').format(DateTime.parse(dueDate.toString()))}'
                : '',
            style:
                textStyle2.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 24,
          ),
          bayar
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Metode Pembayaran',
                      style: textStyle3.copyWith(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${metodeBayar}',
                      style: textStyle2.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                )
              : SizedBox(
                  height: 0,
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
        ],
      );
    }

    Widget section2({List<Item>? items, int? price, int? discountAmount}) {
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
                  .map((e) => Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(
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
                              'Rp ${NumberFormat('#,###').format(e.totalPrice)}',
                              style: textStyle2.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ))
                  .toList(),
            ),
            if (totalRincian != price)
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
                    (price - totalRincian < 0
                        ? "Rp -${NumberFormat('#,###').format(discountAmount)}"
                        : "Rp ${NumberFormat('#,###').format(price - totalRincian)}"),
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
                  'Rp ${NumberFormat('#,###').format(price)}',
                  style: textStyle2.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ],
        ),
      );
    }

    Widget section3({int? subscriptionId, String? dueDate, int? price}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metode Pembayaran',
            style:
                textStyle2.copyWith(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder<List<PaymentModel>>(
              future: invoiceProvider.getPaymentMethods(
                  box.read('token'), subscriptionId.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!
                          .map((paymentMethodData) => listPayment(
                              subscriptionId: subscriptionId,
                              pgCode: paymentMethodData.pgCode,
                              pgName: paymentMethodData.pgName,
                              paymentCode: paymentMethodData.paymentCode,
                              dueDate: dueDate,
                              price: price,
                              feeAmount: paymentMethodData.feeAmount))
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
                ;
              }),
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
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white),
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
                          } else {
                            statusBayar = false;
                            jumlahBayar = 0;
                            metodeBayar = "";
                          }
                        }).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            section1(
                                invoiceDate: snapshot.data!.invoiceDate,
                                dueDate: snapshot.data!.dueDate,
                                price: statusBayar
                                    ? jumlahBayar
                                    : snapshot.data!.price,
                                bayar: statusBayar,
                                metodeBayar: metodeBayar),
                            SizedBox(
                              height: 10,
                            ),
                            section2(
                                items: snapshot.data!.items,
                                price: statusBayar
                                    ? jumlahBayar
                                    : snapshot.data!.price,
                                discountAmount: snapshot.data!.discountAmount),
                            // ignore: prefer_is_empty
                            if (!statusBayar)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  section3(
                                      dueDate: snapshot.data!.dueDate,
                                      price: statusBayar
                                          ? jumlahBayar
                                          : snapshot.data!.price,
                                      subscriptionId:
                                          snapshot.data!.subscriptionId)
                                ],
                              ),
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
                  }),
            )
          ],
        ));
  }
}

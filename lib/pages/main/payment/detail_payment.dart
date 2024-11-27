// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skypay/models/instruction_model.dart';
import 'package:skypay/providers/invoice_provider.dart';
import 'package:skypay/theme.dart';

class DetailPayment extends StatefulWidget {
  const DetailPayment({super.key});

  @override
  State<DetailPayment> createState() => _DetailPaymentState();
}

class _DetailPaymentState extends State<DetailPayment> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    GetStorage box = GetStorage('skypay');
    var invoiceProvider = Provider.of<InvoiceProvider>(context);

    void showError(String message, color) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
        backgroundColor: color,
      ));
    }

    Widget instructionCard({List<String>? instructions}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: instructions!
            .map((e) => Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 20),
                            child: Text('')),
                        Expanded(
                          child: Text(
                            '- ${e}',
                            style: textStyle2.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ))
            .toList(),
      );
    }

    Widget cardData() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Periode Tagihan',
            style:
                textStyle3.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            // ignore: unnecessary_string_interpolations
            arguments['due_date'] != null
                ? '${DateFormat('dd MMMM yyyy').format(DateTime.parse(arguments['due_date'].toString()))}'
                : '',
            style:
                textStyle2.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Metode Bayar',
                    style: textStyle3.copyWith(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${arguments['pg_name'].toString()}',
                    style: textStyle2.copyWith(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              )),
              Image.asset(
                "assets/payment/${arguments['pg_code']}.png",
                width: 80,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // Here you can return any widget that you want to show if the image fails to load
                  return Icon(Icons.error); // Example: an error icon
                },
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kode Bayar',
                      style: textStyle3.copyWith(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${arguments['payment_code'].toString()}',
                      style: textStyle2.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Clipboard.setData(
                    ClipboardData(
                      text: '${arguments['payment_code'].toString()}',
                    ),
                  );

                  showError(
                      'Kode Bayar ${arguments['pg_name'].toString()} Berhasil Disalin',
                      successColor);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                      color: successColor,
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Row(
                    children: [
                      Text(
                        'Copy',
                        style: textStyle3.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.copy,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'Total Tagihan',
            style:
                textStyle3.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            'Rp. ${NumberFormat('#,###').format(arguments['price'])}',
            style:
                textStyle2.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'Biaya Admin',
            style:
                textStyle3.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            'Rp. ${NumberFormat('#,###').format(arguments['fee_amount'])}',
            style:
                textStyle2.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'Total yang harus dibayar',
            style:
                textStyle2.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Text(
            'Rp. ${NumberFormat('#,###').format(arguments['fee_amount'] + arguments['price'])}',
            style:
                textStyle2.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'Petunjuk Pembayaran',
            style:
                textStyle3.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<InstructionModel>>(
                  future: invoiceProvider.getInstructionPayment(
                      arguments['pg_code'].toString(),
                      arguments['subscription_id'].toString(),
                      box.read('token')),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return Text(
                            'Mohon maaf petunuk pembayaran belum tersedia',
                            style: TextStyle(color: dangerColor),
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: snapshot.data!
                                .map((instructionData) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          instructionData.title,
                                          style: textStyle2.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        instructionCard(
                                          instructions: instructionData.steps,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ))
                                .toList(),
                          );
                        }
                      }
                    }

                    return Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: const Color.fromARGB(
                            255, 210, 210, 210), // Shimmer highlight color
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: double.infinity,
                          height: 50,
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
                  })
            ],
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
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white),
              child: cardData())
        ],
      ),
    );
  }
}

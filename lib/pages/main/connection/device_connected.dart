import 'package:flutter/material.dart';
import 'package:skypay/models/perangkat_model.dart';
import 'package:skypay/theme.dart';

class DeviceConneted extends StatelessWidget {
  const DeviceConneted({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    final List<AssociatedDevice> deviceConnected =
        arguments['device_connected'];
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Image.asset(
            'assets/img/logo.png',
            width: 121,
            fit: BoxFit.contain,
          ),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: ListView(children: [
            Column(
                children: deviceConnected
                    .map((item) => Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: textColor2,
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: const Offset(0, 3),
                              )
                            ]),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nama Device  : ',
                                style: textStyle2.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                item.deviceName != "" ? item.deviceName : 'N/A',
                                style: textStyle2.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Mac Address  : ',
                                style: textStyle2.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                item.macAddress,
                                style: textStyle2.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'IP Address  : ',
                                style: textStyle2.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                item.ipAddress,
                                style: textStyle2.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Sinyal  : ',
                                style: textStyle2.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                item.signalStrength,
                                style: textStyle2.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ])))
                    .toList()),
          ]),
        ));
  }
}

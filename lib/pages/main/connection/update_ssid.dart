import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:skypay/providers/perangkat_provider.dart';
import 'package:skypay/theme.dart';

class UpdateSsid extends StatefulWidget {
  const UpdateSsid({super.key});

  @override
  State<UpdateSsid> createState() => _UpdateSsidState();
}

class _UpdateSsidState extends State<UpdateSsid> {
  bool isLoading = false;
  GetStorage box = GetStorage('skypay');
  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Map<String, dynamic> arguments = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This ensures that context is available
      arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
              {};
      if (arguments.containsKey('ssidName')) {
        ssidController.text = arguments['ssidName'] as String;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var perangkatProvider = Provider.of<PerangkatProvider>(context);

    void showError(String message, color) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: color,
      ));
    }

    Widget formSsid() {
      return Container(
        margin: const EdgeInsets.only(top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama SSID',
              style: textStyle2.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: textColor2)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: TextFormField(
                controller: ssidController,
                decoration: InputDecoration.collapsed(
                    hintText: 'masukan nama ssid anda',
                    hintStyle: textStyle3.copyWith(fontSize: 10)),
              ),
            )
          ],
        ),
      );
    }

    Widget formPassword() {
      return Container(
        margin: const EdgeInsets.only(top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password Wifi',
              style: textStyle2.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: textColor2)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration.collapsed(
                    hintText: 'masukan nama password wifi anda',
                    hintStyle: textStyle3.copyWith(fontSize: 10)),
              ),
            )
          ],
        ),
      );
    }

    Widget buttonSubmit() {
      return Column(
        children: [
          GestureDetector(
            onTap: () async {
              setState(() {
                isLoading = !isLoading;
              });

              if (ssidController.text.isEmpty) {
                showError('Nama SSID Tidak Boleh Kosong', dangerColor);
              } else {
                var response = await perangkatProvider.changeSsid(
                    box.read('token'),
                    arguments['serviceId'].toString(),
                    arguments['deviceId'].toString(),
                    arguments['ssidId'].toString(),
                    ssidController.text,
                    passwordController.text);

                if (!response[0]) {
                  showError(response[1], dangerColor);
                } else {
                  showError(response[1], successColor);
                  Navigator.pop(context);
                }
              }

              setState(() {
                isLoading = !isLoading;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 25),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Loading',
                            style: textStyle2.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        ],
                      )
                    : Text(
                        'Simpan Data',
                        style: textStyle2.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ),
        ],
      );
    }

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
        body: ListView(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ubah Nama SSID dan Password',
                    style: textStyle2.copyWith(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  formSsid(),
                  formPassword(),
                  buttonSubmit()
                ],
              ),
            )
          ],
        ));
  }
}

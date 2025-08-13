// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:customer/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constant_widgets/show_toast_dialog.dart';

class FlutterWaveScreen extends StatefulWidget {
  final String initialURl;

  const FlutterWaveScreen({
    super.key,
    required this.initialURl,
  });

  @override
  State<FlutterWaveScreen> createState() => _FlutterWaveScreenState();
}

class _FlutterWaveScreenState extends State<FlutterWaveScreen> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    initController();
    super.initState();
  }


  void initController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest navigation) async {
            ShowToastDialog.showLoader('Please Wait');
            debugPrint("--->2 ${navigation.url}");
            debugPrint("----------->3 $navigation");
            var uri = Uri.dataFromString(navigation.url);
            Map<String, String> params = uri.queryParameters;
            var txRef = params['tx_ref'];
            var transactionId = params['transaction_id'];
            final url = Uri.parse("https://api.ravepay.co/flwv3-pug/getpaidx/api/v2/verify");
            final headers = {
              'Content-Type': 'application/json',
            };

            final body = jsonEncode({
              'txref': txRef,
              'SECKEY': Constant.paymentModel!.flutterWave!.secretKey,
            });

            try {
              final response = await http.post(url, headers: headers, body: body);

              log('===============> Response status code: ${response.statusCode}');
              log('===============> Response body: ${response.body}');

              if (response.statusCode == 200) {
                final jsonResponse = jsonDecode(response.body);
                log('===============>  response in payment screen of flutter wave to string ${response.toString()}');
                if (navigation.url.contains("${Constant.paymentCallbackURL}/success")) {
                  ShowToastDialog.closeLoader();
                  Get.back(result: {"status": true, "transaction_id": transactionId, "tx_ref": txRef, "response": jsonResponse});
                }
              } else {
                log('===============> Error: ${response.body}');
              }
            } catch (e) {
              log('===============> Exception: $e');
            }

            if (navigation.url.contains("${Constant.paymentCallbackURL}/failure") || navigation.url.contains("${Constant.paymentCallbackURL}/pending")) {
              ShowToastDialog.closeLoader();
              Get.back(result: {
                "status": false,
                "transaction_id": "",
                "response": "",
              });
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialURl));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showMyDialog();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text("Payment".tr),
            centerTitle: false,
            leading: GestureDetector(
              onTap: () {
                _showMyDialog();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            )),
        body: WebViewWidget(controller: controller),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Payment'.tr),
          content: SingleChildScrollView(
            child: Text("cancelPayment?".tr),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel'.tr,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Get.back(result: false);
              },
            ),
            TextButton(
              child: Text(
                'Continue'.tr,
                style: const TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

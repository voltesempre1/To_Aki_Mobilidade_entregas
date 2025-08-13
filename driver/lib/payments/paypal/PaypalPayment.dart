// ignore_for_file: use_build_context_synchronously, file_names, depend_on_referenced_packages, deprecated_member_use

import 'dart:core';
import 'dart:developer';
import 'package:driver/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'PaypalServices.dart';

class PaypalPayment extends StatefulWidget {
  final String price;
  final String currencyCode;
  final String title;
  final String description;
  final Function onFinish;

  const PaypalPayment({
    super.key,
    required this.onFinish,
    required this.price,
    required this.currencyCode,
    required this.title,
    required this.description,
  });

  @override
  State<PaypalPayment> createState() => PaypalPaymentState();
}

class PaypalPaymentState extends State<PaypalPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl = '';
  String executeUrl = '';
  String accessToken = '';
  String orderId = '';
  PaypalServices services = PaypalServices();
  bool isLoading = false;

  WebViewController? controller;

  @override
  void initState() {
    log("=======>1");

    getCheckoutURL();
    initController();
    super.initState();
  }

  Future<void> getCheckoutURL() async {
    log("=======>2");
    try {
      accessToken = await services.getAccessToken();
      log("Access token: $accessToken");
      Map<String, dynamic> transactions = getOrderParams();
      final res = await services.createPaypalPayment(transactions, accessToken);
      if (res != null) {
        setState(() {
          checkoutUrl = res["approvalUrl"] ?? '';
          executeUrl = res["executeUrl"] ?? '';
          orderId = res["id"] ?? '';
        });
        controller!.loadRequest(Uri.parse(checkoutUrl));
        controller!.clearCache();
      }
    } catch (e) {
      log('exception: $e');
      Get.back();
      // AppHelper.showErrorPopup(
      //     'Payment Failed', e.toString().replaceAll("Exception: ", "").isEmpty ? "Something went wrong!" : e.toString().replaceAll("Exception: ", ""),
      //     () {
        // Get.back();
      // });
    }
  }

  void initController(){
    log("=======>initController");
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            final uri = Uri.parse(request.url);
            log('uri : $uri');
            if (request.url.contains('https://example.com/return')) {
              final uri = Uri.parse(request.url);
              log('uri : $uri');
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                // widget.onFinish(payerID);
                // Navigator.of(context).pop();
                setState(() {
                  isLoading = true;
                });
                services.authorizePayment(Uri.parse(executeUrl), payerID, accessToken).then((id) {
                  log('Order id : $id');
                  widget.onFinish({"orderId": orderId, "authorizeId": id});
                });
              } else {
                Navigator.of(context).pop();
              }
            }
            if (request.url.contains('https://example.com/cancel')) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  Map<String, dynamic> getOrderParams() {
    Map<String, dynamic> temp = {
      "intent": "AUTHORIZE",
      "purchase_units": [
        {
          "items": [
            {
              "name": widget.title.toString(),
              "description": widget.description.toString(),
              "quantity": "1",
              "unit_amount": {"currency_code": widget.currencyCode.toString(), "value": widget.price.toString()}
            }
          ],
          "amount": {
            "currency_code": widget.currencyCode.toString(),
            "value": widget.price.toString(),
            "breakdown": {
              "item_total": {"currency_code": widget.currencyCode.toString(), "value": widget.price.toString()}
            }
          }
        }
      ],
      "application_context": {"return_url": "https://example.com/return", "cancel_url": "https://example.com/cancel"}
    };
    log(temp.toString());
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    log(checkoutUrl);

    if (checkoutUrl.isNotEmpty) {
      return WillPopScope(
        onWillPop: () {
          showAlertDialog(context);
          return Future(() => true);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: GestureDetector(
              child: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onTap: () {
                showAlertDialog(context);
              },
            ),
            elevation: 0.0,
          ),
          body: isLoading
            ?  Center(child: Constant.loader())
              : WebViewWidget(
                  controller: controller!,
                ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () {
          showAlertDialog(context);
          return Future(() => true);
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  showAlertDialog(context);
                }),
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body:  Center(child:  Constant.loader()),
        ),
      );
    }
  }

  void showAlertDialog(BuildContext contextt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert!"),
          content: const Text("Would you like to cancel this payment?"),
          actions: [
            TextButton(
              child: const Text("Continue to Paypal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Cancel Payment"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(contextt).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// ignore_for_file: library_prefixes

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as maths;

import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/payment_method_model.dart';
import 'package:driver/app/models/payment_model/stripe_failed_model.dart';
import 'package:driver/app/models/subscription_model.dart';
import 'package:driver/app/models/subscription_plan_history.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/payments/flutter_wave/flutter_wave.dart';
import 'package:driver/payments/marcado_pago/mercado_pago_screen.dart';
import 'package:driver/payments/pay_fast/pay_fast_screen.dart';
import 'package:driver/payments/pay_stack/pay_stack_screen.dart';
import 'package:driver/payments/pay_stack/pay_stack_url_model.dart';
import 'package:driver/payments/paypal/PaypalPayment.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mp_integration/mp_integration.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart' as RazorpayFlutter;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../../payments/pay_stack/paystack_url_generator.dart';
import '../../../../theme/app_them_data.dart';

class SubscriptionPlanController extends GetxController {
  RxBool isLoading = true.obs;

  Rx<SubscriptionModel> selectedSubscription = SubscriptionModel().obs;
  RxString selectedPaymentMethod = "".obs;
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  RxList<SubscriptionModel> subscriptionPlanList = <SubscriptionModel>[].obs;

  final RazorpayFlutter.Razorpay _razorpay = RazorpayFlutter.Razorpay();

  @override
  void onInit() {
    getSubscription();
    getPaymentData();
    if (subscriptionPlanList.isNotEmpty) {
      selectedSubscription.value = subscriptionPlanList.first;
    }
    super.onInit();
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  Future<void> getPaymentData() async {
    try {
      final payment = await FireStoreUtils().getPayment();
      if (payment != null) {
        paymentModel.value = payment;
        if (paymentModel.value.strip!.isActive == true) {
          Stripe.publishableKey = paymentModel.value.strip!.clientPublishableKey.toString();
          Stripe.merchantIdentifier = 'MyTaxi';
          Stripe.instance.applySettings();
        }
      }
    } catch (e) {
      log('Error fetching payment data: $e');
    }
  }

  Future<void> getSubscription() async {
    isLoading.value = true;
    final list = await FireStoreUtils.getSubscription();
    subscriptionPlanList.assignAll(list);
    if (subscriptionPlanList.isNotEmpty) {
      selectedSubscription.value = subscriptionPlanList.first;
    }
    isLoading.value = false;
  }

  Future<void> completeSubscription() async {
    ShowToastDialog.showLoader("Please Wait");

    driverModel.value.subscriptionPlanId = selectedSubscription.value.id;
    driverModel.value.subscriptionExpiryDate = selectedSubscription.value.expireDays == "-1" ? null : Constant().addDayInTimestamp(days: selectedSubscription.value.expireDays, date: Timestamp.now());
    driverModel.value.subscriptionPlan = selectedSubscription.value;
    driverModel.value.subscriptionTotalBookings = selectedSubscription.value.features!.bookings;
    await FireStoreUtils.updateDriverUser(driverModel.value);

    SubscriptionHistoryModel subscriptionPlanHistory = SubscriptionHistoryModel();
    subscriptionPlanHistory.id = Constant.getUuid();
    subscriptionPlanHistory.driverId = driverModel.value.id;
    subscriptionPlanHistory.subscriptionPlan = selectedSubscription.value;
    subscriptionPlanHistory.createdAt = Timestamp.now();
    subscriptionPlanHistory.expiryDate = selectedSubscription.value.expireDays == "-1" ? null : Constant().addDayInTimestamp(days: selectedSubscription.value.expireDays, date: Timestamp.now());
    subscriptionPlanHistory.paymentType = selectedPaymentMethod.value;
    await FireStoreUtils.setSubscriptionHistory(subscriptionPlanHistory).then((value) {
      if (value == true) {
        ShowToastDialog.toast("SubscriptionPlan Purchase Successfully..".tr);
        Get.to(const HomeView());
      }
    }).catchError((error) {
      log("Subscription History Saved Failed :: $error");
    });
    ShowToastDialog.closeLoader();
  }

  // ************** RazorPay
  Future<void> razorpayMakePayment({required String amount}) async {
    try {
      var options = {
        'key': paymentModel.value.razorpay!.razorpayKey,
        "razorPaySecret": paymentModel.value.razorpay!.razorpaySecret,
        'amount': double.parse(amount) * 100,
        "currency": "INR",
        'name': driverModel.value.fullName,
        "isSandBoxEnabled": paymentModel.value.razorpay!.isSandbox,
        'external': {
          'wallets': ['paytm']
        },
        'send_sms_hash': true,
        'prefill': {'contact': driverModel.value.phoneNumber, 'email': driverModel.value.email},
      };

      _razorpay.open(options);
      _razorpay.on(RazorpayFlutter.Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(RazorpayFlutter.Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(RazorpayFlutter.Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    } catch (e) {
      log('Error in razorpayMakePayment: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Payment success logic
    ShowToastDialog.toast("Payment Successful!!");
    log('Payment Success: ${response.paymentId}');
    completeSubscription();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failure logic
    log('Payment Error: ${response.code} - ${response.message}');
    ShowToastDialog.toast('Payment failed. Please try again.');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet selection logic
    log('External Wallet: ${response.walletName}');
  }

  // ************** Stripe
  Future<void> stripeMakePayment({required String amount}) async {
    ShowToastDialog.showLoader("Please Wait..");
    log(double.parse(amount).toStringAsFixed(0));
    try {
      Map<String, dynamic>? paymentIntentData = await createStripeIntent(amount: amount);
      if (paymentIntentData!.containsKey("error")) {
        Get.back();
        ShowToastDialog.closeLoader();
        ShowToastDialog.toast("Something went wrong, please contact admin.");
      } else {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntentData['client_secret'],
                allowsDelayedPaymentMethods: false,
                googlePay: const PaymentSheetGooglePay(
                  merchantCountryCode: 'US',
                  testEnv: true,
                  currencyCode: "USD",
                ),
                customFlow: true,
                style: ThemeMode.system,
                appearance: PaymentSheetAppearance(
                  colors: PaymentSheetAppearanceColors(
                    primary: AppThemData.primary500,
                  ),
                ),
                merchantDisplayName: 'MyTaxi'));
        displayStripePaymentSheet(amount: amount);
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.toast("exception:$e \n$s");
    }
  }

  Future<void> displayStripePaymentSheet({required String amount}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        ShowToastDialog.toast("Payment successfully");
        completeSubscription();
        ShowToastDialog.closeLoader();
      });
    } on StripeException catch (e) {
      var lo1 = jsonEncode(e);
      var lo2 = jsonDecode(lo1);
      StripePayFailedModel lom = StripePayFailedModel.fromJson(lo2);
      ShowToastDialog.closeLoader();
      ShowToastDialog.toast(lom.error.message);
    } catch (e) {
      ShowToastDialog.toast(e.toString());
    }
  }

  Future createStripeIntent({required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "Strip Payment",
        "shipping[name]": driverModel.value.fullName,
        "shipping[address][line1]": "510 Townsend St",
        "shipping[address][postal_code]": "98140",
        "shipping[address][city]": "San Francisco",
        "shipping[address][state]": "CA",
        "shipping[address][country]": "US",
      };
      log(paymentModel.value.strip!.stripeSecret.toString());
      var stripeSecret = paymentModel.value.strip!.stripeSecret;
      var response =
          await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'), body: body, headers: {'Authorization': 'Bearer $stripeSecret', 'Content-Type': 'application/x-www-form-urlencoded'});

      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  // ************** FlutterWave
  Future<Null> flutterWaveInitiatePayment({required BuildContext context, required String amount}) async {
    final url = Uri.parse('https://api.flutterwave.com/v3/payments');
    final headers = {
      'Authorization': 'Bearer ${paymentModel.value.flutterWave!.secretKey}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "tx_ref": _ref,
      "amount": amount,
      "currency": "USD",
      "redirect_url": '${Constant.paymentCallbackURL}/success',
      "payment_options": "ussd, card, barter, payattitude",
      "customer": {
        "email": driverModel.value.email.toString(),
        "phonenumber": driverModel.value.phoneNumber,
        "name": driverModel.value.fullName,
      },
      "customizations": {
        "title": "Payment for Services",
        "description": "Payment for XYZ services",
      }
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ShowToastDialog.closeLoader();
      await Get.to(FlutterWaveScreen(initialURl: data['data']['link']))!.then((value) {
        if (value != null) {
          log(":::::::::::::::::::::::::::::::::::$value");
          if (value) {
            log(":::::::::::::::::::::::::::::::::::$data");
            ShowToastDialog.toast("Payment Successful!!");
            // completeOrder(_ref ?? '');
            completeSubscription();
            ShowToastDialog.closeLoader();
          } else {
            ShowToastDialog.toast("Payment UnSuccessful!!");
          }
        } else {
          ShowToastDialog.toast("Payment UnSuccessful!!");
        }
      });
    } else {
      return null;
    }
  }

  String? _ref;

  void setRef() {
    maths.Random numRef = maths.Random();
    int year = DateTime.now().year;
    int refNumber = numRef.nextInt(20000);
    if (Platform.isAndroid) {
      _ref = "AndroidRef$year$refNumber";
    } else if (Platform.isIOS) {
      _ref = "IOSRef$year$refNumber";
    }
  }

  // ************** PayStack
  Future<void> payStackPayment(String totalAmount) async {
    await PayStackURLGen.payStackURLGen(
            amount: (double.parse(totalAmount) * 100).toString(), currency: "NGN", secretKey: paymentModel.value.payStack!.payStackSecret.toString(), userModel: driverModel.value)
        .then((value) async {
      if (value != null) {
        PayStackUrlModel payStackModel = value;
        Get.to(PayStackScreen(
          secretKey: paymentModel.value.payStack!.payStackSecret.toString(),
          callBackUrl: Constant.paymentCallbackURL.toString(),
          initialURl: payStackModel.data.authorizationUrl,
          amount: totalAmount,
          reference: payStackModel.data.reference,
        ))!
            .then((value) {
          if (value) {
            ShowToastDialog.showToast("Payment Successful!!");
            completeSubscription();
            ShowToastDialog.closeLoader();
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!");
          }
        });
      } else {
        ShowToastDialog.showToast("Something went wrong, please contact admin.");
      }
    });
  }

// ************** MarcadoPago
  void mercadoPagoMakePayment({required BuildContext context, required String amount}) {
    makePreference(amount).then((result) async {
      try {
        if (result.isNotEmpty) {
          log(result.toString());
          if (result['status'] == 200) {
            var preferenceId = result['response']['id'];
            log(preferenceId);

            Get.to(MercadoPagoScreen(initialURl: result['response']['init_point']))!.then((value) {
              log(value);

              if (value) {
                ShowToastDialog.showToast("Payment Successful!");
                completeSubscription();
                ShowToastDialog.closeLoader();
              } else {
                ShowToastDialog.showToast("Payment failed!");
              }
            });
            // final bool isDone = await Navigator.push(context, MaterialPageRoute(builder: (context) => MercadoPagoScreen(initialURl: result['response']['init_point'])));
          } else {
            ShowToastDialog.showToast("Error while transaction!");
          }
        } else {
          ShowToastDialog.showToast("Error while transaction!");
        }
      } catch (e) {
        ShowToastDialog.showToast("Something went wrong.");
      }
    });
  }

  Future<Map<String, dynamic>> makePreference(String amount) async {
    final mp = MP.fromAccessToken(paymentModel.value.mercadoPago!.mercadoPagoAccessToken);
    var pref = {
      "items": [
        {"title": "Wallet TopUp", "quantity": 1, "unit_price": double.parse(amount)}
      ],
      "auto_return": "all",
      "back_urls": {"failure": "${Constant.paymentCallbackURL}/failure", "pending": "${Constant.paymentCallbackURL}/pending", "success": "${Constant.paymentCallbackURL}/success"},
    };

    var result = await mp.createPreference(pref);
    return result;
  }

  // ************** Paypal
  Future<void> payPalPayment({required String amount}) async {
    ShowToastDialog.closeLoader();
    await Get.to(() => PaypalPayment(
          onFinish: (result) {
            if (result != null) {
              Get.back();
              ShowToastDialog.toast("Payment Successful");
              completeSubscription();
              // completeOrder(result['orderId']);
            } else {
              ShowToastDialog.toast("Payment canceled or failed.");
            }
          },
          price: amount,
          currencyCode: "USD",
          title: "Add Money",
          description: "Add Balance in Wallet",
        ));
  }

  // ************** PayFast
  void payFastPayment({required BuildContext context, required String amount}) {
    PayStackURLGen.getPayHTML(payFastSettingData: paymentModel.value.payFast!, amount: amount.toString(), userModel: driverModel.value).then((String? value) async {
      bool isDone = await Get.to(PayFastScreen(htmlData: value!, payFastSettingData: paymentModel.value.payFast!));
      if (isDone) {
        Get.back();
        ShowToastDialog.showToast("Payment successfully");
        completeSubscription();
        ShowToastDialog.closeLoader();
      } else {
        Get.back();
        ShowToastDialog.showToast("Payment Failed");
      }
    });
  }
}

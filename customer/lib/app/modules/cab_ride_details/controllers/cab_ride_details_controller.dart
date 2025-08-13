// ignore_for_file: unnecessary_overrides

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as maths;

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/app/models/booking_model.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/models/map_model.dart';
import 'package:customer/app/models/payment_method_model.dart';
import 'package:customer/app/models/payment_model/stripe_failed_model.dart';
import 'package:customer/app/models/review_customer_model.dart';
import 'package:customer/app/models/user_model.dart';
import 'package:customer/app/models/wallet_transaction_model.dart';
import 'package:customer/constant/collection_name.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/send_notification.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/extension/string_extensions.dart';
import 'package:customer/payments/flutter_wave/flutter_wave.dart';
import 'package:customer/payments/marcado_pago/mercado_pago_screen.dart';
import 'package:customer/payments/pay_fast/pay_fast_screen.dart';
import 'package:customer/payments/pay_stack/pay_stack_screen.dart';
import 'package:customer/payments/pay_stack/pay_stack_url_model.dart';
import 'package:customer/payments/pay_stack/paystack_url_generator.dart';
import 'package:customer/payments/paypal/PaypalPayment.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_paypal_native/flutter_paypal_native.dart';
// import 'package:flutter_paypal_native/models/custom/currency_code.dart';
// import 'package:flutter_paypal_native/models/custom/environment.dart';
// import 'package:flutter_paypal_native/models/custom/order_callback.dart';
// import 'package:flutter_paypal_native/models/custom/purchase_unit.dart';
// import 'package:flutter_paypal_native/models/custom/user_action.dart';
// import 'package:flutter_paypal_native/str_helper.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

// import 'package:flutterwave_standard/flutterwave.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mp_integration/mp_integration.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart' as razor_pay_flutter;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CabRideDetailsController extends GetxController {
  RxList<ReviewModel> reviewList = <ReviewModel>[].obs;
  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<UserModel> userModel = UserModel().obs;
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  RxString selectedPaymentMethod = "".obs;
  razor_pay_flutter.Razorpay _razorpay = razor_pay_flutter.Razorpay();

  @override
  void onInit() {
    getArguments();
    super.onInit();
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  void getArguments() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
      getBookingDetails();
    }
  }

  Future<void> getReview() async {
    final snapshot = await FirebaseFirestore.instance.collection(CollectionName.review).get();
    reviewList.value = snapshot.docs.map((doc) => ReviewModel.fromJson(doc.data())).toList();
  }

  Future<void> getBookingDetails() async {
    getReview();
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;
        if (paymentModel.value.strip!.isActive == true) {
          Stripe.publishableKey = paymentModel.value.strip!.clientPublishableKey.toString();
          Stripe.merchantIdentifier = 'MyTaxi';
          Stripe.instance.applySettings();
        }
        if (paymentModel.value.paypal!.isActive == true) {
          // initPayPal();
        }
        if (paymentModel.value.flutterWave!.isActive == true) {
          setRef();
        }
      }
    });
    bookingModel.value = (await FireStoreUtils.getRideDetails(bookingModel.value.id.toString())) ?? BookingModel();
    selectedPaymentMethod.value = bookingModel.value.paymentType.toString();
    await getProfileData();
  }

  Future<void> getProfileData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        userModel.value = value;
      }
    });
  }

  Future<void> completeOrder(String transactionId) async {
    bool isPaymentStatus = bookingModel.value.paymentStatus ?? false;
    ShowToastDialog.showLoader("Please wait".tr);
    // bookingModel.value.paymentStatus

    bookingModel.value.paymentType = selectedPaymentMethod.value;
    if (bookingModel.value.paymentType == Constant.paymentModel!.cash!.name) {
      bookingModel.value.paymentStatus = selectedPaymentMethod.value == Constant.paymentModel!.cash!.name ? false : true;
    }

    //if payment type cash -------->send notification to driver
    WalletTransactionModel transactionModel = WalletTransactionModel(
        id: Constant.getUuid(),
        amount: Constant.calculateFinalAmount(bookingModel.value).toString(),
        createdDate: Timestamp.now(),
        paymentType: selectedPaymentMethod.value,
        transactionId: transactionId,
        userId: bookingModel.value.driverId,
        isCredit: true,
        type: Constant.typeDriver,
        note: "Ride fee Credited ");

    await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
      if (value == true) {
        await FireStoreUtils.updateOtherUserWallet(amount: Constant.calculateFinalAmount(bookingModel.value).toString(), id: bookingModel.value.driverId!);
      }
    }).catchError((error) {
      log('========> error of set wallwtee $error');
    });

    if (Constant.adminCommission != null && Constant.adminCommission!.active == true && num.parse(Constant.adminCommission!.value!) > 0) {
      WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
          id: Constant.getUuid(),
          amount:
              "${Constant.calculateAdminCommission(amount: ((double.parse(bookingModel.value.subTotal ?? '0.0')) - (double.parse(bookingModel.value.discount ?? '0.0'))).toString(), adminCommission: bookingModel.value.adminCommission)}",
          createdDate: Timestamp.now(),
          paymentType: "Wallet",
          transactionId: bookingModel.value.id,
          isCredit: false,
          type: Constant.typeDriver,
          userId: bookingModel.value.driverId,
          note: "Admin commission Debited",
          adminCommission: bookingModel.value.adminCommission);

      await FireStoreUtils.setWalletTransaction(adminCommissionWallet).then((value) async {
        if (value == true) {
          await FireStoreUtils.updateOtherUserWallet(
              amount:
                  "-${Constant.calculateAdminCommission(amount: ((double.parse(bookingModel.value.subTotal ?? '0.0')) - (double.parse(bookingModel.value.discount ?? '0.0'))).toString(), adminCommission: bookingModel.value.adminCommission)}",
              id: bookingModel.value.driverId!);
        }
      }).catchError((error) {
        log('=======> error of transcation 3333 $error');
      });
    }

    log('====---33--> selecte payment status ${bookingModel.value.paymentStatus}');

    bookingModel.value.paymentStatus = isPaymentStatus;

    await FireStoreUtils.setBooking(bookingModel.value).then((value) {
      ShowToastDialog.closeLoader();
      // Get.offAllNamed(Routes.HOME);
    });
    log('====---444--> selecte payment status ${bookingModel.value.paymentStatus}');

    DriverUserModel? receiverUserModel = await FireStoreUtils.getDriverUserProfile(bookingModel.value.driverId.toString());
    Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel.value.id};
    await SendNotification.sendOneNotification(
        type: "order",
        token: receiverUserModel!.fcmToken.toString(),
        title: 'Payment Received'.tr,
        body: 'Payment Received for Ride #${bookingModel.value.id.toString().substring(0, 5)}',
        bookingId: bookingModel.value.id,
        driverId: bookingModel.value.driverId.toString(),
        senderId: FireStoreUtils.getCurrentUid(),
        payload: playLoad);

    ShowToastDialog.closeLoader();
    Get.back();
    // Get.offAllNamed(Routes.HOME);
  }

  Future<String> getDistanceInKm() async {
    String km = '';
    LatLng departureLatLong = LatLng(bookingModel.value.pickUpLocation!.latitude ?? 0.0, bookingModel.value.pickUpLocation!.longitude ?? 0.0);
    LatLng destinationLatLong = LatLng(bookingModel.value.dropLocation!.latitude ?? 0.0, bookingModel.value.dropLocation!.longitude ?? 0.0);
    MapModel? mapModel = await Constant.getDurationDistance(departureLatLong, destinationLatLong);
    if (mapModel != null) {
      km = mapModel.rows!.first.elements!.first.distance!.text!;
    }
    return km;
  }

  // ::::::::::::::::::::::::::::::::::::::::::::Wallet::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> walletPaymentMethod() async {
    ShowToastDialog.showLoader("Please wait".tr);

    // bookingModel.value.paymentStatus = true;
    // ShowToastDialog.showToast("Payment successful");
    WalletTransactionModel transactionModel = WalletTransactionModel(
        id: Constant.getUuid(),
        amount: Constant.calculateFinalAmount(bookingModel.value).toString(),
        createdDate: Timestamp.now(),
        paymentType: selectedPaymentMethod.value,
        transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: FireStoreUtils.getCurrentUid(),
        isCredit: false,
        type: Constant.typeCustomer,
        note: "Ride fee Debited");

    await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
      if (value == true) {
        await FireStoreUtils.updateUserWallet(amount: "-${Constant.calculateFinalAmount(bookingModel.value).toString()}").then((value) async {
          await getProfileData();
          bookingModel.value.paymentStatus = true;
          await FireStoreUtils.setBooking(bookingModel.value);
        });
      }
    });
    ShowToastDialog.closeLoader();

    completeOrder(DateTime.now().millisecondsSinceEpoch.toString());
  }

  // ::::::::::::::::::::::::::::::::::::::::::::Stripe::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> stripeMakePayment({required String amount}) async {
    try {
      int finalAmount = amount.toInt();
      log(double.parse(amount).toStringAsFixed(0));
      log(double.parse(finalAmount.toString()).toStringAsFixed(0));
      try {
        Map<String, dynamic>? paymentIntentData = await createStripeIntent(amount: finalAmount.toString());
        if (paymentIntentData!.containsKey("error")) {
          Get.back();
          ShowToastDialog.showToast("Something went wrong, please contact admin.");
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
                  style: ThemeMode.system,
                  appearance: PaymentSheetAppearance(
                    colors: PaymentSheetAppearanceColors(
                      primary: AppThemData.primary500,
                    ),
                  ),
                  merchantDisplayName: 'MyTaxi'));
          displayStripePaymentSheet(amount: finalAmount.toString());
        }
      } catch (e, s) {
        log("$e \n$s");
        ShowToastDialog.showToast("exception:$e \n$s");
      }
    } catch (e) {
      log('Existing in stripeMakePayment: $e');
    }
  }

  Future<void> displayStripePaymentSheet({required String amount}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        ShowToastDialog.showToast("Payment successfully");
        bookingModel.value.paymentStatus = true;
        completeOrder(DateTime.now().millisecondsSinceEpoch.toString());
      });
    } on StripeException catch (e) {
      var lo1 = jsonEncode(e);
      var lo2 = jsonDecode(lo1);
      StripePayFailedModel lom = StripePayFailedModel.fromJson(lo2);
      ShowToastDialog.showToast(lom.error.message);
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
      log('Existing in displayStripePaymentSheet: $e');
    }
  }

  Future createStripeIntent({required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "Strip Payment",
        "shipping[name]": userModel.value.fullName,
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

  // ::::::::::::::::::::::::::::::::::::::::::::PayPal::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> payPalPayment({required String amount}) async {
    int finalAmount = amount.toInt();

    ShowToastDialog.closeLoader();
    await Get.to(() => PaypalPayment(
          onFinish: (result) {
            if (result != null) {
              Get.back();
              ShowToastDialog.showToast("Payment Successful");
              bookingModel.value.paymentStatus = true;
              completeOrder(result['orderId']);
            } else {
              ShowToastDialog.showToast("Payment canceled or failed.");
            }
          },
          price: finalAmount.toString(),
          currencyCode: "USD",
          title: "Payment for services",
          description: "Payment for Ride booking services",
        ));
  }

  // final _flutterPaypalNativePlugin = FlutterPaypalNative.instance;
  //
  // void initPayPal() async {
  //   FlutterPaypalNative.isDebugMode = paymentModel.value.paypal!.isSandbox == true ? true : false;
  //
  //   await _flutterPaypalNativePlugin.init(
  //     returnUrl: "com.mytaxi.customer://paypalpay",
  //     clientID: paymentModel.value.paypal!.paypalClient.toString(),
  //     payPalEnvironment: paymentModel.value.paypal!.isSandbox == true ? FPayPalEnvironment.sandbox : FPayPalEnvironment.live,
  //     currencyCode: FPayPalCurrencyCode.usd,
  //     action: FPayPalUserAction.payNow,
  //   );
  //
  //   _flutterPaypalNativePlugin.setPayPalOrderCallback(
  //     callback: FPayPalOrderCallback(
  //       onCancel: () {
  //         ShowToastDialog.closeLoader();
  //         ShowToastDialog.showToast("Payment canceled");
  //       },
  //       onSuccess: (data) {
  //         _flutterPaypalNativePlugin.removeAllPurchaseItems();
  //         String visitor = data.cart?.shippingAddress?.firstName ?? 'Visitor';
  //         String address = data.cart?.shippingAddress?.line1 ?? 'Unknown Address';
  //         ShowToastDialog.showToast("Payment Successfully");
  //         bookingModel.value.paymentStatus = true;
  //         ShowToastDialog.closeLoader();
  //         completeOrder(data.orderId ?? DateTime.now().millisecondsSinceEpoch.toString());
  //       },
  //       onError: (data) {
  //         ShowToastDialog.closeLoader();
  //         ShowToastDialog.showToast("error: ${data.reason}");
  //       },
  //       onShippingChange: (data) {
  //         ShowToastDialog.closeLoader();
  //         ShowToastDialog.showToast("shipping change: ${data.shippingChangeAddress?.adminArea1 ?? ""}");
  //       },
  //     ),
  //   );
  // }
  //
  // paypalPaymentSheet(String amount) {
  //   ShowToastDialog.showLoader("Please wait".tr);
  //   if (_flutterPaypalNativePlugin.canAddMorePurchaseUnit) {
  //     _flutterPaypalNativePlugin.addPurchaseUnit(
  //       FPayPalPurchaseUnit(
  //         amount: double.parse(amount),
  //         referenceId: FPayPalStrHelper.getRandomString(16),
  //       ),
  //     );
  //   }
  //
  //   _flutterPaypalNativePlugin.makeOrder(
  //     action: FPayPalUserAction.payNow,
  //   );
  // }

  // ::::::::::::::::::::::::::::::::::::::::::::RazorPay::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<void> razorpayMakePayment({required String amount}) async {
    try {
      int finalAmount = amount.toInt();
      ShowToastDialog.showLoader("Please wait".tr);
      var options = {
        'key': paymentModel.value.razorpay!.razorpayKey,
        "razorPaySecret": paymentModel.value.razorpay!.razorpayKey,
        'amount': double.parse(finalAmount.toString()) * 100,
        "currency": "INR",
        'name': userModel.value.fullName,
        "isSandBoxEnabled": paymentModel.value.razorpay!.isSandbox,
        'external': {
          'wallets': ['paytm']
        },
        'send_sms_hash': true,
        'prefill': {'contact': userModel.value.phoneNumber, 'email': userModel.value.email},
      };

      _razorpay.open(options);
      _razorpay.on(razor_pay_flutter.Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(razor_pay_flutter.Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(razor_pay_flutter.Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    } catch (e) {
      log('Error in razorpayMakePayment: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Payment success logic

    ShowToastDialog.showToast("Payment Successfully");
    bookingModel.value.paymentStatus = true;
    completeOrder(response.paymentId ?? DateTime.now().millisecondsSinceEpoch.toString());
    log('Payment Success: ${response.paymentId}');
    _razorpay.clear();
    _razorpay = razor_pay_flutter.Razorpay();
    log('========@@=====------------==call razor pay');

    ShowToastDialog.closeLoader();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failure logic
    log('Payment Error: ${response.code} - ${response.message}');
    ShowToastDialog.showToast('Payment failed. Please try again.');
    ShowToastDialog.closeLoader();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet selection logic
    log('External Wallet: ${response.walletName}');
    ShowToastDialog.closeLoader();
  }

  // ::::::::::::::::::::::::::::::::::::::::::::FlutterWave::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<Null> flutterWaveInitiatePayment({required BuildContext context, required String amount}) async {
    int finalAmount = amount.toInt();

    final url = Uri.parse('https://api.flutterwave.com/v3/payments');
    final headers = {
      'Authorization': 'Bearer ${paymentModel.value.flutterWave!.secretKey}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "tx_ref": _ref,
      "amount": finalAmount,
      "currency": "USD",
      "redirect_url": '${Constant.paymentCallbackURL}/success',
      "payment_options": "ussd, card, barter, payattitude",
      "customer": {
        "email": userModel.value.email.toString(),
        "phonenumber": userModel.value.phoneNumber,
        "name": userModel.value.fullName!,
      },
      "customizations": {
        "title": "Payment for Services",
        "description": "Payment for Ride booking services",
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
            ShowToastDialog.showToast("Payment Successful!!");
            bookingModel.value.paymentStatus = true;

            completeOrder(_ref ?? '');
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!");
          }
        } else {
          ShowToastDialog.showToast("Payment UnSuccessful!!");
        }
      });
    } else {
      return null;
    }
    // final flutterWave = Flutterwave(
    //   amount: amount.trim(),
    //   currency: Constant.currencyModel!.code ?? "NGN",
    //   customer: Customer(name: userModel.value.fullName, phoneNumber: userModel.value.phoneNumber, email: userModel.value.email.toString()),
    //   context: context,
    //   publicKey: paymentModel.value.flutterWave!.publicKey.toString().trim(),
    //   paymentOptions: "ussd, card, barter, payattitude",
    //   customization: Customization(title: "GoRide"),
    //   txRef: _ref!,
    //   isTestMode: paymentModel.value.flutterWave!.isSandBox!,
    //   redirectUrl: '${Constant.paymentCallbackURL}success',
    //   paymentPlanId: _ref!,
    // );
    // final ChargeResponse response = await flutterWave.charge();
    //
    // if (response.success!) {
    //   ShowToastDialog.showToast("Payment Successful!!");
    //   bookingModel.value.paymentStatus = true;
    //
    //   completeOrder(response.transactionId ?? '');
    // } else {
    //   ShowToastDialog.showToast("Your payment is ${response.status!}");
    // }
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

  // ::::::::::::::::::::::::::::::::::::::::::::PayStack::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<void> payStackPayment(String totalAmount) async {
    int finalAmount = totalAmount.toInt();

    await PayStackURLGen.payStackURLGen(
            amount: (double.parse(finalAmount.toString()) * 100).toString(), currency: "NGN", secretKey: paymentModel.value.payStack!.payStackSecret.toString(), userModel: userModel.value)
        .then((value) async {
      if (value != null) {
        PayStackUrlModel payStackModel = value;
        Get.to(PayStackScreen(
          secretKey: paymentModel.value.payStack!.payStackSecret.toString(),
          callBackUrl: Constant.paymentCallbackURL.toString(),
          initialURl: payStackModel.data.authorizationUrl,
          amount: finalAmount.toString(),
          reference: payStackModel.data.reference,
        ))!
            .then((value) {
          if (value) {
            ShowToastDialog.showToast("Payment Successful!!");
            bookingModel.value.paymentStatus = true;

            completeOrder(DateTime.now().millisecondsSinceEpoch.toString());
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!");
          }
        });
      } else {
        ShowToastDialog.showToast("Something went wrong, please contact admin.");
      }
    });
  }

  // ::::::::::::::::::::::::::::::::::::::::::::Mercado Pago::::::::::::::::::::::::::::::::::::::::::::::::::::

  void mercadoPagoMakePayment({required BuildContext context, required String amount}) {
    int finalAmount = amount.toInt();

    makePreference(finalAmount.toString()).then((result) async {
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
                bookingModel.value.paymentStatus = true;

                completeOrder(DateTime.now().millisecondsSinceEpoch.toString());
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

  // ::::::::::::::::::::::::::::::::::::::::::::Pay Fast::::::::::::::::::::::::::::::::::::::::::::::::::::

  void payFastPayment({required BuildContext context, required String amount}) {
    int finalAmount = amount.toInt();

    PayStackURLGen.getPayHTML(payFastSettingData: paymentModel.value.payFast!, amount: finalAmount.toString(), userModel: userModel.value).then((String? value) async {
      bool isDone = await Get.to(PayFastScreen(htmlData: value!, payFastSettingData: paymentModel.value.payFast!));
      if (isDone) {
        Get.back();
        ShowToastDialog.showToast("Payment successfully");
        bookingModel.value.paymentStatus = true;

        completeOrder(DateTime.now().millisecondsSinceEpoch.toString());
      } else {
        Get.back();
        ShowToastDialog.showToast("Payment Failed");
      }
    });
  }
}

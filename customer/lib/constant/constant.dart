// ignore_for_file: strict_top_level_inference

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/app/models/admin_commission.dart';
import 'package:customer/app/models/booking_model.dart';
import 'package:customer/app/models/currencies_model.dart';
import 'package:customer/app/models/intercity_model.dart';
import 'package:customer/app/models/language_model.dart';
import 'package:customer/app/models/location_lat_lng.dart';
import 'package:customer/app/models/map_model.dart';
import 'package:customer/app/models/parcel_model.dart';
import 'package:customer/app/models/payment_method_model.dart';
import 'package:customer/app/models/tax_model.dart';
import 'package:customer/app/models/user_model.dart';
import 'package:customer/app/models/vehicle_type_model.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/extension/string_extensions.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../app/models/time_slots_charges_model.dart';
import '../utils/preferences.dart';

class Constant {
  // Login types
  static const String phoneLoginType = "phone";
  static const String googleLoginType = "google";
  static const String appleLoginType = "apple";

  // Asset URLs
  static const String profileConstant =
      "https://firebasestorage.googleapis.com/v0/b/gocab-a8627.appspot.com/o/constant_assets%2F59.png?alt=media&token=a0b1aebd-9c01-45f6-9569-240c4bc08e23";

  // User and app state
  static UserModel? userModel;
  static String mapAPIKey = "";
  static String senderId = "";
  static String jsonFileURL = "";
  static String radius = "10";
  static String distanceType = "km";
  static List<dynamic> cancellationReason = [];
  static String driverLocationUpdate = "10";
  static LocationLatLng? currentLocation;
  static bool isInterCityBid = false;
  static bool isParcelBid = false;
  static bool isInterCitySharingBid = false;

  // App info
  static String termsAndConditions = "";
  static String privacyPolicy = "";
  static String aboutApp = "";
  static String supportURL = "";
  static String minimumAmountToDeposit = "0.0";
  static String minimumAmountToWithdrawal = "0.0";
  static String? referralAmount = "0.0";
  static List<VehicleTypeModel>? vehicleTypeList;

  // Tax and country
  static List<TaxModel>? taxList;
  static String? country;
  static AdminCommission? adminCommission;

  // Currency
  static CurrencyModel? currencyModel;
  static PaymentModel? paymentModel;

  static const String placed = "placed";
  static const String onGoing = "onGoing";
  static const String completed = "completed";
  static const String canceled = "canceled";

  // static const globalUrl = "https://elaynetech.com";

  static String appName = '';
  static String? appColor;

  static String paymentCallbackURL = 'https://elaynetech.com/callback';

  static const String typeDriver = "driver";
  static const String typeCustomer = "customer";
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
  static final math.Random _rnd = math.Random();

  // RxList<IntercityDocumentModel> intercityDocuments = <IntercityDocumentModel>[].obs;

  // Separate lists for each document type
  static RxList<VehicleTypeModel> cabTimeSlotList = <VehicleTypeModel>[].obs;
  // static RxList<TimeSlotsChargesModel> cabDocuments = <TimeSlotsChargesModel>[].obs;
  static RxList<TimeSlotsChargesModel> parcelDocuments = <TimeSlotsChargesModel>[].obs;
  static RxList<TimeSlotsChargesModel> intercitySharingDocuments = <TimeSlotsChargesModel>[].obs;
  static RxList<TimeSlotsChargesModel> intercityPersonalDocuments = <TimeSlotsChargesModel>[].obs;

  static String getRandomString(int length) {
    String randomString = String.fromCharCodes(Iterable.generate(length - 1, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    // print("Random String :- $randomString");
    int underScorePosition = _rnd.nextInt(length);
    // print("UnderScore Position :- $underScorePosition");
    return '${randomString.substring(0, underScorePosition)}_${randomString.substring(underScorePosition)}';
  }

  static String amountToShow({required String? amount}) {
    if (Constant.currencyModel!.symbolAtRight == true) {
      return "${double.parse(amount.toString()).toStringAsFixed(Constant.currencyModel!.decimalDigits!)}${Constant.currencyModel!.symbol.toString()}";
    } else {
      return "${Constant.currencyModel!.symbol.toString()} ${double.parse(amount.toString()).toStringAsFixed(Constant.currencyModel!.decimalDigits!)}";
    }
  }

  static double amountCalculate(String amount, String distance) {
    double finalAmount = 0.0;
    finalAmount = double.parse(amount) * double.parse(distance);
    return finalAmount;
  }

  static double calculateTax({String? amount, TaxModel? taxModel}) {
    double taxAmount = 0.0;
    if (taxModel != null && taxModel.active == true) {
      if (taxModel.isFix == true) {
        taxAmount = double.parse(taxModel.value.toString());
      } else {
        taxAmount = (double.parse(amount.toString()) * double.parse(taxModel.value!.toString())) / 100;
      }
    }
    return taxAmount;
  }

  static String calculateReview({required String? reviewCount, required String? reviewSum}) {
    final double count = double.tryParse(reviewCount ?? "0") ?? 0;
    final double sum = double.tryParse(reviewSum ?? "0") ?? 0;

    if (count == 0 || sum == 0) {
      return "0.0";
    }

    return (sum / count).toStringAsFixed(1);
  }

  static const userPlaceHolder = 'assets/images/user_placeholder.png';

  static String getUuid() {
    return const Uuid().v4();
  }

  static Widget loader() {
    return const Center(
      child: CircularProgressIndicator(color: AppThemData.primary900),
    );
  }

  static Widget showEmptyView({required String message}) {
    return Center(
      child: Text(message, style: GoogleFonts.inter(fontSize: 18)),
    );
  }

  static String getOTPCode() {
    var rng = math.Random();
    return (rng.nextInt(900000) + 100000).toString();
  }

  static String formatDate(DateTime? date) {
    if (date == null) return "No Date Selected";
    return DateFormat("dd MMM yyyy").format(date);
  }

  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;

    try {
      return DateFormat("yyyy-MM-dd").parse(dateString);
    } catch (e) {
      return null;
    }
  }

  static Future<LanguageModel> getLanguage() async {
    final String language = await Preferences.getString(Preferences.languageCodeKey);
    if (language.isEmpty) {
      await Preferences.setString(
          Preferences.languageCodeKey, json.encode({"active": true, "code": "en", "id": "CcrGiUvJbPTXaU31s5l8", "name": "English"}));
      return LanguageModel.fromJson({"active": true, "code": "en", "id": "CcrGiUvJbPTXaU31s5l8", "name": "English"});
    }
    Map<String, dynamic> languageMap = jsonDecode(language);
    log(languageMap.toString());
    return LanguageModel.fromJson(languageMap);
  }

  String? validateRequired(String? value, String type) {
    if (value!.isEmpty) {
      return '$type required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  bool hasValidUrl(String value) {
    String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static InputDecoration defaultInputDecoration(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InputDecoration(
        iconColor: AppThemData.primary500,
        isDense: true,
        filled: true,
        fillColor: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
          ),
        ),
        hintText: "Select Brand",
        hintStyle: TextStyle(
          fontSize: 16,
          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
          fontWeight: FontWeight.w500,
        ));
  }

  static Future<String> uploadUserImageToFireStorage(File image, String filePath, String fileName) async {
    Reference upload = FirebaseStorage.instance.ref().child('$filePath/$fileName');
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static Future<List<String>> uploadSupportImage(List<String> images) async {
    var imageUrls = await Future.wait(images.map(
        (image) => uploadUserImageToFireStorage(File(image), "supportImages/${FireStoreUtils.getCurrentUid()}", File(image).path.split("/").last)));
    return imageUrls;
  }

  static Future<String> uploadPic(PickedFile image, String fileName, String filePath, String mimeType) async {
    UploadTask uploadTask;
    Reference ref = FirebaseStorage.instance.ref().child(fileName).child(filePath);

    uploadTask = ref.putData(
        await image.readAsBytes(),
        SettableMetadata(
          contentType: mimeType,
          customMetadata: {'picked-file-path': image.path},
        ));

    String url = await uploadTask.then((taskSnapshot) async {
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    });

    return url;
  }

  static Future<bool> isPermissionApplied() async {
    try {
      loc.Location location = loc.Location();
      loc.PermissionStatus permissionStatus = await location.hasPermission();

      if (permissionStatus == loc.PermissionStatus.granted) {
        if (Platform.isAndroid) {
          bool bgMode = await location.enableBackgroundMode(enable: true);
          return bgMode;
        } else {
          return true;
        }
      } else if (permissionStatus == loc.PermissionStatus.deniedForever) {
        // Permission has been denied forever; handle by directing the user to settings.
        await showDialogToOpenSettings();
        return false;
      } else {
        // If permission is denied, request it again.
        loc.PermissionStatus newStatus = await location.requestPermission();
        if (newStatus == loc.PermissionStatus.granted) {
          if (Platform.isAndroid) {
            bool bgMode = await location.enableBackgroundMode(enable: true);
            return bgMode;
          } else {
            return true;
          }
        }
        return false;
      }
    } catch (e) {
      // Handle the exception if something goes wrong.
      return false;
    }
  }

  static Future<void> showDialogToOpenSettings() async {
    // Ask the user to manually enable permissions from settings
    return Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.all(12),
        insetPadding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        title: const Text('Permission Required'),
        content: const Text('Location permission has been permanently denied. Please enable it in the app settings to continue.'),
        actions: [
          TextButton(
            onPressed: () async {
              Get.back();
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> commonLaunchUrl(String url, {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
    await launchUrl(Uri.parse(url), mode: launchMode).catchError((e) {
      // toast('Invalid URL: $url');
      throw e;
    });
  }

  void launchCall(String? url) {
    if (url!.validate().isNotEmpty) {
      if (Platform.isIOS) {
        commonLaunchUrl('tel://$url', launchMode: LaunchMode.externalApplication);
      } else {
        commonLaunchUrl('tel:$url', launchMode: LaunchMode.externalApplication);
      }
    }
  }

  static double amountBeforeTax(BookingModel bookingModel) {
    return (double.parse(bookingModel.subTotal ?? '0.0') - double.parse((bookingModel.discount ?? '0.0').toString()));
  }

  static double calculateFinalAmount(BookingModel bookingModel) {
    RxString taxAmount = "0.0".obs;
    for (var element in (bookingModel.taxList ?? [])) {
      taxAmount.value = (double.parse(taxAmount.value) +
              Constant.calculateTax(
                  amount: ((double.parse(bookingModel.subTotal ?? '0.0')) - double.parse((bookingModel.discount ?? '0.0').toString())).toString(),
                  taxModel: element))
          .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
    }
    return (double.parse(bookingModel.subTotal ?? '0.0') - double.parse((bookingModel.discount ?? '0.0').toString())) + double.parse(taxAmount.value);
  }

  static double calculateInterCityFinalAmount(IntercityModel interCityModel) {
    RxString taxAmount = "0.0".obs;
    for (var element in (interCityModel.taxList ?? [])) {
      taxAmount.value = (double.parse(taxAmount.value) +
              Constant.calculateTax(
                  amount: ((double.parse(interCityModel.subTotal ?? '0.0')) - double.parse((interCityModel.discount ?? '0.0').toString())).toString(),
                  taxModel: element))
          .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
    }
    return (double.parse(interCityModel.subTotal ?? '0.0') - double.parse((interCityModel.discount ?? '0.0').toString())) +
        double.parse(taxAmount.value);
  }

  static double calculateParcelFinalAmount(ParcelModel parcelModel) {
    RxString taxAmount = "0.0".obs;
    for (var element in (parcelModel.taxList ?? [])) {
      taxAmount.value = (double.parse(taxAmount.value) +
              Constant.calculateTax(
                  amount: ((double.parse(parcelModel.subTotal ?? '0.0')) - double.parse((parcelModel.discount ?? '0.0').toString())).toString(),
                  taxModel: element))
          .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
    }
    return (double.parse(parcelModel.subTotal ?? '0.0') - double.parse((parcelModel.discount ?? '0.0').toString())) + double.parse(taxAmount.value);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  static Future<MapModel?> getDurationDistance(LatLng departureLatLong, LatLng destinationLatLong) async {
    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json';
    http.Response distanceData = await http.get(Uri.parse('$url?units=metric&origins=${departureLatLong.latitude},'
        '${departureLatLong.longitude}&destinations=${destinationLatLong.latitude},${destinationLatLong.longitude}&key=${Constant.mapAPIKey}'));

    log(departureLatLong.toJson().toString());
    log(destinationLatLong.toJson().toString());
    log(distanceData.body.toString());
    MapModel mapModel = MapModel.fromJson(jsonDecode(distanceData.body));

    if (mapModel.status == 'OK' && mapModel.rows!.first.elements!.first.status == "OK") {
      return mapModel;
    } else {
      ShowToastDialog.showToast(mapModel.errorMessage);
    }
    return null;
  }

  static Future<LatLng?> getLatLongFromPlaceId(String placeId) async {
    String url = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=${Constant.mapAPIKey}';

    http.Response latLongData = await http.get(Uri.parse(url));
    log(latLongData.body.toString());
    Map<String, dynamic> responseData = json.decode(latLongData.body);

    if (responseData["status"] == 'OK') {
      return LatLng(responseData["result"]['geometry']['location']['lat'], responseData["result"]['geometry']['location']['lng']);
    } else {
      ShowToastDialog.showToast(responseData["error_message"]);
    }
    return null;
  }

  static Future<TimeOfDay?> selectTime(context) async {
    FocusScope.of(context).requestFocus(FocusNode()); //remove focus
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      return newTime;
    }
    return null;
  }

  static Future<DateTime?> selectDate(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppThemData.primary600, // header background color
                onPrimary: AppThemData.grey100, // header text color
                onSurface: AppThemData.grey100, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppThemData.grey100, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        initialDate: DateTime.now(),
        //get today's date
        firstDate: DateTime(2000),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));
    return pickedDate;
  }

  static String timestampToDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMM dd,yyyy').format(dateTime);
  }

  static String timestampToTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('HH:mm aa').format(dateTime);
  }

  static String timestampToDateChat(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String timestampToTime12Hour(Timestamp? timestamp) {
    DateTime dateTime = timestamp!.toDate();
    return DateFormat.jm().format(dateTime);
  }

  static double calculateAdminCommission({String? amount, AdminCommission? adminCommission}) {
    double taxAmount = 0.0;
    if (adminCommission != null && adminCommission.active == true) {
      if ((adminCommission.isFix ?? false)) {
        taxAmount = double.parse(adminCommission.value.toString());
      } else {
        taxAmount = (double.parse(amount.toString()) * double.parse(adminCommission.value!.toString())) / 100;
      }
    }
    return taxAmount;
  }

//   static String? googleMapStyle = '''
//     [
// {
//     "elementType": "labels.icon",
//     "stylers": [
//       {
//         "visibility": "on",
//         "color": "#4448AE"
//       }
//     ]
//   },
//    {
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#F3F6FF"
//       }
//     ]
//   },
//   {
//     "featureType": "road",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#E9ECFD"
//       }
//     ]
//   },
//   {
//     "featureType": "water",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#9e9e9e"
//       }
//     ]
//   },{
//     "featureType": "water",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#87CEEB"
//       }
//     ]
//   },
//    {
//     "featureType": "transit.line",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#e5e5e5"
//       }
//     ]
//   },
//   {
//     "featureType": "transit.station",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#eeeeee"
//       }
//     ]
//   }
//   ],
//     ''';
}

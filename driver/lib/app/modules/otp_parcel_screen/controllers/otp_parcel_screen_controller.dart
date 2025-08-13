// ignore_for_file: unnecessary_overrides

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/parcel_model.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/fire_store_utils.dart';

class OtpParcelScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  RxString otp = ''.obs;

  Future<bool> startBooking(ParcelModel bookingModels) async {
    ParcelModel bookingModel = bookingModels;
    bookingModel.bookingStatus = BookingStatus.bookingOngoing;
    bookingModel.updateAt = Timestamp.now();
    bookingModel.pickupTime = Timestamp.now();
    bool? isStarted = await FireStoreUtils.setParcelBooking(bookingModel);
    ShowToastDialog.showToast("Your parcel ride started....");
    if (isStarted == true) {
      UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(bookingModel.customerId.toString());
      if (receiverUserModel != null && receiverUserModel.fcmToken != null && receiverUserModel.fcmToken!.isNotEmpty) {
        Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel.id};
        await SendNotification.sendOneNotification(
          type: "order",
          token: receiverUserModel.fcmToken!,
          title: 'Your Ride is Started',
          customerId: receiverUserModel.id,
          senderId: FireStoreUtils.getCurrentUid(),
          bookingId: bookingModel.id.toString(),
          driverId: bookingModel.driverId.toString(),
          body: 'Your Parcel Ride is Started From ${bookingModel.pickUpLocationAddress.toString()} to ${bookingModel.dropLocationAddress.toString()}.',
          payload: playLoad,
        );
      }
    }
    return isStarted;
  }
}

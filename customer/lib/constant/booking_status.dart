import 'package:flutter/material.dart';

class BookingStatus {
  static const String bookingPlaced = "booking_placed";
  static const String driverAssigned = "driver_assigned";
  static const String bookingAccepted = "booking_accepted";
  static const String bookingOngoing = "booking_ongoing";
  static const String bookingCancelled = "booking_cancelled";
  static const String bookingCompleted = "booking_completed";
  static const String bookingRejected = "booking_rejected";

  static String getBookingStatusTitle(String status) {
    switch (status) {
      case (bookingPlaced || driverAssigned):
        return 'Placed';
      case bookingAccepted:
        return 'Accepted';
      case bookingOngoing:
        return 'Ongoing';
      case bookingCancelled:
        return 'Cancelled';
      case bookingCompleted:
        return 'Completed';
      case bookingRejected:
        return 'Rejected';
      default:
        return '';
    }
  }

  static Color getBookingStatusTitleColor(String status) {
    Color color = const Color(0xff9d9d9d);
    if (status == bookingPlaced || status == driverAssigned) {
      color = const Color(0xff9d9d9d);
    } else if (status == bookingAccepted) {
      color = const Color(0xff1EADFF);
    } else if (status == bookingOngoing) {
      color = const Color(0xffD19D00);
    } else if (status == bookingCancelled) {
      color = const Color(0xffFE7235);
    } else if (status == bookingCompleted) {
      color = const Color(0xff27C041);
    } else if (status == bookingRejected) {
      color = const Color(0xffFE7235);
    }
    return color;
  }
}

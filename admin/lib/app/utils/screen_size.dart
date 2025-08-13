// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

class ScreenSize {
  static double width(double size, BuildContext context) {
    return MediaQuery.of(context).size.width * (size / 100);
  }

  static double height(double size, BuildContext context) {
    return MediaQuery.of(context).size.height * (size / 100);
  }
}

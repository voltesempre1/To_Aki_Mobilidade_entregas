import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/lang/app_ar.dart';
import 'package:driver/lang/app_en.dart';
import 'package:driver/lang/app_pt.dart';

import '../lang/app_hi.dart';

class LocalizationService extends Translations {
  // Default locale
  static const locale = Locale('pt', 'BR');

  static final locales = [
    const Locale('en'),
    const Locale('pt', 'BR'),
    const Locale('hi'),
    const Locale('ar'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en': enUS,
        // 'fr': trFR,
        // 'zh': zhCH,
        // 'ja': jaJP,
        'hi': hiIN,
        // 'de': deGR,
        'pt': ptBR,
        'ar': lnAr,
      };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    if (lang == 'pt') {
      Get.updateLocale(const Locale('pt', 'BR'));
    } else {
      Get.updateLocale(Locale(lang));
    }
  }
}

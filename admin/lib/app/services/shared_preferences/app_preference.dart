import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreference {
  static final AppSharedPreference appSharedPreference = AppSharedPreference._internal();
  static const languageCodeKey = "languageCodeKey";

  factory AppSharedPreference() {
    return appSharedPreference;
  }

  AppSharedPreference._internal();

  static Future<String> getString(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? "";
  }

  static Future<void> setString(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

}

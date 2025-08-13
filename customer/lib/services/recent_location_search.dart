import 'dart:convert';

import 'package:customer/constant_widgets/place_picker/selected_location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchLocation {
  static const String _key = 'recent_searches';

  /// Add a single CategoryHistoryModel to the existing list
  static Future<void> addLocationInHistory(SelectedLocationModel newItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Load existing list
    List<String> jsonList = prefs.getStringList(_key) ?? [];
    // Convert to models
    List<SelectedLocationModel> rawList = jsonList.map((jsonStr) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
      return SelectedLocationModel.fromJson(jsonMap);
    }).toList();
    // Remove any existing item with the same slug
    rawList.removeWhere((item) => item.getFullAddress() == newItem.getFullAddress());
    // Add new item
    rawList.add(newItem);
    // Convert back to string list
    List<String> updatedJsonList = rawList.map((item) => jsonEncode(item.toJson())).toList();
    // Save
    await prefs.setStringList(_key, updatedJsonList);
  }

  /// Get the full list
  static Future<List<SelectedLocationModel>> getLocationFromHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(_key);
    if (jsonList == null) return [];
    // Parse list
    List<SelectedLocationModel> rawList = jsonList.map((jsonStr) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
      return SelectedLocationModel.fromJson(jsonMap);
    }).toList();
    // Remove duplicates by category ID
    final Map<String, SelectedLocationModel> uniqueMap = {};
    for (var item in rawList) {
      final categoryId = item.getFullAddress();
      // You can use name instead
      if (categoryId.isNotEmpty) {
        uniqueMap[categoryId] = item;
        // overwrite to keep the latest
      }
    }
    return uniqueMap.values.toList();
  }

  /// Optional: Clear the stored list
  static Future<void> clearLocationHistoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

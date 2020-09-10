import 'package:article_images/screens/SettingScreen.dart';
import 'package:article_images/utils/PrivacyDialogBuilder.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManger {
  static final _instance = SettingsManger._();

  SettingsManger._();

  factory SettingsManger() {
    return _instance;
  }

  bool requestRating;
  bool hideStreaks;

  init(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    requestRating =
        !(prefs.getBool(SettingsScreen.has_requested_rating) ?? false);

    hideStreaks = prefs.getBool(SettingsScreen.hide_streak) ?? false;

    if (!prefs.containsKey(SettingsScreen.use_analytics)) {
      FirebaseAnalytics().setAnalyticsCollectionEnabled(false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: buildPrivacyDialog,
      );
    }
  }
}

import 'package:article_images/screens/settings_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManger {
  static final _instance = SettingsManger._();

  SettingsManger._();

  factory SettingsManger() {
    return _instance;
  }

  bool requestRating;
  bool hideStreaks;
  bool askForAnalytics = false;
  String language;

  init(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    requestRating =
        !(prefs.getBool(SettingsScreen.has_requested_rating) ?? false);

    hideStreaks = prefs.getBool(SettingsScreen.hide_streak) ?? false;

    language = prefs.getString(SettingsScreen.language);

    if (language != null) {
      FlutterI18n.refresh(context, Locale(language));
    }

    if (!prefs.containsKey(SettingsScreen.use_analytics)) {
      FirebaseAnalytics().setAnalyticsCollectionEnabled(false);
      askForAnalytics = true;
    }
  }
}

import 'package:article_images/screens/settings_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildPrivacyDialog(context) {
  var loading = false;
  return AlertDialog(
    title: I18nText("privacy.title"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        I18nText("privacy.text"),
        SizedBox(height: 10),
        GestureDetector(
          child: Text(
            FlutterI18n.translate(context, "privacy.button"),
            style: TextStyle(
                decoration: TextDecoration.underline, color: Colors.blueGrey),
          ),
          onTap: () => launch(FlutterI18n.translate(context, "privacy.link")),
        )
      ],
    ),
    actions: <Widget>[
      StatefulBuilder(
        builder: (context, setState) => TextButton(
          onPressed: () async {
            setState(() => loading = true);
            final preferences = await SharedPreferences.getInstance();
            await preferences.setBool(SettingsScreen.use_analytics, false);
            FirebaseAnalytics().setAnalyticsCollectionEnabled(false);
            Navigator.pop(context);
          },
          child: !loading
              ? I18nText("privacy.deny")
              : Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  )),
        ),
      ),
      StatefulBuilder(
        builder: (context, setState) => TextButton(
          onPressed: () async {
            setState(() => loading = true);
            final preferences = await SharedPreferences.getInstance();
            await preferences.setBool(SettingsScreen.use_analytics, true);
            FirebaseAnalytics().setAnalyticsCollectionEnabled(true);
            Navigator.pop(context);
          },
          child: !loading
              ? I18nText("privacy.allow")
              : Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  )),
        ),
      ),
    ],
  );
}

import 'package:article_images/screens/SettingScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildPrivacyDialog(context) {
  var loading = false;
  return AlertDialog(
    title: Text("Hilf dabei diese App zu verbessern"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("""
Um die App zu verbessern, würden wir gerne Statistiken über dein Nutzerverhalten erfassen.
So verstehen wir besser, was unseren Nutzern wichtig ist und was wir noch verbessern können.
Diese Entscheidung kannst du jederzeit in den Einstellungen ändern."""),
        SizedBox(height: 10),
        GestureDetector(
          child: Text(
            "Datenschutzerklärung",
            style: TextStyle(
                decoration: TextDecoration.underline, color: Colors.blueGrey),
          ),
          onTap: () =>
              launch("http://skamps.eu/artikel-trainer/datenschutz.html"),
        )
      ],
    ),
    actions: <Widget>[
      StatefulBuilder(
        builder: (context, setState) => FlatButton(
          onPressed: () async {
            setState(() => loading = true);
            final preferences = await SharedPreferences.getInstance();
            await preferences.setBool(SettingsScreen.use_analytics, false);
            FirebaseAnalytics().setAnalyticsCollectionEnabled(false);
            Navigator.pop(context);
          },
          child: !loading
              ? Text("Nein")
              : Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  )),
        ),
      ),
      StatefulBuilder(
        builder: (context, setState) => FlatButton(
          onPressed: () async {
            setState(() => loading = true);
            final preferences = await SharedPreferences.getInstance();
            await preferences.setBool(SettingsScreen.use_analytics, true);
            FirebaseAnalytics().setAnalyticsCollectionEnabled(true);
            Navigator.pop(context);
          },
          child: !loading
              ? Text("Einverstanden")
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

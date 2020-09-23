import 'package:article_images/screens/settings_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildRatingDialog(context) {
  int rating;
  final time = DateTime.now();

  return AlertDialog(
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
          FirebaseAnalytics().logEvent(name: "rating", parameters: {
            'value': rating,
            'time_spent': DateTime.now().difference(time).inSeconds
          });
        },
        child: I18nText("rating.exit"),
      )
    ],
    content: SingleChildScrollView(
      child: StatefulBuilder(builder: (context, setState) {
        String text;

        if (rating != null) {
          text = FlutterI18n.translate(
              context, "rating.${rating <= 3 ? 'bad' : 'good'}Rating");
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              FlutterI18n.translate(context, "rating.title"),
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            Text(
              FlutterI18n.translate(context, "rating.text1"),
              style: TextStyle(fontSize: 17, color: Colors.grey.shade800),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              FlutterI18n.translate(context, "rating.text2"),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              FlutterI18n.translate(context, "rating.text3"),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SmoothStarRating(
              allowHalfRating: false,
              borderColor: Colors.yellow.shade700,
              color: Colors.yellow.shade600,
              size: 35,
              onRated: (val) => setState(() => rating = val.round()),
            ),
            if (text != null)
              ClipRect(
                child: TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 150),
                  curve: Curves.easeIn,
                  builder: (_, value, __) {
                    return Opacity(
                      opacity: value,
                      child: Align(
                        heightFactor: value,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              text,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RaisedButton(
                                onPressed: () => launch(rating <= 3
                                    ? "mailto:leoko4433@gmail.com?subject=Hey%20Leo!"
                                    : "https://play.google.com/store/apps/details?id=io.leokogar.article_images"),
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(rating <= 3 ? Icons.mail : Icons.star),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    I18nText(rating <= 3
                                        ? "rating.mail"
                                        : "rating.store"),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
          ],
        );
      }),
    ),
  );
}

void showRatingDialog(context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(SettingsScreen.has_requested_rating, true);
  showDialog(
      context: context,
      builder: (context) => buildRatingDialog(context),
      barrierDismissible: false);
}

import 'package:article_images/screens/settings_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
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
          child: Text("Abbrechen"))
    ],
    content: SingleChildScrollView(
      child: StatefulBuilder(builder: (context, setState) {
        String text;

        if (rating != null) {
          if (rating <= 3)
            text =
                "Schade, lass uns was daran ändern! Schreib mir gerne eine eMail was dir nicht gefällt oder was wir noch besser machen können.";
          else
            text =
                "Das freut mich zu hören! Wärst du bereit deine Meinung mit der Welt zu teilen und uns im Play-Store zu bewerten?";
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "STARKE LEISTUNG",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            Text(
              "Du wirst immer besser!",
              style: TextStyle(fontSize: 17, color: Colors.grey.shade800),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Wenn es dir gerade passt, würde es mich freuen deine Meinung zu dieser App zu hören.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Wie würdest du die App bist jetzt bewerten?",
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
                                    Text(rating <= 3
                                        ? "eMail schreiben"
                                        : "Im Store bewerten"),
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

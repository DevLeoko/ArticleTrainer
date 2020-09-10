import 'package:article_images/manager/settings_manager.dart';
import 'package:article_images/screens/home_screen.dart';
import 'package:article_images/widgets/background.dart';
import 'package:article_images/widgets/home_button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({Key key}) : super(key: key);
  static const hide_streak = "settings_hide_streak";
  static const use_analytics = "use_analytics";
  static const has_requested_rating = "has_requested_rating";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Center(
            child: Hero(
              tag: "SettingsTrans",
              flightShuttleBuilder: HomeScreen.roundedFlightShuttleBuild,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.5,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black38,
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Einstellungen",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      ToggleSetting(
                        name: "Zeige Streaks",
                        tag: hide_streak,
                        inverted: true,
                        defaultValue: true,
                        callback: (val) => SettingsManger().hideStreaks = !val,
                      ),
                      ToggleSetting(
                          name: "Sende Analytics",
                          tag: use_analytics,
                          defaultValue: false,
                          callback: (val) => FirebaseAnalytics()
                              .setAnalyticsCollectionEnabled(val)),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Entwickler",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceAround,
                        spacing: 10,
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: null,
                            backgroundColor: Colors.blue.shade400,
                            child: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Image.asset(
                                "assets/twitter.png",
                              ),
                            ),
                            onPressed: () =>
                                launch("https://twitter.com/LeokoGar"),
                          ),
                          FloatingActionButton(
                            heroTag: null,
                            backgroundColor: Colors.orange.shade400,
                            child: Icon(Icons.mail),
                            onPressed: () => launch(
                                "mailto:leoko4433@gmail.com?subject=Hey%20Leo!"),
                          ),
                          FloatingActionButton(
                            heroTag: null,
                            backgroundColor: Colors.green.shade400,
                            child: Icon(Icons.web),
                            onPressed: () => launch("https://skamps.eu"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Dir gefällt die App?",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () => launch(
                            "https://play.google.com/store/apps/details?id=io.leokogar.article_images"),
                        child: Text("SAG UNS DEINE MEINUNG"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: 15,
                          children: <Widget>[
                            GestureDetector(
                              child: Text(
                                "Datenschutz",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () => launch(
                                  "http://skamps.eu/artikel-trainer/datenschutz.html"),
                            ),
                            GestureDetector(
                              child: Text(
                                "Impressum",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () => launch(
                                  "http://skamps.eu/artikel-trainer/impressum.html"),
                            ),
                            GestureDetector(
                              child: Text(
                                "App Info",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () => showAboutDialog(
                                context: context,
                                applicationIcon: Image.asset(
                                  "assets/images/icon.png",
                                  scale: 4,
                                ),
                                applicationName:
                                    "Der Die Das - Artikel mit Bildern lernen",
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          HomeButton()
        ],
      ),
    );
  }
}

class ToggleSetting extends StatelessWidget {
  const ToggleSetting(
      {Key key,
      @required this.name,
      @required this.tag,
      this.inverted = false,
      @required this.defaultValue,
      this.callback})
      : super(key: key);

  final String name;
  final String tag;
  final bool inverted;
  final bool defaultValue; // not inverted
  final Function(bool) callback; // not inverted

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              SharedPreferences prefs = snapshot.data;
              return StatefulBuilder(
                builder: (_, setState) {
                  return Switch(
                    value: inverted
                        ? !(prefs.getBool(tag) ?? !defaultValue)
                        : prefs.getBool(tag) ?? defaultValue,
                    onChanged: (val) => prefs
                        .setBool(tag, inverted ? !val : val)
                        .then((_) => setState(() {
                              if (callback != null) callback(val);
                            })),
                  );
                },
              );
            } else {
              return Switch(value: false, onChanged: null);
            }
          },
        ),
        Text(
          name,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }
}

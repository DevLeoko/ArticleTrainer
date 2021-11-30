import 'package:article_images/manager/settings_manager.dart';
import 'package:article_images/screens/home_screen.dart';
import 'package:article_images/utils/styles.dart';
import 'package:article_images/widgets/background.dart';
import 'package:article_images/widgets/home_button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsScreen({Key? key}) : super(key: key);
  static const hide_streak = "settings_hide_streak";
  static const use_analytics = "use_analytics";
  static const has_requested_rating = "has_requested_rating";
  static const language = "language";
  static const sounds = "sounds";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final cLang = FlutterI18n.currentLocale(context)?.languageCode;

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
                        FlutterI18n.translate(context, "settings.title"),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      ToggleSetting(
                        name: FlutterI18n.translate(
                            context, "settings.showStreaks"),
                        tag: SettingsScreen.hide_streak,
                        inverted: true,
                        defaultValue: true,
                        callback: (val) => SettingsManger().hideStreaks = !val,
                      ),
                      ToggleSetting(
                        name: FlutterI18n.translate(context, "settings.sounds"),
                        tag: SettingsScreen.sounds,
                        inverted: false,
                        defaultValue: true,
                        callback: (val) => SettingsManger().sounds = val,
                      ),
                      ToggleSetting(
                          name: FlutterI18n.translate(
                              context, "settings.sendAnalytics"),
                          tag: SettingsScreen.use_analytics,
                          defaultValue: false,
                          callback: (val) => FirebaseAnalytics()
                              .setAnalyticsCollectionEnabled(val)),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        FlutterI18n.translate(context, "settings.language"),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceAround,
                        runAlignment: WrapAlignment.spaceAround,
                        spacing: 15,
                        children: [
                          for (final lang in ["de", "en"])
                            GestureDetector(
                              onTap: () async {
                                await FlutterI18n.refresh(
                                    context, Locale(lang));

                                await SharedPreferences.getInstance().then(
                                    (prefs) => prefs.setString(
                                        SettingsScreen.language, lang));

                                setState(() {});
                              },
                              child: Container(
                                child: Image.asset(
                                  "assets/images/$lang.png",
                                  scale: 2,
                                ),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: lang == cLang
                                      ? flatBlue
                                      : Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        FlutterI18n.translate(context, "settings.aboutDev"),
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
                        FlutterI18n.translate(context, "settings.rateUsTitle"),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        onPressed: () => launch(
                            "https://play.google.com/store/apps/details?id=io.leokogar.article_images"),
                        child: Text(FlutterI18n.translate(
                            context, "settings.rateUsAction")),
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
                                FlutterI18n.translate(
                                    context, "settings.privacy"),
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () => launch(FlutterI18n.translate(
                                  context, "settings.privacyLink")),
                            ),
                            GestureDetector(
                              child: Text(
                                FlutterI18n.translate(
                                    context, "settings.imprint"),
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () => launch(FlutterI18n.translate(
                                  context, "settings.imprintLink")),
                            ),
                            GestureDetector(
                              child: Text(
                                FlutterI18n.translate(
                                    context, "settings.appInfo"),
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () => showAboutDialog(
                                context: context,
                                applicationIcon: Image.asset(
                                  "assets/images/icon.png",
                                  scale: 4,
                                ),
                                applicationName: FlutterI18n.translate(
                                    context, "settings.appTitle"),
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
      {Key? key,
      required this.name,
      required this.tag,
      this.inverted = false,
      required this.defaultValue,
      this.callback})
      : super(key: key);

  final String name;
  final String tag;
  final bool inverted;
  final bool defaultValue; // not inverted
  final Function(bool)? callback; // not inverted

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              SharedPreferences prefs = snapshot.data!;
              return StatefulBuilder(
                builder: (_, setState) {
                  return Switch(
                    value: inverted
                        ? !(prefs.getBool(tag) ?? !defaultValue)
                        : prefs.getBool(tag) ?? defaultValue,
                    onChanged: (val) => prefs
                        .setBool(tag, inverted ? !val : val)
                        .then((_) => setState(() {
                              if (callback != null) callback!(val);
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

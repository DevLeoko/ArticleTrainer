import 'package:article_trainer/manager/challenge_manager.dart';
import 'package:article_trainer/manager/settings_manager.dart';
import 'package:article_trainer/screens/challenge_select_screen.dart';
import 'package:article_trainer/screens/settings_screen.dart';
import 'package:article_trainer/screens/play_screen.dart';
import 'package:article_trainer/utils/article.dart';
import 'package:article_trainer/utils/privacy_dialog_builder.dart';
import 'package:article_trainer/widgets/background.dart';
import 'package:article_trainer/widgets/challenge_button.dart';
import 'package:article_trainer/widgets/language_unlock_dialog.dart';
import 'package:article_trainer/widgets/theme_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  static final roundedFlightShuttleBuild = (BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext) =>
      Material(
        child: toHeroContext.widget,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (SettingsManger().askForAnalytics) {
      SettingsManger().askForAnalytics = false;
      Future.delayed(
        Duration.zero,
        () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: buildPrivacyDialog,
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Center(
            child: Flex(
              direction:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? Axis.horizontal
                      : Axis.vertical,
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: "MainLogo",
                  child: Center(
                    child: Image.asset(
                      "assets/images/icon.png",
                      scale: 1.6,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 10,
                ),
                Container(
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Hero(
                        tag: "WordView",
                        child: Container(
                          height: 60,
                          child: ThemeButton(
                            color: Article.der.color(),
                            text: FlutterI18n.translate(context, "home.begin"),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(PlayScreen.routeName);
                              SettingsManger().playSound("tap");
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Hero(
                        tag:
                            "${ChallengeButton.heroTagPrefx}${ChallengeManager.toDayCodeFromDate(DateTime.now())}",
                        child: Container(
                          height: 60,
                          child: ThemeButton(
                            color: Article.die.color(),
                            text: FlutterI18n.translate(
                                context, "home.dailyChallange"),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(ChallengeSelectScreen.routeName);
                              SettingsManger().playSound("tap");
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Hero(
                        tag: "SettingsTrans",
                        child: Container(
                          height: 60,
                          child: ThemeButton(
                            color: Article.das.color(),
                            text:
                                FlutterI18n.translate(context, "home.settings"),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(SettingsScreen.routeName);
                              SettingsManger().playSound("tap");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

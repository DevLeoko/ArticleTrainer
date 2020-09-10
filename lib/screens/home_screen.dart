import 'package:article_images/screens/settings_screen.dart';
import 'package:article_images/screens/play_screen.dart';
import 'package:article_images/utils/article.dart';
import 'package:article_images/widgets/background.dart';
import 'package:article_images/widgets/theme_button.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Center(
            child: Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  ),
                  Hero(
                    tag: "WordView",
                    child: Container(
                      height: 60,
                      child: ThemeButton(
                        color: Article.der.color(),
                        text: "Anfangen",
                        onPressed: () => Navigator.of(context)
                            .pushNamed(PlayScreen.routeName),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 60,
                    child: ThemeButton(
                      color: Article.die.color(),
                      text: "Tägliche Challange",
                      onPressed: () => {},
                    ),
                  ),
                  SizedBox(height: 20),
                  Hero(
                    tag: "SettingsTrans",
                    child: Container(
                      height: 60,
                      child: ThemeButton(
                        color: Article.das.color(),
                        text: "Einstellungen",
                        onPressed: () => Navigator.of(context)
                            .pushNamed(SettingsScreen.routeName),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

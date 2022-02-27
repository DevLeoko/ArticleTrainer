import 'package:article_trainer/screens/challenge_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'screens/challenge_select_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/home_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/play_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Article Trainer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            basePath: "assets/locales",
            fallbackFile: "en",
            useCountryCode: false,
            decodeStrategies: [YamlDecodeStrategy()],
          ),
          missingTranslationHandler: (key, locale) {
            print(
                "--- Missing Key: $key, languageCode: ${locale?.languageCode}");
          },
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        Locale('de'),
        Locale('en'),
      ],
      onGenerateRoute: (settings) {
        if (settings.name == ChallengePlayScreen.routeName) {
          return MaterialPageRoute<int>(
            builder: (context) {
              return ChallengePlayScreen(
                words: (settings.arguments as Map)['words'],
                heroTag: (settings.arguments as Map)['tag'],
              );
            },
          );
        }

        final routes = <String, WidgetBuilder>{
          "/": (ctx) => LoadingScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          PlayScreen.routeName: (ctx) => PlayScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          ChallengeSelectScreen.routeName: (ctx) => ChallengeSelectScreen()
        };
        WidgetBuilder builder = routes[settings.name]!;
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
    );
  }
}

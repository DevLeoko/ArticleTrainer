import 'package:article_images/screens/challenge_play_screen.dart';
import 'package:flutter/material.dart';

import 'screens/challenge_select_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/home_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/play_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Article Trainer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
    );
  }
}

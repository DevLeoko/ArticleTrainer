import 'package:article_images/screens/SettingScreen.dart';
import 'package:flutter/material.dart';

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
        routes: {
          '/': (context) => LoadingScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          PlayScreen.routeName: (context) => PlayScreen(),
          SettingsScreen.routeName: (context) => SettingsScreen()
        });
  }
}

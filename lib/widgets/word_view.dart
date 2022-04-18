import 'dart:typed_data';

import 'package:article_trainer/manager/settings_manager.dart';
import 'package:article_trainer/utils/language_select_dialog_builder.dart';
import 'package:article_trainer/widgets/language_unlock_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:article_trainer/utils/article.dart';
import 'package:article_trainer/utils/word.dart';

import 'package:http/http.dart' as http;

import '../screens/settings_screen.dart';

class WordView extends StatefulWidget {
  const WordView({
    Key? key,
    required this.size,
    required this.word,
    required this.solved,
  }) : super(key: key);

  final double size;
  final Word word;
  final bool solved;

  @override
  State<WordView> createState() => _WordViewState();
}

class _WordViewState extends State<WordView> {
  bool translated = false;
  Future<String>? translation;

  Future<String> _queryTranslation(String orgWordText) {
    return translation ??= http
        .get(Uri.https("us-central1-app-2b1a.cloudfunctions.net", "/main", {
          "translate": "true",
          "word": orgWordText,
          "lang": SettingsManger().translationLanguage
        }))
        .timeout(Duration(seconds: 6))
        .then((value) => value.body);
  }

  _toggleTranslation() {
    if (!SettingsManger().unlockedTranslation) {
      showLanguageSelectDialog(context);

      SettingsManger().unlockedTranslation = true;
      SharedPreferences.getInstance().then(
          (prefs) => prefs.setBool(SettingsScreen.unlocked_translation, true));
      return;
    }

    setState(() {
      translated = !translated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: FutureBuilder<Uint8List>(
            future: widget.word.cachedImage,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                if (snapshot.hasData) {
                  return Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.srcOver,
                    color: Colors.black12,
                  );
                } else {
                  return new Icon(
                    Icons.warning,
                    size: widget.size * 0.7,
                    color: Colors.red,
                  );
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.solved)
                  ClipRect(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400),
                      curve: Curves.bounceOut,
                      builder: (_, value, __) {
                        return Align(
                          widthFactor: value,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, right: 7),
                            child: Text(
                              widget.word.article.name(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                Flexible(
                  child: FittedBox(
                    child: translated
                        ? FutureBuilder<String>(
                            future: _queryTranslation(widget.word.word),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.waiting) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  );
                                } else {
                                  return new Icon(
                                    Icons.warning,
                                    size: 30,
                                    color: Colors.red,
                                  );
                                }
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          )
                        : Text(
                            widget.word.word,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: IconButton(
            onPressed: _toggleTranslation,
            icon: Icon(Icons.translate),
            iconSize: 23,
            color: Colors.white54,
          ),
        ),
        Positioned(
          bottom: 5,
          left: 10,
          child: Container(
            width: widget.size,
            child: Wrap(
              children: <Widget>[
                Text(
                  FlutterI18n.translate(context, "quiz.imageCredit.t1"),
                  style: TextStyle(color: Colors.white70),
                ),
                GestureDetector(
                  onTap: () => launch(widget.word.image.userLink),
                  child: Text(
                    widget.word.image.username,
                    style: TextStyle(
                        color: Colors.white70,
                        decoration: TextDecoration.underline),
                  ),
                ),
                Text(
                  FlutterI18n.translate(context, "quiz.imageCredit.t2"),
                  style: TextStyle(color: Colors.white70),
                ),
                GestureDetector(
                  onTap: () => launch("https://unsplash.com/"),
                  child: Text(
                    "Unspash",
                    style: TextStyle(
                        color: Colors.white70,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

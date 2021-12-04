import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:article_images/utils/article.dart';
import 'package:article_images/utils/word.dart';

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

  @override
  Widget build(BuildContext context) {
    var orgWordText = widget.word.article.name();
    var wortTextFuture;
    if (translated) {
      var translator = GoogleMlKit.nlp.onDeviceTranslator(
          sourceLanguage: TranslateLanguage.GERMAN,
          targetLanguage: TranslateLanguage.ENGLISH);
      wortTextFuture = translator.translateText(orgWordText);
    } else {
      wortTextFuture = Future.value(orgWordText);
    }

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
                            child: FutureBuilder<String>(
                              future: wortTextFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.waiting) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w400,
                                      ),
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
                        );
                      },
                    ),
                  ),
                Flexible(
                  child: FittedBox(
                    child: Text(
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
            onPressed: () {
              setState(() {
                translated = !translated;
              });
            },
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

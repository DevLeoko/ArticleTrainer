import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:article_images/utils/article.dart';
import 'package:article_images/utils/word.dart';

class WordView extends StatelessWidget {
  const WordView({
    Key key,
    @required this.size,
    @required this.word,
    @required this.solved,
  }) : super(key: key);

  final double size;
  final Word word;
  final bool solved;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: FutureBuilder(
              future: word.cachedImage,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting) {
                  if (snapshot.hasData) {
                    return Image.memory(
                      snapshot.data,
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.srcOver,
                      color: Colors.black12,
                    );
                  } else {
                    return new Icon(
                      Icons.warning,
                      size: size * 0.7,
                      color: Colors.red,
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            )),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (solved)
                  ClipRect(
                    child: TweenAnimationBuilder(
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
                              word.article.name(),
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
                    child: Text(
                      word.word,
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
          bottom: 5,
          left: 10,
          child: Container(
            width: size,
            child: Wrap(
              children: <Widget>[
                Text(
                  FlutterI18n.translate(context, "quiz.imageCredit.t1"),
                  style: TextStyle(color: Colors.white70),
                ),
                GestureDetector(
                  onTap: () => launch(word.image.userLink),
                  child: Text(
                    word.image.username,
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

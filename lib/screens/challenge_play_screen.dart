import 'package:article_images/manager/challenge_manager.dart';
import 'package:article_images/utils/styles.dart';
import 'package:article_images/utils/word.dart';
import 'package:article_images/widgets/interactive_base.dart';
import 'package:article_images/widgets/quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ChallengePlayScreen extends StatefulWidget {
  static const routeName = '/challenge/play';
  final List<Word> words;
  final String heroTag;

  ChallengePlayScreen({Key key, @required this.words, @required this.heroTag})
      : super(key: key);

  @override
  _ChallengePlayScreenState createState() => _ChallengePlayScreenState();
}

class _ChallengePlayScreenState extends State<ChallengePlayScreen> {
  int _index = 0;
  List<bool> _correct = [];

  Word _getNextWord(initial) {
    return widget.words.length > _index ? widget.words[_index++] : null;
  }

  _guess(bool success) {
    setState(() {
      _correct.add(success);
    });
  }

  _done() {
    Navigator.pop(context, _correct.where((element) => !element).length);
  }

  Future<bool> _confirmExit() async {
    if (_correct.length == ChallengeManager.challengeSize) {
      _done();
      return false;
    }

    return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: I18nText("challenge.exitConfirm.title"),
            content: I18nText("challenge.exitConfirm.text"),
            actions: <Widget>[
              FlatButton(
                child: I18nText("challenge.exitConfirm.stay"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: I18nText("challenge.exitConfirm.exit"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> statusBar = [];

    for (var i = 0; i < ChallengeManager.challengeSize; i++) {
      var barColor = Colors.grey.shade200;

      if (_correct.length > i) {
        barColor = (_correct[i] ? Colors.greenAccent.shade400 : flatRed);
      }

      statusBar.add(
        Flexible(
          child: Container(
            height: 28,
            color: barColor,
          ),
        ),
      );
    }

    double size = getQuizSize(context);
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    );

    return WillPopScope(
      onWillPop: _confirmExit,
      child: InteractiveBase(
        closeButton: true,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: Offset(
                      MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? -(size / 3.5 + 40) / 2
                          : 0,
                      20),
                  child: Container(
                    width: size,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black26,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: borderRadius,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: statusBar,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35, top: 0),
                  child: Quiz(
                    guessCallback: _guess,
                    wordSupplier: _getNextWord,
                    doneCallback: _done,
                    heroTag: widget.heroTag,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

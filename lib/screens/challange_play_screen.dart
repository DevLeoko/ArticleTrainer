import 'package:article_images/manager/challange_manager.dart';
import 'package:article_images/utils/styles.dart';
import 'package:article_images/utils/word.dart';
import 'package:article_images/widgets/interactive_base.dart';
import 'package:article_images/widgets/quiz.dart';
import 'package:flutter/material.dart';

class ChallangePlayScreen extends StatefulWidget {
  static const routeName = '/challange/play';
  final List<Word> words;
  final String heroTag;

  ChallangePlayScreen({Key key, @required this.words, @required this.heroTag})
      : super(key: key);

  @override
  _ChallangePlayScreenState createState() => _ChallangePlayScreenState();
}

class _ChallangePlayScreenState extends State<ChallangePlayScreen> {
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
    if (_correct.length == ChallangeManager.challangeSize) {
      _done();
      return false;
    }

    return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sicher, dass du abbrechen willst?"),
            content: Text(
                'Wenn du die Challange frühzeitig verlässt, wird sie so gewertet, wie wenn du alle Artikel falsch geraten hättest.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Bleiben'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Ja, verlassen'),
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

    for (var i = 0; i < ChallangeManager.challangeSize; i++) {
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

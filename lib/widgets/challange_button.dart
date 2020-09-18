import 'dart:math';

import 'package:article_images/manager/challange_manager.dart';
import 'package:article_images/screens/challange_play_screen.dart';
import 'package:article_images/utils/styles.dart';
import 'package:article_images/utils/word.dart';
import 'package:flutter/material.dart';

import 'package:article_images/widgets/month_view.dart';

class ChallangeButton extends StatefulWidget {
  static const String heroTagPrefx = "chal_btn_tag_";
  final int year, month, day;

  const ChallangeButton(
      {Key key, @required this.year, @required this.month, @required this.day})
      : super(key: key);

  @override
  _ChallangeButtonState createState() => _ChallangeButtonState();
}

class _ChallangeButtonState extends State<ChallangeButton> {
  bool loading = false;

  _startChallange() async {
    setState(() {
      loading = true;
    });

    final dayCode =
        ChallangeManager.toDayCode(widget.year, widget.month, widget.day);

    List<Word> words;
    try {
      words = await ChallangeManager().startChallange(dayCode);
      await words[0].cachedImage;
    } catch (exc) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Fehler 😔"),
          content: Text(
              "Die Challange konnte leider nicht gelanden werden. Überprüfe deine Internetverbindung und versuche es sonst später erneut."),
          actions: [
            FlatButton(
              child: Text("Okay"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );

      setState(() {
        loading = false;
      });

      return;
    }

    int fails = await Navigator.of(context)
        .pushNamed(ChallangePlayScreen.routeName, arguments: {
      'words': words,
      'tag': "${ChallangeButton.heroTagPrefx}$dayCode"
    });

    if (fails != null) {
      await ChallangeManager().completeChallange(dayCode, fails);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayCode =
        ChallangeManager.toDayCode(widget.year, widget.month, widget.day);
    final currentDayCode = ChallangeManager.toDayCodeFromDate(now);
    final challangeData = ChallangeManager().getData(dayCode);

    final available = now.year > widget.year ||
        (now.year == widget.year && now.month > widget.month) ||
        (now.year == widget.year &&
            now.month == widget.month &&
            now.day >= widget.day);

    final notToday = challangeData?.lastTry == currentDayCode;

    var color = Colors.white;

    if (now.year == widget.year &&
        now.month == widget.month &&
        now.day == widget.day) color = flatBlue;

    if (challangeData != null) {
      final fails = challangeData.fails;
      if (fails == 0)
        color = flatGreen;
      else if (fails <= 3)
        color = flatOrange;
      else
        color = flatRed;
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Hero(
        tag: "${ChallangeButton.heroTagPrefx}$dayCode",
        child: Container(
          width: MonthView.boxWidth - 10,
          height: MonthView.boxWidth - 10,
          child: RaisedButton(
            child: loading
                ? CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      color == Colors.white ? Colors.blue : Colors.white,
                    ),
                  )
                : null,
            padding: EdgeInsets.all(5),
            elevation: notToday ? 1 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            color: color,
            onPressed: available
                ? () {
                    if (!loading) {
                      if (notToday) {
                        showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text(
                                "Du hast diese Challange heute schon versucht!"),
                            content: Text(
                                "Jede Challange kann nur einmal am Tag probiert werden. Probiere es morgen dann noch nochmal 👍"),
                            actions: [
                              FlatButton(
                                child: Text("Okay!"),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            ],
                          ),
                        );
                      } else {
                        _startChallange();
                      }
                    }
                  }
                : null,
          ),
        ),
      ),
    );
  }
}

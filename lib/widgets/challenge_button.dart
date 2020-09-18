import 'package:article_images/manager/challenge_manager.dart';
import 'package:article_images/screens/challenge_play_screen.dart';
import 'package:article_images/utils/styles.dart';
import 'package:article_images/utils/word.dart';
import 'package:flutter/material.dart';

import 'package:article_images/widgets/month_view.dart';

class ChallengeButton extends StatefulWidget {
  static const String heroTagPrefx = "chal_btn_tag_";
  final int year, month, day;

  const ChallengeButton(
      {Key key, @required this.year, @required this.month, @required this.day})
      : super(key: key);

  @override
  _ChallengeButtonState createState() => _ChallengeButtonState();
}

class _ChallengeButtonState extends State<ChallengeButton> {
  bool loading = false;

  _startChallenge() async {
    setState(() {
      loading = true;
    });

    final dayCode =
        ChallengeManager.toDayCode(widget.year, widget.month, widget.day);

    List<Word> words;
    try {
      words = await ChallengeManager().startChallenge(dayCode);
      await words[0].cachedImage;
    } catch (exc) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Fehler 😔"),
          content: Text(
              "Die Challenge konnte leider nicht gelanden werden. Überprüfe deine Internetverbindung und versuche es sonst später erneut."),
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
        .pushNamed(ChallengePlayScreen.routeName, arguments: {
      'words': words,
      'tag': "${ChallengeButton.heroTagPrefx}$dayCode"
    });

    if (fails != null) {
      await ChallengeManager().completeChallenge(dayCode, fails);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayCode =
        ChallengeManager.toDayCode(widget.year, widget.month, widget.day);
    final currentDayCode = ChallengeManager.toDayCodeFromDate(now);
    final challengeData = ChallengeManager().getData(dayCode);

    final available = now.year > widget.year ||
        (now.year == widget.year && now.month > widget.month) ||
        (now.year == widget.year &&
            now.month == widget.month &&
            now.day >= widget.day);

    final notToday = challengeData?.lastTry == currentDayCode;

    var color = Colors.white;

    if (now.year == widget.year &&
        now.month == widget.month &&
        now.day == widget.day) color = flatBlue;

    if (challengeData != null) {
      final fails = challengeData.fails;
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
        tag: "${ChallengeButton.heroTagPrefx}$dayCode",
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
                                "Du hast diese Challenge heute schon versucht!"),
                            content: Text(
                                "Jede Challenge kann nur einmal am Tag probiert werden. Probiere es morgen dann nochmal 👍"),
                            actions: [
                              FlatButton(
                                child: Text("Okay!"),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            ],
                          ),
                        );
                      } else {
                        _startChallenge();
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

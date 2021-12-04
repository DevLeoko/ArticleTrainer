import 'package:article_images/manager/challenge_manager.dart';
import 'package:article_images/screens/challenge_play_screen.dart';
import 'package:article_images/utils/styles.dart';
import 'package:article_images/utils/word.dart';
import 'package:flutter/material.dart';

import 'package:article_images/widgets/month_view.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ChallengeButton extends StatefulWidget {
  static const String heroTagPrefx = "chal_btn_tag_";
  final int year, month, day;

  const ChallengeButton(
      {Key? key, required this.year, required this.month, required this.day})
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
      print(exc);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: I18nText("challenge.error"),
          content: I18nText("challenge.errorText"),
          actions: [
            TextButton(
              child: I18nText("challenge.errorAck"),
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

    int? fails = await Navigator.of(context)
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
          child: ElevatedButton(
            child: loading
                ? CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      color == Colors.white ? Colors.blue : Colors.white,
                    ),
                  )
                : null,
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.all(5)),
              elevation: MaterialStateProperty.all(notToday ? 1 : 2),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
              backgroundColor: MaterialStateProperty.all(color),
            ),
            onPressed: available
                ? () {
                    if (!loading) {
                      if (notToday) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: I18nText("challenge.onceADay"),
                            content: I18nText("challenge.onceADayText"),
                            actions: [
                              TextButton(
                                child: I18nText("challenge.onceADayAck"),
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

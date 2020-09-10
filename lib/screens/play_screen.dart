import 'package:article_images/manager/analytics.dart';
import 'package:article_images/manager/score_manager.dart';
import 'package:article_images/manager/settings_manager.dart';
import 'package:article_images/utils/RatingDialogBuilder.dart';
import 'package:article_images/utils/Word.dart';
import 'package:article_images/utils/WordDataStore.dart';
import 'package:article_images/widgets/ScoreView.dart';
import 'package:article_images/widgets/interactive_base.dart';
import 'package:article_images/widgets/quiz.dart';
import 'package:flutter/material.dart';

class PlayScreen extends StatefulWidget {
  static const routeName = '/play';

  PlayScreen({Key key}) : super(key: key);

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  List<Word> lastUsed = [];
  int analyticsBarrier = 0;
  bool failure = false;

  Word _getNextWord(initial) {
    if (!initial && mounted) {
      //TODO why do I need initial?!
      setState(() {
        failure = false;
      });
    }

    final word = WordDataStore().words.reduce((w1, w2) {
      if (lastUsed.contains(w2))
        return w1;
      else if (lastUsed.contains(w1)) return w2;

      return w1.guessRate > w2.guessRate ? w2 : w1;
    });

    lastUsed.add(word);
    if (lastUsed.length >= 13) lastUsed.removeAt(0);

    return word;
  }

  _guess(bool success) {
    setState(() {
      failure = !success;
    });

    analyticsBarrier++;

    if (analyticsBarrier > 25) {
      analyticsBarrier = 0;
      logStats();
    }

    ScoreManager().guess(success);

    if (ScoreManager().dailyStreak > ScoreManager().initialMonthlyStreak + 2 &&
        ScoreManager().initialMonthlyStreak != 0 &&
        SettingsManger().requestRating) {
      SettingsManger().requestRating = false;

      Future.delayed(
          Duration(microseconds: 1000), () => showRatingDialog(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveBase(
      child: SafeArea(
        child: Stack(
          children: [
            if (!SettingsManger().hideStreaks)
              Positioned(
                top: 10,
                left: 10,
                child: ScoreView(
                  red: failure,
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Quiz(
                  guessCallback: _guess,
                  wordSupplier: _getNextWord,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

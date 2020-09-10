// import 'package:article_images/manager/analytics.dart';
// import 'package:article_images/screens/SettingScreen.dart';
// import 'package:article_images/manager/score_manager.dart';
// import 'package:article_images/utils/Article.dart';
// import 'package:article_images/utils/PrivacyDialogBuilder.dart';
// import 'package:article_images/utils/RatingDialogBuilder.dart';
// import 'package:article_images/utils/Word.dart';
// import 'package:article_images/utils/WordDataStore.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class QuizState with ChangeNotifier {
//   Word _word;
//   Article _guess;
//   Word _nextWord;
//   bool requestRating = false;
//   final QuizScore score = QuizScore();
//   BuildContext mainContext;
//   int analyticsBarrier = 0;

//   Word get word => _word;
//   Article get guess => _guess;

//   final List<Word> lastUsed = [];

//   set guess(Article guess) {
//     _guess = guess;
//     var isRight = guess == word.article;

//     score.guess(isRight);

//     word.occurred++;
//     if (isRight) word.guessed++;

//     WordDataStore().update(word);

//     notifyListeners();

//     analyticsBarrier++;

//     if (analyticsBarrier > 25) {
//       analyticsBarrier = 0;
//       logStats(score);
//     }

//     if (score.dailyStreak > score.initialMonthlyStreak + 2 &&
//         score.initialMonthlyStreak != 0 &&
//         requestRating) {
//       requestRating = false;

//       Future.delayed(
//           Duration(microseconds: 1000), () => showRatingDialog(mainContext));
//     }
//   }

//   Word _getWord() {
//     final word = WordDataStore().words.reduce((w1, w2) {
//       if (lastUsed.contains(w2))
//         return w1;
//       else if (lastUsed.contains(w1)) return w2;

//       return w1.guessRate > w2.guessRate ? w2 : w1;
//     });

//     lastUsed.add(word);
//     if (lastUsed.length >= 13) lastUsed.removeAt(0);

//     return word;
//   }

//   Future<void> init(BuildContext context) async {
//     mainContext = context;
//     if (word == null) {
//       _nextWord = _getWord();
//       nextWord();
//       await score.init();
//     }
//   }
// }

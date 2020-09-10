import 'package:article_images/manager/score_manager.dart';
import 'package:article_images/utils/WordDataStore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void logStats() {
  int wordsTouched = 0;
  int totalOcurred = 0;
  int totalGuessed = 0;

  WordDataStore().words.forEach((word) {
    if (word.occurred != 0) {
      wordsTouched++;
    }

    totalOcurred += word.occurred;
    totalGuessed += word.guessed;
  });

  final averageScore = totalGuessed / totalOcurred;

  FirebaseAnalytics().logEvent(
    name: "learning_progress",
    parameters: {
      "overall_streak": ScoreManager().allStreak,
      "monthly_streak": ScoreManager().montlyStreak,
      "daily_streak": ScoreManager().dailyStreak,
      "words_touched": wordsTouched,
      "total_ocurred": totalOcurred,
      "total_guessed": totalGuessed,
      "average_score": averageScore,
    },
  );
}

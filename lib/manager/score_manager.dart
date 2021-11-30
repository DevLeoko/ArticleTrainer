import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager {
  static final ScoreManager _instance = ScoreManager._();

  ScoreManager._();

  factory ScoreManager() {
    return _instance;
  }

  static const String prefix = "stats_";

  late SharedPreferences _preferences;
  late int _montlyStreak;
  late int _dailyStreak;
  late int _allSteak;
  int previousStreak = 0;
  int currentStreak = 0;
  late int initialMonthlyStreak;
  List<void Function()> _notifiers = [];

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();

    DateTime now = DateTime.now();

    final remove = <String>[];
    _preferences.getKeys().forEach((key) {
      if (key.startsWith(prefix)) {
        if (key != "${now.day}-${now.month}-${now.year}" &&
            key != "${now.month}-${now.year}" &&
            key != "all") {
          remove.add(key);
        }
      }
    });

    _montlyStreak = _preferences.getInt("${now.month}-${now.year}") ?? 0;
    initialMonthlyStreak = _montlyStreak;
    _dailyStreak =
        _preferences.getInt("${now.day}-${now.month}-${now.year}") ?? 0;
    _allSteak = _preferences.getInt("all") ?? 0;

    remove.forEach(_preferences.remove);
  }

  int get montlyStreak {
    return _montlyStreak;
  }

  int get dailyStreak {
    return _dailyStreak;
  }

  int get allStreak {
    return _allSteak;
  }

  void guess(bool isRight) {
    previousStreak = currentStreak;
    if (isRight) {
      currentStreak++;

      if (currentStreak > dailyStreak) {
        DateTime now = DateTime.now();
        _dailyStreak = currentStreak;
        _preferences.setInt(
            "${now.day}-${now.month}-${now.year}", currentStreak);

        if (currentStreak > montlyStreak) {
          _montlyStreak = currentStreak;
          _preferences.setInt("${now.month}-${now.year}", currentStreak);

          if (currentStreak > allStreak) {
            _allSteak = currentStreak;
            _preferences.setInt("all", currentStreak);
          }
        }
      }
    } else {
      currentStreak = 0;
    }

    _notifiers.forEach((callback) {
      callback();
    });
  }

  void addListener(void Function() callback) {
    _notifiers.add(callback);
  }

  void removeListener(void Function() callback) {
    _notifiers.remove(callback);
  }
}

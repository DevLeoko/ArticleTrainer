import 'dart:convert';

import 'package:article_images/utils/challenge_data.dart';
import 'package:article_images/utils/word.dart';
import 'package:article_images/utils/word_data_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class ChallengeManager {
  static final _instance = ChallengeManager._();
  static const String prefix = "challenge_";
  static const int challengeSize = 15;

  ChallengeManager._();

  final Map<int, ChallengeData> _challengeData = {};

  late SharedPreferences _preferences;

  factory ChallengeManager() {
    return _instance;
  }

  init() async {
    _preferences = await SharedPreferences.getInstance();

    _preferences
        .getKeys()
        .where((str) => str.startsWith(prefix))
        .forEach((str) {
      int val = _preferences.getInt(str)!;
      var dayCode = int.parse(str.split("_")[1]);
      var challangeData = _challengeData[dayCode];
      if (str.split("_")[2] == "fails") {
        if (challangeData != null) {
          challangeData.fails = val;
        } else {
          _challengeData[dayCode] = ChallengeData(fails: val);
        }
      } else {
        if (challangeData != null) {
          challangeData.lastTry = val;
        } else {
          _challengeData[dayCode] = ChallengeData(lastTry: val);
        }
      }
    });
  }

  _save(int dayCode) async {
    await _preferences.setInt(
        "$prefix$dayCode\_fails", _challengeData[dayCode]!.fails);
    await _preferences.setInt(
        "$prefix$dayCode\_lastTry", _challengeData[dayCode]!.lastTry);
  }

  Future<List<Word>> startChallenge(int dayCode) async {
    final data = await http
        .get(Uri.https("https://us-central1-app-2b1a.cloudfunctions.net",
            "/main", {"challenge": true, "daycode": dayCode}))
        .timeout(Duration(seconds: 6));

    if (data.statusCode != 200) {
      throw Exception("Failed to load challenge!");
    }

    final words = List<String>.from(jsonDecode(data.body));

    final currentDayCode = toDayCodeFromDate(DateTime.now());

    if (_challengeData[dayCode] == null) {
      _challengeData[dayCode] =
          ChallengeData(fails: 15, lastTry: currentDayCode);
    } else {
      _challengeData[dayCode]!.lastTry = currentDayCode;
    }

    await _save(dayCode);

    return WordDataStore()
        .words
        .where((element) => words.contains(element.word))
        .toList();
  }

  completeChallenge(int dayCode, int fails) async {
    if (_challengeData[dayCode]!.fails == -1 ||
        _challengeData[dayCode]!.fails > fails) {
      _challengeData[dayCode]!.fails = fails;
      await _save(dayCode);
    }
  }

  ChallengeData getData(int dayCode) {
    return _challengeData[dayCode]!;
  }

  static toDayCodeFromDate(DateTime date) {
    return toDayCode(date.year, date.month, date.day);
  }

  static toDayCode(int year, int month, int day) {
    return (year - 2020) * 600 + month * 40 + day;
  }
}

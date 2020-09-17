import 'dart:convert';

import 'package:article_images/utils/challange_data.dart';
import 'package:article_images/utils/word.dart';
import 'package:article_images/utils/word_data_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallangeManager {
  static final _instance = ChallangeManager._();
  static const String prefix = "challange_";
  static const int challangeSize = 15;
  ChallangeManager._();

  final Map<int, ChallangeData> _challangeData = {};

  SharedPreferences _preferences;

  factory ChallangeManager() {
    return _instance;
  }

  get http => null;

  init() async {
    _preferences = await SharedPreferences.getInstance();

    _preferences
        .getKeys()
        .where((str) => str.startsWith(prefix))
        .forEach((str) {
      int val = _preferences.getInt(str);
      var dayCode = int.parse(str.split("_")[1]);
      if (str.split("_")[2] == "fails") {
        if (_challangeData[dayCode] != null) {
          _challangeData[dayCode].fails = val;
        } else {
          _challangeData[dayCode] = ChallangeData(fails: val);
        }
      } else {
        if (_challangeData[dayCode] != null) {
          _challangeData[dayCode].lastTry = val;
        } else {
          _challangeData[dayCode] = ChallangeData(lastTry: val);
        }
      }
    });
  }

  _save(int dayCode) async {
    await _preferences.setInt(
        "$prefix$dayCode\_fails", _challangeData[dayCode].fails);
    await _preferences.setInt(
        "$prefix$dayCode\_lastTry", _challangeData[dayCode].lastTry);
  }

  Future<List<Word>> startChallange(int dayCode) async {
    final data = await http.get(
        "https://us-central1-app-2b1a.cloudfunctions.net/main?challange=true&daycode=$dayCode");

    if (data.statusCode != 200) {
      throw Exception("Failed to load challange!");
    }

    final words = List<String>.from(jsonDecode(data.body));

    final currentDayCode = toDayCodeFromDate(DateTime.now());

    if (_challangeData[dayCode] == null) {
      _challangeData[dayCode] =
          ChallangeData(fails: 15, lastTry: currentDayCode);
    } else {
      _challangeData[dayCode].lastTry = currentDayCode;
    }

    await _save(dayCode);

    return WordDataStore()
        .words
        .where((element) => words.contains(element.word))
        .toList();
  }

  ChallangeData getData(int dayCode) {
    return _challangeData[dayCode];
  }

  static toDayCodeFromDate(DateTime date) {
    return toDayCode(date.year, date.month, date.day);
  }

  static toDayCode(int year, int month, int day) {
    return (year - 2020) * 400 + month * 40 + day;
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class ChallangeManager {
  static final _instance = ChallangeManager._();
  static const String prefix = "challange_";
  ChallangeManager._();

  final Map<int, int> challangeTries = {};
  final Map<int, int> challangeDate = {};

  SharedPreferences _preferences;

  factory ChallangeManager() {
    return _instance;
  }

  init() async {
    _preferences = await SharedPreferences.getInstance();

    _preferences
        .getKeys()
        .where((str) => str.startsWith(prefix))
        .forEach((str) {
      int val = _preferences.getInt(str);
      var dayId = int.parse(str.split("_")[1]);
      if (str.split("_")[2] == "tries")
        challangeTries[dayId] = val;
      else
        challangeDate[dayId] = val;
    });
  }
}

import 'package:flutter/cupertino.dart';

class ChallangeData {
  int fails;
  int lastTry;

  ChallangeData({
    this.fails = -1,
    this.lastTry = -1,
  });

  @override
  String toString() => 'ChallangeData(fails: $fails, lastTry: $lastTry)';
}

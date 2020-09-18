class ChallengeData {
  int fails;
  int lastTry;

  ChallengeData({
    this.fails = -1,
    this.lastTry = -1,
  });

  @override
  String toString() => 'ChallengeData(fails: $fails, lastTry: $lastTry)';
}

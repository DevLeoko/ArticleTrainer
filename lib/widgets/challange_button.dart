import 'package:article_images/manager/challange_manager.dart';
import 'package:article_images/utils/styles.dart';
import 'package:flutter/material.dart';

import 'package:article_images/widgets/month_view.dart';

class ChallangeButton extends StatelessWidget {
  final int year, month, day;

  const ChallangeButton(
      {Key key, @required this.year, @required this.month, @required this.day})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayCode = ChallangeManager.toDayCode(year, month, day);
    final currentDayCode = ChallangeManager.toDayCodeFromDate(now);
    final challangeData = ChallangeManager().getData(dayCode);

    final available = now.year > year ||
        (now.year == year && now.month > month) ||
        (now.year == year && now.month == month && now.day >= day);

    final notToday = challangeData?.lastTry == currentDayCode;

    var color = Colors.white;

    if (challangeData != null) {
      final fails = challangeData.fails;
      if (fails == 0)
        color = flatGreen;
      else if (fails <= 3)
        color = flatOrange;
      else
        color = flatRed;
    }

    if (now.year == year && now.month == month && now.day == day)
      color = flatBlue;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: MonthView.boxWidth - 10,
        height: MonthView.boxWidth - 10,
        child: RaisedButton(
          elevation: notToday ? 1 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          color: color,
          onPressed: available ? () {} : null,
        ),
      ),
    );
  }
}

import 'package:article_images/utils/article.dart';
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
    final dayCode = (year - 2020) * 400 + month * 40 + day;

    var available = now.year > year ||
        (now.year == year && now.month > month) ||
        (now.year == year && now.month == month && now.day >= day);

    var color = Colors.white;

    if (now.year == year && now.month == month && now.day == day)
      color = flatBlue;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: MonthView.boxWidth - 10,
        height: MonthView.boxWidth - 10,
        child: RaisedButton(
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

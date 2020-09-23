import 'package:article_images/widgets/challenge_button.dart';
import 'package:flutter/material.dart';

import 'package:article_images/utils/styles.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class MonthView extends StatelessWidget {
  static const boxWidth = 40.0;
  final int month;
  final int year;

  const MonthView({Key key, @required this.month, @required this.year})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final days = DateTime(year, month + 1, 0).day;
    final startOffset = DateTime(year, month, 1).weekday - 1;
    final rows = ((days + startOffset) / 7).ceil();

    final monthName = FlutterI18n.translate(context, "challenge.months")
        .split(" ")[month - 1];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          height: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var row = 0; row < rows; row++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var weekday = 0; weekday < 7; weekday++)
                      if (row * 7 + weekday >= startOffset)
                        ChallengeButton(
                          day: row * 7 + weekday + 1 - startOffset,
                          month: month,
                          year: year,
                        )
                      else
                        SizedBox(width: boxWidth, height: boxWidth)
                  ],
                ),
            ],
          ),
        ),
        Text(
          monthName,
          style: darkBlueThinFont.copyWith(fontSize: 25),
        ),
        Text(
          "($year)",
          style: darkBlueThinFont.copyWith(fontSize: 17),
        )
      ],
    );
  }
}

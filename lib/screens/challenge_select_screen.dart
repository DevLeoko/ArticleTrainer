import 'package:article_trainer/manager/settings_manager.dart';
import 'package:article_trainer/utils/styles.dart';
import 'package:article_trainer/widgets/interactive_base.dart';
import 'package:article_trainer/widgets/month_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ChallengeSelectScreen extends StatelessWidget {
  static const routeName = '/challenge/select';
  static const startMonth = 9;
  static const startYear = 2020;

  const ChallengeSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    MediaQuery.of(context); //rebuild on size change

    final currentIndex = (now.year - startYear) * 12 + (now.month - startMonth);

    return InteractiveBase(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var w in FlutterI18n.translate(context, "challenge.days")
                      .split(" "))
                    Container(
                      width: MonthView.boxWidth,
                      alignment: Alignment.center,
                      child: Text(
                        w,
                        style: darkBlueThinFont,
                      ),
                    ),
                ],
              ),
              Container(
                height: 350,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, indexx) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                        controller: PageController(
                          viewportFraction: 0.8,
                          initialPage: currentIndex,
                        ),
                        onPageChanged: (_) =>
                            SettingsManger().playSound("slide"),
                        itemBuilder: (context, index) {
                          return MonthView(
                            month: (index + startMonth - 1) % 12 + 1,
                            year: (index + startMonth - 1) ~/ 12 + startYear,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

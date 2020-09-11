import 'package:article_images/utils/styles.dart';
import 'package:article_images/widgets/interactive_base.dart';
import 'package:article_images/widgets/month_view.dart';
import 'package:flutter/material.dart';

class ChallangeSelectScreen extends StatelessWidget {
  static const routeName = '/challange/select';
  static const startMonth = 5;
  static const startYear = 2019;

  const ChallangeSelectScreen({Key key}) : super(key: key);

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
                  for (var w in ["M", "D", "M", "D", "F", "S", "S"])
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
                  itemBuilder: (context, indexx) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                        controller: PageController(
                            viewportFraction: 0.8, initialPage: currentIndex),
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

import 'package:article_images/manager/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tuple/tuple.dart';

class ScoreView extends StatefulWidget {
  final bool red;

  const ScoreView({
    Key key,
    this.red,
  }) : super(key: key);

  @override
  _ScoreViewState createState() => _ScoreViewState();
}

class _ScoreViewState extends State<ScoreView> {
  @override
  void initState() {
    ScoreManager().addListener(_rerender);

    super.initState();
  }

  @override
  void dispose() {
    ScoreManager().removeListener(_rerender);

    super.dispose();
  }

  _rerender() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final ratio = media.size.aspectRatio;
    final score = ScoreManager();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: (widget.red
                    ? Colors.redAccent
                    : Colors.white.withOpacity(0.85)),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Text(
                (widget.red ? score.previousStreak : score.currentStreak)
                        .toString() +
                    FlutterI18n.translate(context, "score.countParticle"),
                style: TextStyle(
                    color: Colors.green.shade400,
                    fontSize: 25,
                    // fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              FlutterI18n.translate(context, "score.streak"),
              style: TextStyle(
                  color: (widget.red
                      ? Colors.redAccent
                      : Colors.white.withOpacity(0.85)),
                  fontSize: 27,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        if (ratio <= 0.6 || media.orientation == Orientation.landscape)
          for (final stat in [
            // Tuple2("jetzt", state.item2.currentStreak),
            Tuple2(FlutterI18n.translate(context, "score.allTime"),
                score.allStreak),
            Tuple2(FlutterI18n.translate(context, "score.month"),
                score.montlyStreak),
            Tuple2(FlutterI18n.translate(context, "score.today"),
                score.dailyStreak),
          ])
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  stat.item2.toString(),
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 23,
                      // fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(stat.item1,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600)),
              ],
            ),
      ],
    );
  }
}

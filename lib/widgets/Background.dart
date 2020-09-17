import 'package:article_images/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackgroundStateContainer extends ChangeNotifier {
  BackgroundState _state = BackgroundState.neutral;

  get state => _state;
  set state(BackgroundState state) {
    _state = state;
    notifyListeners();
  }

  static BackgroundStateContainer of(BuildContext context) {
    return Provider.of<BackgroundStateContainer>(context, listen: false);
  }
}

class Background extends StatefulWidget {
  static final globalKey = GlobalKey();
  final BackgroundState backgroundState;

  Background({Key key, this.backgroundState = BackgroundState.neutral})
      : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

enum BackgroundState { success, failure, neutral }

class _BackgroundState extends State<Background>
    with SingleTickerProviderStateMixin {
  static double _startValue = 0;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, value: _startValue)
      ..repeat(min: 0, max: 1, period: Duration(seconds: 7));
    _controller.addListener(() {
      _startValue = _controller.value;
    });
  }

  @override
  void dispose() {
    _startValue = _controller.value;
    _controller.dispose();
    super.dispose();
  }

  bool previousSuccess = true;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "background",
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final isNeutral = widget.backgroundState == BackgroundState.neutral;
            return TweenAnimationBuilder(
              tween: Tween(begin: 0.0, end: isNeutral ? 0.0 : 1.0),
              curve: Curves.easeOutQuad,
              duration: Duration(milliseconds: 400),
              builder: (_, value, __) {
                if (!isNeutral)
                  previousSuccess =
                      widget.backgroundState == BackgroundState.success;

                return CustomPaint(
                  painter: BackgroundPainter(
                      _controller.value, value, previousSuccess, isNeutral),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class RelativeFlowPath extends Path {
  final width;
  final height;

  double prevX;
  double prevY;

  RelativeFlowPath(this.width, this.height, this.prevX, this.prevY) : super() {
    moveTo(prevX * width, prevY * height);
  }

  void flowTo(double x, double y) {
    quadraticBezierTo(
      prevX * width,
      prevY * height,
      (x + prevX) / 2 * width,
      (y + prevY) / 2 * height,
    );
    prevX = x;
    prevY = y;
  }

  @override
  void lineTo(double x, double y) {
    super.lineTo(prevX * width, prevY * height);
    super.lineTo(x * width, y * height);
    prevX = x;
    prevY = y;
  }
}

extension AnimationDouble on double {
  double off(double offset, double factor) {
    double n = this + offset;
    double res = n <= 1 ? n : 1 - n % 1;
    return Curves.easeInOutBack
            .transform((res < 0.5 ? res : 0.5 - res % 0.5) * 2) /
        factor;
  }
}

class BackgroundPainter extends CustomPainter {
  final double value;
  final double blendValue;
  final bool success;
  final bool blendOut;

  BackgroundPainter(this.value, this.blendValue, this.success, this.blendOut)
      : super();

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    canvas.drawRect(
      Rect.fromLTRB(0, 0, width, height),
      paint..color = Colors.grey.shade100,
    );

    RelativeFlowPath path0 =
        RelativeFlowPath(width, height, 0, blendOut ? 1 - blendValue : 0);
    path0.lineTo(1, blendOut ? 1 - blendValue : 0);
    path0.lineTo(1, blendOut ? 1 : blendValue);
    path0.lineTo(0, blendOut ? 1 : blendValue);
    path0.close();
    canvas.drawShadow(path0, Colors.black54, 5, true);
    canvas.drawPath(path0,
        paint..color = success ? Colors.green.shade400 : Colors.red.shade400);

    RelativeFlowPath path1 = RelativeFlowPath(width, height, 0.5, 0);
    path1.flowTo(
      0.55,
      0.2 + value.off(0.2, 40),
    );
    path1.flowTo(
      0.2,
      0.3 + value.off(0.7, 60),
    );
    path1.flowTo(
      0.0,
      0.45,
    );
    path1.lineTo(0, 0);
    path1.close();
    canvas.drawShadow(path1, Colors.black54, 5, true);
    canvas.drawPath(path1, paint..color = flatGreen);

    RelativeFlowPath path2 = RelativeFlowPath(width, height, 0, 0.55);
    path2.flowTo(
      0.15 + value.off(0.5, 60),
      0.57,
    );
    path2.flowTo(
      0.3,
      0.65,
    );
    path2.flowTo(
      0.13,
      0.85 + value.off(0.2, 40),
    );
    path2.flowTo(
      0.3 + value.off(0, 50),
      1,
    ); // 0.3
    path2.lineTo(0, 1);
    path2.close();
    canvas.drawShadow(path2, Colors.black54, 5, true);
    canvas.drawPath(path2, paint..color = flatOrange);

    RelativeFlowPath path3 = RelativeFlowPath(width, height, 0.9, 0);
    path3.flowTo(
      0.7 + value.off(0.3, 70),
      0.2,
    );
    path3.flowTo(
      0.75 + value.off(0.4, 50),
      0.45 + value.off(0.6, 40),
    );
    path3.flowTo(
      0.4,
      0.7 + value.off(0.4, 60),
    );
    path3.flowTo(
      0.7 + value.off(0.2, 30),
      1,
    );
    path3.lineTo(1, 1);
    path3.lineTo(1, 0);
    path3.close();
    canvas.drawShadow(path3, Colors.black54, 5, true);
    canvas.drawPath(path3, paint..color = flatBlue);
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

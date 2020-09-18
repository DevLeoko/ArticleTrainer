import 'package:article_images/screens/home_screen.dart';
import 'package:article_images/utils/styles.dart';
import 'package:article_images/utils/word_data_store.dart';
import 'package:article_images/widgets/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:article_images/utils/article.dart';
import 'package:article_images/utils/word.dart';
import 'package:article_images/widgets/word_view.dart';
import 'package:article_images/widgets/theme_button.dart';

class Quiz extends StatefulWidget {
  final Word Function(bool) wordSupplier;
  final Function(bool) guessCallback;
  final Function() doneCallback;
  final String heroTag;

  const Quiz({
    Key key,
    @required this.wordSupplier,
    @required this.guessCallback,
    this.doneCallback,
    this.heroTag = "WordView",
  }) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> with TickerProviderStateMixin {
  Word currentWord;
  Word nextWord;
  Article currentGuess;

  List<AnimationController> _controllers = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 3; i++) {
      final contr = AnimationController(
          vsync: this, duration: Duration(milliseconds: 300));
      _controllers.add(contr);

      Future.delayed(Duration(milliseconds: 200 + i * 100))
          .then((value) => mounted ? contr.forward() : false);
    }

    currentWord = widget.wordSupplier(true);
    currentWord?.cachedImage;
    nextWord = widget.wordSupplier(true);
    nextWord?.cachedImage;
  }

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((contr) => contr.dispose());
  }

  _nextWord() {
    setState(() {
      currentWord = nextWord;
      currentGuess = null;
      nextWord = widget.wordSupplier(false);
    });

    nextWord?.cachedImage;

    BackgroundStateContainer.of(context).state = BackgroundState.neutral;
  }

  _guess(Article article, BuildContext context) {
    setState(() {
      currentGuess = article;
    });

    var isRight = article == currentWord.article;

    widget.guessCallback(isRight);

    currentWord.occurred++;
    if (isRight) currentWord.guessed++;

    WordDataStore().update(currentWord);

    BackgroundStateContainer.of(context).state =
        isRight ? BackgroundState.success : BackgroundState.failure;
  }

  @override
  Widget build(BuildContext context) {
    double size = getQuizSize(context);
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Flex(
      direction: isPortrait ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      verticalDirection: VerticalDirection.up,
      textDirection: TextDirection.rtl,
      children: <Widget>[
        Container(
          width: isPortrait ? size : null,
          height: isPortrait ? null : size,
          child: currentGuess == null
              ? Flex(
                  direction: isPortrait ? Axis.horizontal : Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    for (final article in Article.values)
                      SlideTransition(
                        position: Tween<Offset>(
                                begin: Offset(0, -2), end: Offset.zero)
                            .animate(CurvedAnimation(
                                parent: _controllers[article.index],
                                curve: Curves.easeOut)),
                        child: ArticleButton(
                          article: article,
                          size: size / 3.5,
                          onPressed: () {
                            _guess(article, context);
                          },
                        ),
                      ),
                  ],
                )
              : Container(
                  height: size / 3.5,
                  width: size / 3.5,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    color: Colors.white,
                    child: Icon(
                        nextWord != null ? Icons.arrow_forward : Icons.check),
                    onPressed: nextWord != null
                        ? _nextWord
                        : widget.doneCallback ?? () {},
                  ),
                ),
        ),
        SizedBox(height: 40, width: 40),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: Colors.black38,
              )
            ],
          ),
          width: size,
          height: size,
          child: Hero(
            tag: widget.heroTag,
            flightShuttleBuilder: HomeScreen.roundedFlightShuttleBuild,
            child: WordView(
              size: size,
              word: currentWord,
              solved: currentGuess != null,
            ),
          ),
        )
      ],
    );
  }
}

class ArticleButton extends StatelessWidget {
  const ArticleButton({Key key, this.article, this.size, this.onPressed})
      : super(key: key);

  final Article article;
  final double size;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: ThemeButton(
        color: article.color(),
        onPressed: onPressed,
        text: article.name().toUpperCase(),
      ),
    );
  }
}

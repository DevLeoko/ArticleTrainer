import 'package:article_images/manager/score_manager.dart';
import 'package:article_images/manager/settings_manager.dart';
import 'package:article_images/utils/WordDataStore.dart';
import 'package:article_images/widgets/Background.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key key}) : super(key: key);

  static const TextStyle myStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25,
    letterSpacing: 1.3,
    shadows: [
      Shadow(
        blurRadius: 4,
        color: Colors.black38,
        offset: Offset(2, 2),
      )
    ],
  );

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String errorTitle;
  String errorText;

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

  void _fetchData() async {
    final connection = await Connectivity().checkConnectivity();

    if (connection == ConnectivityResult.none) {
      setState(() {
        errorTitle = "Kein Internet!";
        errorText =
            "Es ist eine Internetverbindung für disese App erfoderlich!";
      });
      return;
    }

    await ScoreManager().init();

    try {
      await WordDataStore().initialize();
    } catch (exc) {
      setState(() {
        errorTitle = "Fehler!";
        errorText =
            "Beim Laden der Wörter ist ein Fehler aufgetreten! Überprüfe deine Internetverbindung und probiere es später erneut.";
      });
      return;
    }

    await SettingsManger().init(context);

    Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);

    // await Provider.of<QuizState>(context, listen: false)
    //     .init(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (errorTitle == null) {
      child = Loading(
        myStyle: LoadingScreen.myStyle,
        text: "Lade Wörter...",
      );
    } else {
      child = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.warning,
              color: Colors.red,
              size: 50,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              errorTitle,
              style: LoadingScreen.myStyle,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: Text(
                errorText,
                textAlign: TextAlign.center,
                style: LoadingScreen.myStyle
                    .copyWith(fontSize: 14, color: Colors.grey.shade700),
              ),
            ),
            RaisedButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Icon(Icons.refresh), Text("Retry")],
              ),
              onPressed: () => setState(() {
                errorTitle = null;
                errorText = null;
                _fetchData();
              }),
              color: Colors.blueAccent,
              textColor: Colors.white,
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Container(
            child: child,
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({
    Key key,
    @required this.myStyle,
    @required this.text,
  }) : super(key: key);

  final TextStyle myStyle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Hero(
            tag: "MainLogo",
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: 4,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                ),
                Image.asset(
                  "assets/images/icon.png",
                  scale: 1.6,
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            text,
            style: myStyle,
          )
        ],
      ),
    );
  }
}

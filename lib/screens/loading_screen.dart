import 'package:article_images/manager/challenge_manager.dart';
import 'package:article_images/manager/score_manager.dart';
import 'package:article_images/manager/settings_manager.dart';
import 'package:article_images/utils/styles.dart';
import 'package:article_images/utils/word_data_store.dart';
import 'package:article_images/widgets/background.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key key}) : super(key: key);

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

    await SettingsManger().init(context);
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

    ChallengeManager().init();

    Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (errorTitle == null) {
      child = Loading(
        myStyle: boldWhiteShadowFont,
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
              style: boldWhiteShadowFont,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: Text(
                errorText,
                textAlign: TextAlign.center,
                style: boldWhiteShadowFont.copyWith(
                    fontSize: 14, color: Colors.grey.shade700),
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

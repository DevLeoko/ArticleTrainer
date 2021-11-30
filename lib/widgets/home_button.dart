import 'package:article_images/manager/settings_manager.dart';
import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Positioned(
        bottom: 40,
        right: 20,
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade300,
          child: Icon(Icons.home),
          onPressed: () {
            SettingsManger().playSound("longPop", volume: 0.6);
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/home', (_) => false);
          },
        ),
      ),
    );
  }
}

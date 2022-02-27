import 'package:article_trainer/manager/settings_manager.dart';
import 'package:flutter/material.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({Key? key}) : super(key: key);

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
            child: Icon(Icons.close),
            onPressed: () {
              SettingsManger().playSound("longPop", volume: 0.6);
              Navigator.of(context).maybePop();
            }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'background.dart';
import 'home_button.dart';

class InteractiveBase extends StatelessWidget {
  final Widget child;

  const InteractiveBase({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<BackgroundStateContainer>(
        create: (context) => BackgroundStateContainer(),
        child: Stack(
          children: [
            Consumer<BackgroundStateContainer>(
              builder: (context, value, child) => Background(
                backgroundState: value.state,
              ),
            ),
            HomeButton(),
            child
          ],
        ),
      ),
    );
  }
}

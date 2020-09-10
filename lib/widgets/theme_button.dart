import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    Key key,
    this.color,
    this.onPressed,
    this.text,
  }) : super(key: key);

  final Color color;
  final Function onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: color,
      padding: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      color: Colors.white,
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 23),
      ),
    );
  }
}

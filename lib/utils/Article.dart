import 'package:flutter/material.dart';

enum Article { der, die, das }

extension FancyArticle on Article {
  static const _colors = [Colors.blue, Colors.green, Colors.orange];

  static Article fromType(String letter) {
    switch (letter) {
      case "m":
      case "M":
        return Article.der;
      case "f":
      case "F":
        return Article.die;
      case "n":
      case "N":
        return Article.das;
      default:
        return Article.der;
    }
  }

  Color color() {
    return _colors[this.index];
  }

  get type {
    switch (this) {
      case Article.der:
        return "m";
      case Article.die:
        return "f";
      case Article.das:
        return "n";
      default:
        return "-";
    }
  }

  String name() {
    switch (this) {
      case Article.der:
        return "der";
      case Article.die:
        return "die";
      case Article.das:
        return "das";
      default:
        return "-";
    }
  }
}

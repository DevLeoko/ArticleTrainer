import 'dart:typed_data';

import 'package:article_images/utils/image.dart';
import 'package:http/http.dart' as http;

import 'article.dart';

class Word {
  int? id;
  final String word;
  final Article article;
  final Image image;
  int occurred;
  int guessed;
  Future<Uint8List>? _cachedImage;

  Word(this.id, this.word, this.article, this.image,
      [this.occurred = 0, this.guessed = 0]);

  get guessRate =>
      occurred == 0 ? 0.65 : guessed / ((occurred - guessed) * 2 + 1);

  Word.fromMap(Map<String, dynamic> map)
      : this(
          map['id'],
          map['word'],
          FancyArticle.fromType(map['type']),
          Image.fromMap(map),
          map['occurred'],
          map['guessed'],
        );

  Map<String, dynamic> toMap() {
    return {
      "word": word,
      "type": article.type,
      "occurred": occurred,
      "guessed": guessed,
    }..addAll(image.toMap());
  }

  // static const maxImageSize = 1000 * 1000; //(*8) = 1MB

  Future<Uint8List> get cachedImage {
    if (_cachedImage == null)
      _cachedImage = http.readBytes(Uri.parse(image.displayUrl));

    return _cachedImage!;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Word &&
        o.id == id &&
        o.word == word &&
        o.article == article &&
        o.occurred == occurred &&
        o.guessed == guessed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        word.hashCode ^
        article.hashCode ^
        occurred.hashCode ^
        guessed.hashCode;
  }
}

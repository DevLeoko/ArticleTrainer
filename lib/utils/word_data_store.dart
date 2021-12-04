import 'dart:convert';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'package:http/http.dart' as http;

import 'word.dart';

class WordDataStore {
  Database? _database;
  List<Word> _words = [];

  static final WordDataStore _singeton = WordDataStore._();

  WordDataStore._();

  factory WordDataStore() {
    return _singeton;
  }

  Future<List<Map<String, dynamic>>> _fetchWords() async {
    final data = await http
        .get(Uri.https("us-central1-app-2b1a.cloudfunctions.net", "/main"));
    if (data.statusCode != 200) {
      throw Exception("Failed to fetch words!");
    } else {
      return List<Map<String, dynamic>>.from(jsonDecode(data.body));
    }
  }

  Future<int> _fetchListVersion() async {
    final data = await http
        .get(Uri.https("us-central1-app-2b1a.cloudfunctions.net", "/main",
            {"version": "true"}))
        .timeout(Duration(seconds: 10));
    if (data.statusCode != 200) {
      throw Exception("Failed to fetch version!");
    } else {
      return jsonDecode(data.body)['version'];
    }
  }

  Future<void> initialize() async {
    if (_words.isEmpty) {
      final db = await _connection;
      final version = await _fetchListVersion();

      final prefs = await SharedPreferences.getInstance();

      _words =
          (await db.query("Word")).map((entry) => Word.fromMap(entry)).toList();

      if (version != prefs.getInt("listVersion")) {
        Map<String, Word> oldWords = {for (var word in _words) word.word: word};

        final results = await _fetchWords();
        final words = results.map((entry) {
          final oldWord = oldWords[entry['word']];

          entry
            ..['occurred'] = oldWord?.occurred ?? 0
            ..['guessed'] = oldWord?.guessed ?? 0;

          return Word.fromMap(entry);
        }).toList();
        _words = words;

        db.delete("Word");
        final batch = db.batch();
        words.forEach((word) => batch.insert("Word", word.toMap()));
        List<int> ids = List<int>.from(await batch.commit());

        await prefs.setInt("listVersion", version);

        for (var i = 0; i < words.length; i++) {
          words[i].id = ids[i];
        }
      }
    }
  }

  Future<Database> get _connection async {
    if (_database != null) return _database!;
    _database = await _getDatabaseInstance();
    return _database!;
  }

  Future<Database> _getDatabaseInstance() async {
    String path = join(await getDatabasesPath(), "word.db");
    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Word ("
            "id integer primary key AUTOINCREMENT,"
            "word TEXT,"
            "type TEXT,"
            "occurred INTEGER,"
            "guessed INTEGER,"
            "imageId TEXT,"
            "displayUrl TEXT,"
            "downloadUrl TEXT,"
            "userId TEXT,"
            "username TEXT,"
            "userLink TEXT"
            ")");
      },
    );
  }

  update(Word word) async {
    final db = await _connection;
    await db
        .update("Word", word.toMap(), where: "id = ?", whereArgs: [word.id]);
  }

  List<Word> get words {
    return _words;
  }
}

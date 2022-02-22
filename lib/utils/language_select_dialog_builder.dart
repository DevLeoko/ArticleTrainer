import 'package:article_images/manager/settings_manager.dart';
import 'package:article_images/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

const languageCodes = [
  "af",
  "sq",
  "am",
  "ar",
  "hy",
  "az",
  "eu",
  "be",
  "bn",
  "bs",
  "bg",
  "ca",
  "ceb",
  "ny",
  "zh-CN",
  "zh-TW",
  "co",
  "hr",
  "cs",
  "da",
  "nl",
  "en",
  "eo",
  "et",
  "tl",
  "fi",
  "fr",
  "fy",
  "gl",
  "ka",
  "el",
  "gu",
  "ht",
  "ha",
  "haw",
  "iw",
  "hi",
  "hmn",
  "hu",
  "is",
  "ig",
  "id",
  "ga",
  "it",
  "ja",
  "jw",
  "kn",
  "kk",
  "km",
  "rw",
  "ko",
  "ku",
  "ky",
  "lo",
  "la",
  "lv",
  "lt",
  "lb",
  "mk",
  "mg",
  "ms",
  "ml",
  "mt",
  "mi",
  "mr",
  "mn",
  "my",
  "ne",
  "no",
  "or",
  "ps",
  "fa",
  "pl",
  "pt",
  "pa",
  "ro",
  "ru",
  "sm",
  "gd",
  "sr",
  "st",
  "sn",
  "sd",
  "si",
  "sk",
  "sl",
  "so",
  "es",
  "su",
  "sw",
  "sv",
  "tg",
  "ta",
  "tt",
  "te",
  "th",
  "tr",
  "tk",
  "uk",
  "ur",
  "ug",
  "uz",
  "vi",
  "cy",
  "xh",
  "yi",
  "yo",
  "zu",
  "he",
  "zh"
];

Widget buildLanguageSelectDialog(context) {
  return AlertDialog(
    title: I18nText("language.selectLanguage"),
    content: Container(
      height: 300,
      width: double.maxFinite,
      child: ListView(
        shrinkWrap: true,
        children: (languageCodes
                .map((e) => {
                      'code': e,
                      'name': FlutterI18n.translate(context, "language.$e")
                    })
                .toList()
              ..sort((a, b) => a['name']!.compareTo(b['name']!)))
            .map((e) {
              return InkWell(
                onTap: () {
                  SharedPreferences.getInstance()
                      .then((prefs) => prefs.setString(
                          SettingsScreen.translation_language, e['code']!))
                      .then((_) {
                    SettingsManger().translationLanguage = e['code']!;
                    Navigator.of(context).pop(e['code']!);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    e['name']!,
                    style: TextStyle(
                      fontWeight:
                          SettingsManger().translationLanguage != e['code']
                              ? null
                              : FontWeight.bold,
                      color: SettingsManger().translationLanguage != e['code']
                          ? null
                          : Colors.black45,
                    ),
                  ),
                ),
              );
            })
            .expand((element) => [
                  element,
                  Container(
                    color: Colors.black26,
                    height: 1,
                  )
                ])
            .toList()
          ..removeLast(),
      ),
    ),
  );
}

void showLanguageSelectDialog(context) async {
  showDialog(
      context: context,
      builder: (context) => buildLanguageSelectDialog(context),
      barrierDismissible: false);
}

import 'package:article_images/manager/settings_manager.dart';
import 'package:article_images/screens/settings_screen.dart';
import 'package:article_images/utils/language_select_dialog_builder.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/widgets/I18nText.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageUnlockDialog extends StatefulWidget {
  const LanguageUnlockDialog({Key? key}) : super(key: key);

  @override
  State<LanguageUnlockDialog> createState() => _LanguageUnlockDialogState();
}

class _LanguageUnlockDialogState extends State<LanguageUnlockDialog> {
  bool loading = false;

  _showAd(context) {
    setState(() {
      loading = true;
    });
    RewardedAd.load(
      adUnitId: "ca-app-pub-3940256099942544/5224354917",
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (!loading) return;

          Navigator.of(context).pop();
          ad.show(
            onUserEarnedReward: (ad, reward) {
              setState(() {
                loading = false;
              });
              SettingsManger().unlockedTranslation = true;
              SharedPreferences.getInstance().then((prefs) =>
                  prefs.setBool(SettingsScreen.unlocked_translation, true));
              showLanguageSelectDialog(context);
            },
          );
        },
        onAdFailedToLoad: (error) {
          setState(() {
            loading = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: I18nText("language.unlock.error"),
              content: I18nText("language.unlock.errorText"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: I18nText("language.unlock.close"),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.auto_awesome),
          SizedBox(
            width: 4,
          ),
          I18nText("language.unlock.title"),
        ],
      ),
      content: I18nText("language.unlock.text"),
      actions: [
        TextButton(
          onPressed: () {
            FirebaseAnalytics().logEvent(name: "decline-language-unlock");
            loading = false;
            Navigator.pop(context, false);
          },
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black45)),
          child: I18nText("language.unlock.no"),
        ),
        if (!loading)
          TextButton(
            onPressed: () => _showAd(context),
            child: I18nText("language.unlock.yes"),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          )
      ],
    );
  }
}

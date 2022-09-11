import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangeLocaleButton extends StatelessWidget {
  const ChangeLocaleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (context.locale == const Locale('en')) {
          context.setLocale(const Locale('he'));
        } else {
          context.setLocale(const Locale('en'));
        }
      },
      icon: const Icon(Icons.language),
      tooltip: "Change Language",
    );
  }
}

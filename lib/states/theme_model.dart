import 'package:flutter/material.dart';
import 'package:github_client/common/index.dart';
import 'package:github_client/states/profile_change_notifier.dart';

class ThemeModel extends ProfileChangeNotifier {
  MaterialColor get theme =>
      Global.themes.firstWhere((element) => element.value == profile.theme,
          orElse: () => Colors.blue);

  set theme(ColorSwatch color) {
    if (color != theme) {
      profile.theme = color[500]?.value as num;
      notifyListeners();
    }
  }
}

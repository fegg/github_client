import 'dart:ui';

import 'package:github_client/states/profile_change_notifier.dart';

class LocaleModel extends ProfileChangeNotifier {
  Locale? getLocale() {
    if (null == profile.locale) {
      return null;
    }

    var t = profile.locale!.split("_");

    if (t.length > 1) {
      return Locale(t[0], t[1]);
    }

    return null;
  }

  set locale(String locale) {
    if (locale != profile.locale) {
      profile.locale = locale;
      notifyListeners();
    }
  }
}

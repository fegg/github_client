import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../generated/intl/messages_all.dart';


class DemoLocalizations {
  // 加载 intl 文件
  static Future<DemoLocalizations> load(Locale locale) {
    final bool countryCodeEmpty = locale.countryCode?.isEmpty != null;
    final String name = countryCodeEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((value) {
      Intl.defaultLocale = localeName;
      return DemoLocalizations();
    });
  }

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of(context, DemoLocalizations);
  }

  // 声明一个属性
  String get title {
    return Intl.message(
      'Flutter App',
      name: 'title',
      desc: 'Title for the demo application',
    );
  }
}

class DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh_CN'].contains(locale.languageCode);
  }

  // 加载 locale 资源
  @override
  Future<DemoLocalizations> load(Locale locale) {
    return DemoLocalizations.load(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<DemoLocalizations> old) {
    return false;
  }
}
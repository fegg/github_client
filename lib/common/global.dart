import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_client/models/cacheConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  static late SharedPreferences _prefs;
  static late Profile profile = Profile();

  // 缓存网络对象
  static NetCache netCache = NetCache();

  // 可选主题列表
  static List<MaterialColor> get themes => _themes;

  // 是否是 release
  static bool get kReleaseMode => const bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();

    var _profile = _prefs.getString("profile");

    if (null != _profile) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    } else {
      profile = Profile()..theme = 0;
    }

    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;
  }
  
  static saveProfile() {
    return _prefs.setString("profile", jsonEncode(profile.toJson()));
  }
}

class NetCache {}

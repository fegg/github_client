import 'package:flutter/material.dart';
import 'package:github_client/common/index.dart';

import '../models/profile.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  // public
  Profile get profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile();
    super.notifyListeners();
  }
}
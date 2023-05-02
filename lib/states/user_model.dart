import 'package:github_client/models/index.dart';
import 'package:github_client/states/profile_change_notifier.dart';

class UserModel extends ProfileChangeNotifier {
  bool get isLogin => user != null;

  // getter and setter
  User? get user => profile.user;
  set user(User? user) {
    // 检查是否与当前登录用户一致
    if (user?.login != profile.user?.login) {
      profile.lastLogin = profile.user?.login;
      profile.user = user;
      notifyListeners();
    }
  }
}
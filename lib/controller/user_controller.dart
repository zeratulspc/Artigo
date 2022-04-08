import 'package:artigo/data/provider/auth_api.dart';
import 'package:artigo/routes/pages.dart';
import 'package:get/get.dart';
import 'package:artigo/data/models/user.dart' as models;

class UserController extends GetxController {
  /// 현재 사용자 정보
  final _user = Rxn<models.User>();
  set user(models.User? v) => _user.value = v;
  models.User? get user => _user.value;

  /// 사용자 목록
  final _users = <String, models.User>{}.obs;
  set users(Map<String, models.User> v) => _users.value = v;
  Map<String, models.User> get users => _users;

  Future<void> fetchUser({String? uid}) async {
    final models.User value = await AuthAPI.fetchUser(uid: uid);
    if(uid==null) {
      user = value;
    }
    _users[value.uid] = value;
  }

  logout() async {
    await AuthAPI.logout();
    Get.offAllNamed(Routes.splash);
    user = null;
    users = {};
  }

}
import 'package:artigo/data/provider/auth_api.dart';
import 'package:artigo/routes/pages.dart';
import 'package:get/get.dart';
import 'package:artigo/data/models/user.dart' as models;

class UserController extends GetxController {
  final authAPI = AuthAPI();

  final _user = Rxn<models.User>();
  set user(models.User? v) => _user.value = v;
  models.User? get user => _user.value;

  Future<void> fetchUser() async {
    user = await authAPI.fetchUser();
  }

  logout() async {
    await authAPI.logout();
    Get.offAllNamed(Routes.splash);
  }

}
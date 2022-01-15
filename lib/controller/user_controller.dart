import 'package:artigo2/data/provider/auth_api.dart';
import 'package:get/get.dart';
import 'package:artigo2/data/models/user.dart' as models;

class UserController extends GetxController {
  final authAPI = AuthAPI();

  final _user = Rxn<models.User>();
  set user(models.User? v) => _user.value = v;
  models.User? get user => _user.value;

  @override
  void onInit() async {
    user = await authAPI.fetchUser();
    super.onInit();
  }

}
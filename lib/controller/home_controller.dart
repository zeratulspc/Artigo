import 'package:artigo2/data/provider/auth_api.dart';
import 'package:artigo2/routes/pages.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final AuthApi authApi = AuthApi();

  logout() async {
    await authApi.logout();
    Get.offAllNamed(Routes.splash);
  }
}
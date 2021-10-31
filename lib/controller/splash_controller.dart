import 'package:artigo2/data/provider/auth_api.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final AuthApi authApi = AuthApi();

  login() {
    authApi.signInWithGoogle();
  }
}
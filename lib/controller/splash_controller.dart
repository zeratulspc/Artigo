import 'package:artigo2/controller/user_controller.dart';
import 'package:artigo2/data/provider/auth_api.dart';
import 'package:artigo2/routes/pages.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final AuthAPI authApi = AuthAPI();
  final UserController userController = Get.put<UserController>(UserController());

  login() async {
    var credential = await authApi.signInWithGoogle();
    if(credential.credential!=null) {
      userController.fetchUser();
      Get.offAllNamed(Routes.home);
    } else {
      if (kDebugMode) {
        print("로그인 실패!");
      }
    }
  }
}
import 'package:artigo2/data/provider/auth_api.dart';
import 'package:artigo2/ui/home.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final AuthApi authApi = AuthApi();

  login() async {
    var credential = await authApi.signInWithGoogle();
    if(credential.credential!=null) {
      Get.offAll(()=>Home());
    }
  }
}
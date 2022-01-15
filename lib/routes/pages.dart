import 'package:artigo2/ui/auth/login.dart';
import 'package:artigo2/ui/home.dart';
import 'package:artigo2/ui/splash.dart';
import 'package:get/get.dart';

part './routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.splash, page: () => SplashPage()),
    GetPage(name: Routes.login, page: () => LoginPage()),
    GetPage(name: Routes.home, page: ()=> HomePage()),
  ];
}
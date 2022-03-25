import 'package:artigo/ui/auth/login.dart';
import 'package:artigo/ui/home.dart';
import 'package:artigo/ui/post/post_detail.dart';
import 'package:artigo/ui/splash.dart';
import 'package:get/get.dart';

part './routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.splash, page: () => SplashPage()),
    GetPage(name: Routes.login, page: () => LoginPage()),
    GetPage(name: Routes.home, page: ()=> HomePage()),
    GetPage(name: '${Routes.post}/:key', page: ()=> PostDetailPage())
  ];
}
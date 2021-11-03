import 'package:artigo2/data/provider/auth_api.dart';
import 'package:artigo2/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final AuthApi authApi = AuthApi();
  final PageController pageController = PageController(initialPage: 0, keepPage: true);

  final _homeIdx = 0.obs;
  set homeIdx(int v){
    _homeIdx.value = v;
    pageController.animateToPage(v, duration: const Duration(milliseconds: 300),curve: Curves.ease);
  }
  int get homeIdx => _homeIdx.value;

  logout() async {
    await authApi.logout();
    Get.offAllNamed(Routes.splash);
  }
}
import 'package:artigo2/data/provider/auth_api.dart';
import 'package:artigo2/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final AuthAPI authApi = AuthAPI();
  final PageController pageController = PageController(initialPage: 0, keepPage: true);

  final _homeIdx = 0.obs;
  set homeIdx(int v) => _homeIdx.value = v;
  int get homeIdx => _homeIdx.value;

  logout() async {
    await authApi.logout();
    Get.offAllNamed(Routes.splash);
  }
}
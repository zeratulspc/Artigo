import 'package:artigo/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  final controller = Get.put<SplashController>(SplashController());
  SplashPage({Key? key}) : super(key: key){
    controller.login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Artigo',
              style: TextStyle(
                color: Get.theme.primaryTextTheme.overline!.color,
                fontSize: 64,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

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
            Text(
              '안녕하세요',
              style: TextStyle(
                color: Get.theme.primaryTextTheme.overline!.color,
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
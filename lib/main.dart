import 'package:artigo/routes/pages.dart';
import 'package:artigo/ui/artigo_color_swatch.dart';
import 'package:artigo/ui/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Artigo());
}

class Artigo extends StatelessWidget {
  const Artigo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Artigo',
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      theme: ThemeData(
        primarySwatch: ArtigoColorSwatch.primary,
      ),
      home: SplashPage(),
    );
  }
}
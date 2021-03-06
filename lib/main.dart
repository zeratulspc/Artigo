import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:Artigo/page/auth/login.dart';
import 'package:Artigo/page/home.dart';
import 'package:Artigo/page/splash.dart';
import 'package:Artigo/page/settings/settings.dart';
import 'package:Artigo/page/settings/editProfile.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final routes = {
  '/login': (BuildContext context) => LoginPage(),
  '/home': (BuildContext context) => HomePage(),
  '/settings' : (BuildContext context) => Settings(),
  '/editProfile' : (BuildContext context) => EditProfilePage(),
};

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: RemoveGrow(),
          child: child,
        );
      },
      title: 'Artigo Community',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[300],
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        accentColor: Colors.lightGreen,
      ),
      home: SplashScreen(),
    );
  }
}

class RemoveGrow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

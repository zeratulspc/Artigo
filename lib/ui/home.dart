import 'package:artigo2/controller/home_controller.dart';
import 'package:artigo2/ui/feed/feed_widget.dart';
import 'package:artigo2/ui/profile/profile_widget.dart';
import 'package:artigo2/ui/setting/setting_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final controller = Get.put<HomeController>(HomeController());

  final homeWidgets = <Widget>[
    FeedWidget(),
    ProfileWidget(),
    SettingWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Artigo",
          style: TextStyle(
            fontFamily: "Montserrat"
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: ()=>controller.logout(),
          ),
        ],
      ),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (i)=>controller.homeIdx = i,
        children: homeWidgets,
      ),
      bottomNavigationBar: Obx(()=>BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int i)=>controller.homeIdx=i,
        currentIndex: controller.homeIdx,
        items: const [
          BottomNavigationBarItem(
            label: "피드",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "내 정보",
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: "설정",
            icon: Icon(Icons.settings),
          ),
        ],
      )),
    );
  }
}
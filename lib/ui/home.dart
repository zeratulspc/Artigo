import 'package:artigo/controller/home_controller.dart';
import 'package:artigo/routes/pages.dart';
import 'package:artigo/ui/feed/feed_widget.dart';
import 'package:artigo/ui/post/edit_post.dart';
import 'package:artigo/ui/profile/profile_widget.dart';
import 'package:artigo/ui/setting/setting_widget.dart';
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
    return Obx(()=>Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (i)=>controller.homeIdx = i,
        children: homeWidgets,
      ),
      floatingActionButton: controller.homeIdx==0?
        FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Get.to(()=>EditPostPage()),
        ):null,
      bottomNavigationBar: Obx(()=>BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int i) => controller.pageController.animateToPage(
            i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn
        ),
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
    ));
  }
}
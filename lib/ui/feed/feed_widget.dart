import 'package:artigo/controller/home_controller.dart';
import 'package:artigo/ui/post/post_bottomsheet.dart';
import 'package:artigo/ui/post/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FeedWidget extends StatelessWidget {
  FeedWidget({Key? key}) : super(key: key);
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>controller.feed.isNotEmpty?ListView.builder(
      itemCount: controller.feed.length,
      itemBuilder: (context, i) => PostWidget(
        post: controller.feed[i],
        onTap: ()=>controller.openPostDetail(controller.feed[i].key, controller.feed[i]),
        onLongPress: controller.feed[i].owner == (controller.userController.user?.uid??"")?
          ()=>Get.bottomSheet(PostBottomSheet(postKey: controller.feed[i].key, post: controller.feed[i])) :null,
      ),
    ):const Center(child: Text("게시글 없음"),));
  }

}
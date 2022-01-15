import 'package:artigo2/controller/home_controller.dart';
import 'package:artigo2/ui/post/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedWidget extends StatelessWidget {
  FeedWidget({Key? key}) : super(key: key);
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>controller.feed.isNotEmpty?ListView.builder(
      itemCount: controller.feed.length,
      itemBuilder: (context, i) => PostWidget(post: controller.feed[i]),
    ):Center(child: Text("게시글 없음"),));
  }

}
import 'package:artigo/controller/post_detail_controller.dart';
import 'package:artigo/data/models/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


/// 게시글 상세 페이지
/// 접근 시 무조건 게시글의 key 를 파라미터로 제공해야한다
class PostDetailPage extends StatelessWidget {
  final PostDetailController controller = PostDetailController(postKey: Get.parameters['key']!, post: Get.arguments);
  PostDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("게시글 상세, :${Get.parameters['key']}"),
      ),
    );
  }

}
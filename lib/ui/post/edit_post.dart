import 'package:artigo/controller/edit_post_controller.dart';
import 'package:artigo/data/models/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditPostPage extends StatelessWidget {
  EditPostPage({Key? key}) : super(key: key);
  final controller = Get.put<EditPostController>(EditPostController(postKey: Get.parameters['key'], post:Get.arguments));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: ()=>controller.complete(),
      ),
      body: ListView(
        children: [
          Obx(()=>Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(),
                child: TextField(
                  focusNode: controller.titleFocusNode,
                  controller: controller.titleController,
                  cursorColor: Theme.of(context).primaryColor,
                  style: const TextStyle(
                      fontSize: 24
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 128,
                  decoration: InputDecoration(
                    hintText: "제목을 입력해주세요",
                    border: InputBorder.none,
                    counterText: controller.titleFocused?null:"",
                  ),
                ),
              )
          )),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(),
                child: TextField(
                  controller: controller.bodyController,
                  cursorColor: Theme.of(context).primaryColor,
                  style: const TextStyle(
                      fontSize: 18
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "무슨 일이 일어나고 있나요?",
                    border: InputBorder.none,
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }

}
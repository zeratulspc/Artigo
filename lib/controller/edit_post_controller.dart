import 'package:artigo/controller/user_controller.dart';
import 'package:artigo/data/models/post.dart';
import 'package:artigo/data/provider/post_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditPostController extends GetxController {
  final String? postKey;
  final _post = Rxn<Post>();
  Post? get post => _post.value;
  set post(Post? v) => _post.value = v;
  EditPostController({this.postKey, Post? post}) {
    if(post!=null) this.post = post;
  }

  final TextEditingController titleController = TextEditingController();
  final titleFocusNode = FocusNode();
  final _titleFocused = false.obs;
  bool get titleFocused => _titleFocused.value;
  set titleFocused(bool v) => _titleFocused.value = v;
  final TextEditingController bodyController = TextEditingController();

  final userController = Get.find<UserController>();

  @override
  void onInit() async {
    if(postKey!=null&&post==null) {
      post = await PostAPI.fetchPost(postKey!);
    }
    titleFocusNode.addListener(() => titleFocused = titleFocusNode.hasFocus);
    super.onInit();
  }

  Future<void> complete() async {
    /// check texts
    if(titleController.text=="") return;
    if(bodyController.text=="") return;
    if(postKey!=null) {
      /// update post
    } else {
      /// create post
      final Post post = Post(
        key: "",
        title: titleController.text,
        body: bodyController.text,
        owner: userController.user!.uid,
        postDate: DateTime.now(),
        editDate: [],
      );
      await PostAPI.createPost(post);
    }
    Get.back(); /// back to previous page
  }

}
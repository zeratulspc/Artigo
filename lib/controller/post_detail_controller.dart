import 'package:flutter/material.dart';
import 'package:artigo/data/models/post.dart';
import 'package:artigo/data/provider/post_api.dart';
import 'package:get/get.dart';

class PostDetailController extends GetxController {
  final String postKey;
  final _post = Rxn<Post>();
  Post? get post => _post.value;
  set post(Post? v) => _post.value =v;

  PostDetailController({
    required this.postKey,
    Post? post,
  }) {
    if(post!=null) this.post = post;
  }

  @override
  void onInit() async {
    post ??= await PostAPI.fetchPost(postKey);
    super.onInit();
  }
}
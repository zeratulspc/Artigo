import 'package:artigo2/controller/user_controller.dart';
import 'package:artigo2/data/models/post.dart';
import 'package:artigo2/data/provider/auth_api.dart';
import 'package:artigo2/data/provider/post_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final UserController userController = Get.find<UserController>();
  final PostAPI postAPI = PostAPI();
  final PageController pageController = PageController(initialPage: 0, keepPage: true);

  final _homeIdx = 0.obs;
  set homeIdx(int v) => _homeIdx.value = v;
  int get homeIdx => _homeIdx.value;

  final _feed = Rx<List<Post>>([]);
  set feed(List<Post> v) => _feed.value = v;
  List<Post> get feed => _feed.value;

  @override
  void onInit() {
    fetchFeed();
    super.onInit();
  }

  /// 피드를 불러옵니다
  Future<void> fetchFeed() async {
    await postAPI.fetchFeed().then((v) => feed = v);
  }

  /// 게시글을 생성합니다
  Future<void> createPost(Post post) async {
    await postAPI.createPost(post);
  }
}
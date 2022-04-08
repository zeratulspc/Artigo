import 'package:artigo/data/models/post.dart';
import 'package:artigo/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostBottomSheet extends StatelessWidget {
  final String? postKey;
  final Post? post;
  const PostBottomSheet({
    Key? key,
    this.postKey,
    this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: Material(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("수정하기"),
              onTap: ()=>Get.toNamed("${Routes.edit}/$postKey", arguments: post),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("삭제하기"),
              onTap: (){},
            ),
          ],
        ),
      ),
    );
  }
}
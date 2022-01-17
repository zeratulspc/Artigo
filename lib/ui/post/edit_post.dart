import 'package:artigo/data/models/post.dart';
import 'package:flutter/material.dart';

class EditPostPage extends StatelessWidget {
  final Post? post;
  EditPostPage({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("게시글 수정"),
      ),
    );
  }

}
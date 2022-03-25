import 'package:artigo/data/models/post.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  const PostWidget({
    Key? key,
    required this.post,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(post.title),
      subtitle: Text(post.body),
    );
  }

}
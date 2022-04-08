import 'package:artigo/data/models/post.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  const PostWidget({
    Key? key,
    required this.post,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      title: Text(post.title),
      subtitle: Text(post.body),
    );
  }

}
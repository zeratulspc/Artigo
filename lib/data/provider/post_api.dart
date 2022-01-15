import 'package:firebase_database/firebase_database.dart';

import 'package:artigo2/data/models/post.dart' as models;


class PostAPI {
  final postDBRef = FirebaseDatabase.instance.reference().child("Posts");

  Future<void> createPost(models.Post post) async {
    await postDBRef.push().set(post.toJson());
  }

}
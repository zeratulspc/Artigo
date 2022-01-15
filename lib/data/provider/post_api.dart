import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:artigo2/data/models/post.dart' as models;


class PostAPI {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final postDBRef = FirebaseDatabase.instance.reference().child("Posts");

  /// 게시글을 생성합니다
  Future<void> createPost(models.Post post) async {
    await postDBRef.push().set(post.toJson());
  }

  /// 피드를 불러옵니다
  Future<List<models.Post>> fetchFeed() async {
    return await postDBRef.get().then((v) => v.value.values.map((e)=>models.Post.fromMap(e)).toList().cast<models.Post>());
  }

  /// 하나의 게시글을 불러옵니다
  Future<models.Post> fetchPost(String key) async {
    return await postDBRef.child(key).get().then((v) => models.Post.fromSnapshot(v));
  }

  /// 게시글을 수정합니다
  Future<void> updatePost(String postKey, models.Post post) async {
    await postDBRef.child(postKey).set(post.toJson());
  }

  /// 게시글을 삭제합니다
  Future<void> deletePost(String key) async {
    await postDBRef.child(key).remove();
  }

}
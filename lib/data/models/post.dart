import 'package:firebase_database/firebase_database.dart';

class Post {
  final String key;
  final String title;
  final String body;
  final DateTime postDate;

  Post({
    required this.title,
    required this.key,
    required this.body,
    required this.postDate,
  });

  factory Post.fromSnapshot(DataSnapshot d) {
    return Post(
      key: d.key!,
      title: d.value['title'],
      body: d.value['body'],
      postDate: DateTime.parse(d.value['postDate']!),
    );
  }
}
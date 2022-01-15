import 'package:firebase_database/firebase_database.dart';

class Post {
  final String key;
  final String title;
  final String body;
  final String owner;
  final DateTime postDate;
  final List<DateTime> editDate;

  Post({
    required this.title,
    required this.key,
    required this.body,
    required this.owner,
    required this.postDate,
    required this.editDate,
  });

  factory Post.fromSnapshot(DataSnapshot d) {
    return Post(
      key: d.key!,
      title: d.value['title'],
      body: d.value['body'],
      owner: d.value['owner'],
      postDate: DateTime.parse(d.value['postDate']!),
      editDate: d.value['editDate'].map((e)=>DateTime.parse(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title' : title,
      'body' : body,
      'owner' : owner,
      'postDate' : postDate,
      'editDate' : editDate.map((e) => e.toIso8601String()).toList(),
    };
  }
}
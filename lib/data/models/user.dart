import 'package:firebase_database/firebase_database.dart';

class User {
  final String uid;
  final String username;
  final String description;
  final DateTime registerDate;
  final List<DateTime> loginDate;
  User({
    required this.uid,
    required this.username,
    required this.description,
    required this.registerDate,
    required this.loginDate,
  });

  factory User.fromSnapshot(DataSnapshot d) {
    return User(
      uid: d.key!,
      username: d.value['username']!,
      description: d.value['description']!,
      registerDate: DateTime.parse(d.value['registerDate']!),
      loginDate: d.value['loginDate'].map((e)=>DateTime.parse(e)).toList(),
    );
  }

  Map<String, dynamic> toJson()=>{
    'username':username,
    'description':description,
    'registerDate':registerDate.toIso8601String(),
    'loginDate':loginDate.map((e) => e.toIso8601String()).toList(),
  };
}
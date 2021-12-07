import 'package:firebase_database/firebase_database.dart';

class PostAPI {
  final postDBRef = FirebaseDatabase.instance.reference().child("Posts");

}
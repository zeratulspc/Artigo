import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:artigo2/data/models/user.dart' as models;

class AuthApi {
  final userDBRef = FirebaseDatabase.instance.reference().child("Users");
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await auth.signInWithCredential(credential);
  }

  /*
  Future<void> createUserInfo() {
    models.User user = User();
  }
  */

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await auth.signOut();
  }

}
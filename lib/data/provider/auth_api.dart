import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:artigo2/data/models/user.dart' as models;

class AuthAPI {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userDBRef = FirebaseDatabase.instance.reference().child("Users");

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    var cred = await auth.signInWithCredential(credential);
    if(!await isUserValid(cred.user!.uid)) {
      await createUserInfo(
          uid: cred.user!.uid,
          username: cred.user!.displayName??"",
          description: "",
      );
    }
    UserCredential userCredential = await auth.signInWithCredential(credential);
    if(userCredential.credential!=null) {
      await addLoginHistory(userCredential.user!.uid);
    }
    return userCredential;
  }

  Future<bool> isUserValid(String uid) async {
    var data = await userDBRef.child(uid).once();
    return data.exists;
  }

  Future<void> createUserInfo({
    required String uid,
    required String username,
    required String description,
  }) async {
    models.User user = models.User(
      uid: uid,
      username:username,
      description:description,
      registerDate:DateTime.now(),
      loginDate: [],
    );
    userDBRef.child(uid).set(user.toJson());
  }

  Future<void> addLoginHistory(String uid) async {
    return await userDBRef
      .child(uid)
      .child('loginDate')
      .push()
      .set(DateTime.now().toIso8601String());
  }

  Future<models.User> fetchUser(String uid) async{
    return await userDBRef.child(uid).get().then((v) => models.User.fromSnapshot(v));
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await auth.signOut();
  }

}
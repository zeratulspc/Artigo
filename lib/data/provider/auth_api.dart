import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:artigo2/data/models/user.dart' as models;

class AuthAPI {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userDBRef = FirebaseDatabase.instance.reference().child("Users");

  /// 구글 계정을 통해 로그인합니다
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    var cred = await auth.signInWithCredential(credential);
    if(!await isUserExists(cred.user!.uid)) {
      await createUserInfo(
          uid: cred.user!.uid,
          username: cred.user!.displayName??"",
          description: "",
      );
    }
    UserCredential userCredential = await auth.signInWithCredential(credential);
    if(userCredential.credential!=null) {
      await addLoginDate(userCredential.user!.uid);
    }
    return userCredential;
  }

  /// 사용자가 존재하는지 확인합니다
  Future<bool> isUserExists(String uid) async {
    var data = await userDBRef.child(uid).once();
    return data.exists;
  }

  /// 사용자 정보를 생성합니다
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

  /// 로그인 기록을 추가합니다
  Future<void> addLoginDate(String uid) async {
    return await userDBRef
      .child(uid)
      .child('loginDate')
      .push()
      .set(DateTime.now().toIso8601String());
  }


  /// uid에 해당하는 유저를 반환합니다
  /// uid가 null이면 현재 이용자의 정보를 반환합니다
  Future<models.User> fetchUser(String? uid) async{
    return await userDBRef.child(uid ?? auth.currentUser!.uid).get().then((v) => models.User.fromSnapshot(v));
  }

  /// 로그아웃
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await auth.signOut();
  }

}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:Artigo/fnc/user.dart';
import 'package:Artigo/page/basicDialogs.dart';

class EditProfilePage extends StatefulWidget {
  final Function() callback;
  EditProfilePage({this.callback});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  BasicDialogs basicDialogs = BasicDialogs();
  UserDBFNC authDBFNC = UserDBFNC();
  User currentUser;
  String userName;
  String description;
  String email;

  String profileImageURL;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentUser = authDBFNC.getUser();
    });
    authDBFNC.getUserInfo(currentUser.uid).then((data) {
      setState(() {
        userName = data.userName;
        description = data.description;
        email = data.email;
        profileImageURL = data.profileImageURL;
      });
    });
  }

  Future<bool> changeProfileImage(ImageSource source) async {
    PickedFile pickedFile = await ImagePicker().getImage(source: source, imageQuality: 50);
    File image = File(pickedFile.path);
    if(image != null) {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
          compressQuality: 50,
          maxWidth: 512,
          maxHeight: 512,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: '이미지 자르기',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
          )
      );
      if(croppedImage != null) {
        basicDialogs.showLoading(context, "프로필 사진 업로드 중");
        if(await authDBFNC.uploadUserProfileImage(uid: currentUser.uid, profileImage: croppedImage)) {
          return await authDBFNC.getUserInfo(currentUser.uid).then(
                  (data) {
                setState(() {
                  userName = data.userName;
                  description = data.description;
                  email = data.email;
                  profileImageURL = data.profileImageURL;
                });
                Navigator.pop(context);
                return true;
              }
          );
        } else { // 업로드에 실패했을 경우
          return false;
        }
      } else { // 이미지 자르기에서 되돌아간 경우
        return false;
      }
    } else { // 파일을 선택하지 않았을 경우.
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text("프로필 수정", style: TextStyle(color: Colors.black),),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              ListTile(
                  title: Text("프로필 사진", style: TextStyle(fontWeight: FontWeight.bold),),
                  trailing: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Text("수정", style: TextStyle(color: Theme.of(context).primaryColor),),
                    onPressed: (){
                      changeProfileImage(ImageSource.gallery);
                    },
                  )
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: profileImageURL == null ?
                Container(width: 200, height: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ) : Image.network(
                  profileImageURL,
                  width: 200,
                  height: 200,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                    if(loadingProgress == null) return child;
                    return Container(width: 200, height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(),
              ListTile(
                  title: Text("닉네임", style: TextStyle(fontWeight: FontWeight.bold),),
                  trailing: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Text("수정", style: TextStyle(color: Theme.of(context).primaryColor),),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) => TextFieldPage(object: "userName", uid: currentUser.uid, item: userName,
                            callback: () { // Reload
                              authDBFNC.getUserInfo(currentUser.uid).then(
                                      (data) {
                                    setState(() {
                                      userName = data.userName;
                                      description = data.description;
                                      email = data.email;
                                    });
                                  }
                              );
                              this.widget.callback();
                            },)
                      ));
                    },
                  )
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Center(
                  child: Text(userName??"불러오는 중...", style: TextStyle(color: Colors.grey[700]),),
                ),
              ),
              Divider(),
              ListTile(
                  title: Text("한줄 소개", style: TextStyle(fontWeight: FontWeight.bold),),
                  trailing: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Text("수정", style: TextStyle(color: Theme.of(context).primaryColor),),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) => TextFieldPage(object: "description", uid: currentUser.uid, item: description,
                            callback: () { // Reload
                              authDBFNC.getUserInfo(currentUser.uid).then(
                                      (data) {
                                    setState(() {
                                      userName = data.userName;
                                      description = data.description;
                                      email = data.email;
                                    });
                                  }
                              );
                              this.widget.callback();
                            },
                          )
                      ));
                    },
                  )
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Center(
                  child: Text(description??"불러오는 중...", style: TextStyle(color: Colors.grey[700]),),
                ),
              ),
              Divider(),
            ],
          ),
        )
      ),
    );
  }
}

class TextFieldPage extends StatefulWidget {
  final Function() callback;
  final String object;
  final String uid;
  final String item;
  TextFieldPage({this.object, this.uid, this.item, this.callback});

  @override
  TextFieldPageState createState() => TextFieldPageState(object: object, uid: uid, item: item);
}

class TextFieldPageState extends State<TextFieldPage> {
  final editProfileFormKey = GlobalKey<FormState>();
  final String object;
  final String uid;
  String item;
  TextFieldPageState({this.object, this.uid, this.item});

  UserDBFNC authDBFNC = UserDBFNC();

  String objectToInfo(String object) {
    switch(object) {
      case "userName":
        return "닉네임";
        break;
      case "description":
        return "한줄소개";
        break;
      default:
        return "정보";
        break;
    }
  }

  objectToFnc(String object) {
    switch(object) {
      case "userName":
        authDBFNC.updateUserName(uid: uid, userName: item);
        break;
      case "description":
        authDBFNC.updateUserDescription(uid: uid, description: item);
        break;
      default:
        break;
    }
  }

  void confirmDialog(BuildContext context, String object) {
    String contentText;
    String titleText;
    switch(object) {
      case "userName":
        contentText = "닉네임을 수정하시겠습니까?";
        titleText = "닉네임";
        break;
      case "description":
        contentText = "한줄소개를 수정하시겠습니까?";
        titleText = "한줄소개";
        break;
      default:
        contentText = "정보를 수정하시겠습니까?";
        titleText = "정보";
        break;
    }
    showDialog(context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$titleText 수정"),
          content: Text(contentText),
          actions: <Widget>[
            FlatButton(
              child: Text("취소"),
              onPressed: (){
                Navigator.pop(context); // dialog pop
              },
            ),
            FlatButton(
              child: Text("확인"),
              onPressed: (){
                var form = editProfileFormKey.currentState;
                form.save();
                if(form.validate()) {
                  objectToFnc(object);
                  this.widget.callback();
                  Navigator.pop(context); // 컨펌 다이알로그 팝
                  Navigator.pop(context); // 페이지 팝
                }
              },
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text("${objectToInfo(object)} 수정", style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text("저장", style: TextStyle(color: Colors.black),),
            onPressed: () {
              if(editProfileFormKey.currentState.validate())
                confirmDialog(context,object);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: editProfileFormKey,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(
                    10, 10, 10, 1
                ),
                height: 150,
                child: TextFormField(
                  initialValue: item,
                  onSaved: (value) => item = value,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: objectToInfo(object),
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                  validator: (String value) {
                    switch(object){
                      case "userName":
                        if (value.length == 0)
                          return '닉네임을 입력해주세요.';
                        else if(value.length >= 16)
                          return '닉네임은 16글자를 넘길 수 없습니다.';
                        else
                          return null;
                        break;
                      case "description":
                        if (value.length == 0)
                          return '한줄소개를 입력해주세요.';
                        else if(value.length >= 64)
                          return '한줄소개는 64글자를 넘길 수 없습니다.';
                        else
                          return null;
                        break;
                      default:
                        return null;
                    }
                  },
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
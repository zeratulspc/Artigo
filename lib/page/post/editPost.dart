import 'package:flutter/material.dart';
import 'package:flutter/services.dart' ;
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:Artigo/fnc/user.dart';
import 'package:Artigo/fnc/postDB.dart';
import 'package:Artigo/fnc/notification.dart';
import 'package:Artigo/page/basicDialogs.dart';
import 'package:Artigo/page/post/editPostAttach.dart';

class EditPost extends StatefulWidget {
  final int postCase; // 1: POST 2: EDIT
  final Post initialPost;
  final UserAdditionalInfo uploader;
  final User currentUser;
  final VoidCallback refreshPostList;
  EditPost({
    this.postCase,
    this.uploader,
    this.currentUser,
    this.initialPost,
    this.refreshPostList,
  }); // 1: POST 2: EDIT
  @override
  EditPostState createState() => EditPostState();
}

class EditPostState extends State<EditPost> {
  final int imageUploadQuality = 50;

  BasicDialogs basicDialogs = BasicDialogs();
  PostDBFNC postDBFNC = PostDBFNC();

  ScrollController mainTextFieldScrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  List<Attach> attach = List(); // 업로드 되지 않은 사진
  List<Widget> photoItems = List();
  List<Attach> deletedItem = List();
  int maxLine = 8;
  bool showPostButton = false;
  bool notNull(Object o) => o != null;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
    if(widget.postCase == 2) {
      setState(() {
        if(widget.initialPost.attach != null) {
          attach.addAll(widget.initialPost.attach);
          generateItems(attach.length);
        }
        textEditingController.text = widget.initialPost.body;
      });
    }
    if(this.mounted) {
      textEditingController.addListener(() {
        if(this.mounted){
          setState(() {
            if(textEditingController.text.length >= 1) {
              showPostButton = true;
            } else {
              showPostButton = false;
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    );
    super.dispose();
    textEditingController.dispose();
    FocusScopeNode().dispose();
  }

  uploadPost() async {
    basicDialogs.showLoading(context, "게시글 업로드 중");
      String key = postDBFNC.createPost(Post(
        body: textEditingController.text,
        uploaderUID: widget.currentUser.uid,
        uploadDate: DateTime.now().toIso8601String(),
        isEdited: false,
      )
    );
    if(key != null) { // post 가 정상적으로 업로드 되었는지 확인
      for(int i = 0;i < attach.length; i++) {
        await postDBFNC.addPhoto(attach[i], key); // photo 업로드 실패 예외처리
      }
      NotificationFCMFnc().sendFollowerNotification(
        senderUid: widget.currentUser.uid,
        title: "${widget.uploader.userName}님이 새 게시글을 작성하셨습니다.",
        body: textEditingController.text,
      );
      Navigator.pop(context); // 로딩 다이알로그 pop
      widget.refreshPostList();
      Navigator.pop(context); // 페이지 pop
    } else {
      Navigator.pop(context);
      basicDialogs.dialogWithYes(context, "오류 발생", "게시글이 정상적으로 업로드 되지 않았습니다.");
    }

  }

  editPost() async {
    basicDialogs.showLoading(context, "게시글 업로드 중");
    List<int> newPhotoIndex = List();
    await postDBFNC.updatePost(widget.initialPost.key, Post(
        body: textEditingController.text,
        uploaderUID: widget.currentUser.uid,
        uploadDate: DateTime.now().toIso8601String(),
        emotion: widget.initialPost.emotion,
        attach: widget.initialPost.attach,
        comment: widget.initialPost.comment,
        isEdited: true,
      )
    );

    attach.forEach((data){
      if(data.tempPhoto != null)
        newPhotoIndex.add(int.parse(data.key));
    });
    for(int i = 0; i < deletedItem.length; i++){
      await postDBFNC.deletePhoto(widget.initialPost.key, deletedItem[i]);
    }

    for(int i = 0;i < newPhotoIndex.length; i++) {
      await postDBFNC.addPhoto(attach[newPhotoIndex[i]], widget.initialPost.key); // photo 업로드 실패 예외처리'
    }

    NotificationFCMFnc().sendFollowerNotification(
      senderUid: widget.currentUser.uid,
      title: "${widget.uploader.userName}님이 게시글을 수정하셨습니다.",
      body: textEditingController.text,
    );
    Navigator.pop(context); // 로딩 다이알로그 pop
    Navigator.pop(context); // 페이지 pop

  }

  void pickImageSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext _context){
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('사진 찍기'),
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(context, ImageSource.camera);
                    }
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("갤러리에서 가져오기"),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  pickImage(BuildContext context, ImageSource source) async {
    bool isDuple = false;
    bool _isComplete = false;
    File tempImage;
    PickedFile pickedFile;
    pickedFile = await ImagePicker().getImage(source: source, imageQuality: imageUploadQuality);
    if(pickedFile != null) {
      tempImage = File(pickedFile.path);
      attach.forEach((item){
        if(!_isComplete) {
          if(item.tempPhoto != null) {
            if(item.tempPhoto.path == tempImage.path) {
              _isComplete = true;
              isDuple = true;
            } else {
              isDuple = false;
            }
          } else {
            if(item.fileName == "") {
              _isComplete = true;
              isDuple = true;
            } else {
              isDuple = false;
            }
          }
        }
      });
    }
    if(tempImage != null) {
      print(tempImage.lengthSync().toString());
      if(!isDuple) {
        if(await tempImage.exists()) {
          setState(() {
            attach.add(Attach(
              key: attach.length.toString(),
              tempPhoto: tempImage,
              uploaderUID: widget.currentUser.uid,
              uploadDate: DateTime.now().toIso8601String(),
            ));
            photoItems.clear();
            generateItems(attach.length);
          });
        } else {
          basicDialogs.dialogWithYes(context, "불러오기 실패", "불러오기에 실패했습니다.");
        }
      } else {
        basicDialogs.dialogWithYes(context, "업로드 불가", "중복된 이미지는 업로드 할 수 없습니다.");
      }
    }
  }

  generateItems(int widgetLength) {
    List<Widget> tempItems = List<Widget>.generate(widgetLength, (index){
      if(attach[index].tempPhoto != null) {
        return Container(
          child: Image.file(
            attach[index].tempPhoto,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return Container(
          child: Image.network(
            attach[index].filePath,
            fit: BoxFit.cover,
          ),
        );
      }
    });
    setState(() {
      photoItems.clear();
      photoItems.addAll(tempItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.white,
        title: Text(
          "${widget.postCase == 1 ? "게시글 작성" : "게시글 수정"}",
          style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Center(
                child: Text("게시", style: TextStyle(
                    color: showPostButton ? Colors.black : Colors.grey[500]),),
              ),
              onTap: showPostButton ? widget.postCase == 1 ? uploadPost : editPost : null,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        focusColor: Colors.green[400],
        splashColor: Theme.of(context).accentColor,
        child: Icon(Icons.photo, color: Colors.white,),
        onPressed: (){
          pickImageSheet(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.only(top: 3.0, left: 15, right: 15),
              title: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.grey[400],
                          )
                      ),
                      widget.uploader.profileImageURL != null ?
                      ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Image.network(
                          widget.uploader.profileImageURL,
                          height: 40.0,
                          width: 40.0,
                        ),
                      ) : ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.grey[400],
                          )
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: screenSize.width / 1.3,
                          child: Text(widget.uploader.userName??"", maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: TextField(
                  controller: textEditingController,
                  cursorColor: Theme.of(context).primaryColor,
                  style: TextStyle(
                      fontSize: 18
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "무슨 일이 일어나고 있나요?",
                    border: InputBorder.none,
                  ),
                ),
              )
            ),
            attach.length != 0 ? Container(
              width: screenSize.width,
              margin: EdgeInsets.symmetric(vertical: 20),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  AttachEditInfo editedAttach = await Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      EditPostAttach(
                        imageUploadQuality: imageUploadQuality,
                        attach: attach,
                        uploaderUID: widget.currentUser.uid,
                      )
                  ));
                  if(editedAttach != null) {
                    if(editedAttach.deleteQueue.length != 0) {
                      editedAttach.deleteQueue.forEach((element) {
                        deletedItem.add(attach[element]);
                      });
                    }
                    if(editedAttach.attach != null) {
                      setState(() {
                        attach.clear();
                        attach.addAll(editedAttach.attach);
                        photoItems.clear();
                        generateItems(attach.length);
                      });

                    }
                  }
                },
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    initialPage: 0,
                    aspectRatio: 1/1,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    disableCenter: true,
                  ),
                  itemCount: photoItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            color: Colors.grey[200],
                            child: photoItems[index]
                          ),
                          attach.length > 1 ? Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: Text("${index+1}/${attach.length}", style: TextStyle(color: Colors.white),),
                            ),
                          ) : null,
                        ].where(notNull).toList(),
                      ),
                    );
                  },
                ),
              )
            ) : null,
            SizedBox(height: 20,),
          ].where(notNull).toList(),
        )
      ),
    );
  }
}
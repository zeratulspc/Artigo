import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:badges/badges.dart';

import 'package:Artigo/fnc/user.dart';
import 'package:Artigo/fnc/notification.dart';
import 'package:Artigo/page/post/postList.dart';
import 'package:Artigo/page/post/editPost.dart';
import 'package:Artigo/page/todo/todoBoard.dart';
import 'package:Artigo/page/data/dataBoard.dart';
import 'package:Artigo/page/settings/settings.dart';
import 'package:Artigo/page/profile/userProfile.dart';
import 'package:Artigo/page/post/searchPage.dart';
import 'package:Artigo/page/profile/notificationList.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  //UI
  GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<PostListState> postListKey = GlobalKey<PostListState>();
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  int currentIndex = 0;
  bool isPageCanChanged = true;
  bool showFab = false;

  //Auth
  UserDBFNC authDBFNC = UserDBFNC();
  User currentUser;
  UserAdditionalInfo currentUserInfo;

  //FCM
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  //Noti count
  Query receivedQuery;
  Notifications notifications = Notifications(receivedNotifications: List(), sentNotifications: List());
  int newNotificationCount = 0;

  void initState() {
    super.initState();
    if(this.mounted) {
      setState(() {
        currentUser = authDBFNC.getUser();
      });
        firebaseMessaging.getToken().then((token){
          authDBFNC.updateUserToken(uid: currentUser.uid, token: token);
        });
        authDBFNC.getUserInfo(currentUser.uid).then((userInfo){
          if(this.mounted) {
            setState(() {
              currentUserInfo = userInfo;
            });
            receivedQuery = FirebaseDatabase.instance.reference().child("Notifications").child(currentUserInfo.key).child("receivedNotifications");
            receivedQuery.onChildAdded.listen(_rOnEntryAdded);
            receivedQuery.onChildChanged.listen(_rOnEntryChanged);
            receivedQuery.onChildRemoved.listen(_rOnEntryRemoved);
          }
        });
    }
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) => NotificationFCMFnc.onMessage(context, message),
      onResume: (Map<String, dynamic> message) => NotificationFCMFnc.onResume(context, message),
      onLaunch: (Map<String, dynamic> message) => NotificationFCMFnc.onLaunch(context, message),
    );
  }

  _rOnEntryAdded(Event event) async {
    if(this.mounted){
      NotificationUnit unit = NotificationUnit().fromLinkedHashMap(event.snapshot.value);
      if(!unit.isChecked) {
        setState(() {
          newNotificationCount++;
        });
      }
    }
  }

  _rOnEntryChanged(Event event) async {
    if(this.mounted){
      NotificationUnit unit = NotificationUnit().fromLinkedHashMap(event.snapshot.value);
      if(!unit.isChecked){
        setState(() {
          newNotificationCount++;
        });
      } else {
        setState(() {
          newNotificationCount--;
        });
      }
    }
  }

  _rOnEntryRemoved(Event event) {
    if(this.mounted){
      NotificationUnit unit = NotificationUnit().fromLinkedHashMap(event.snapshot.value);
      if(!unit.isChecked) {
        setState(() {
          newNotificationCount--;
        });
      }
    }
  }

  onPageChange(int index) {
    setState(() {
      currentIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("ARTIGO", style: TextStyle(color: Colors.black, fontFamily: "Montserrat"),), //TODO ?????? ?????? ??? ????????? ??????
        actions: <Widget>[
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.search),
            color: Colors.black87,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchPage(
                    navigateToMyProfile: (){
                      Navigator.popUntil(context, ModalRoute.withName('/home'));
                      onPageChange(1);
                    },
                  )
              ));
            },
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Badge(
              showBadge: newNotificationCount != 0,
              badgeContent: Text("$newNotificationCount", style: TextStyle(color: Colors.white),),
              child: Icon(Icons.notifications),
            ),
            color: Colors.black87,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NotificationList(currentUser.uid),
              ));
            },
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.edit),
            color: Colors.black87,
            onPressed: () {
              Navigator.push(context,
                  PageTransition(
                    type: PageTransitionType.downToUp,
                    child: EditPost(
                      postCase: 1,
                      currentUser: currentUser,
                      uploader: currentUserInfo,
                      refreshPostList: () {
                        Future.delayed(Duration(seconds: 1), () {
                          postListKey.currentState.handleRefresh();
                        });
                      },
                    ),
                  )
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: <Widget> [
          PostList(
            key: postListKey,
            navigateToMyProfile: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              onPageChange(1);
            },
          ),
          //TodoBoard(),
          //DataBoard(),
          UserProfilePage(
            navigateToMyProfile: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              onPageChange(1);
            },
          ),
          Settings(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: onPageChange,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Container(height: 0,),
          ),
          /*
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            title: Container(height: 0,),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Container(height: 0,),
          ),
           */
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Container(height: 0,),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Container(height: 0,),
          ),
        ],
      ),
    );
  }

}
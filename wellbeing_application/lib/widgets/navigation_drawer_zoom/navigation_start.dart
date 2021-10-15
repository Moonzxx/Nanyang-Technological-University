// @dart=2.10
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:wellbeing_application/screens/journal/journal_homepage.dart';
import 'navigation_page.dart';
import '../../screens/feed/homepagetester3.dart';
import '../../screens/feed/homepagetester2.dart';
import 'navigation_item.dart';


import '../../screens/feed/feed_page.dart';
import '../../screens/journal/journal_homepage.dart';
import '../../screens/profile/profile.dart';
import '../../screens/Display_tips_category.dart';
import '../../screens/forum/forum_mainpage.dart';
import '../../screens/chat/chat_mainpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/user.dart';
import '../../constants.dart';
import '../../utils/helperfunctions.dart';
import '../../screens/tips/tips_mainpage.dart';
import '../../screens/helpline/helpline_mainpage.dart';
import '../../screens/admins/admin_mainpage.dart';


class NavigationHomePage extends StatefulWidget {
  const NavigationHomePage({Key key, this.userUID, this.userDetails}) : super(key: key);
  final String userUID;
  final Map userDetails;
  @override
  _NavigationHomePageState createState() => _NavigationHomePageState();
}

class _NavigationHomePageState extends State<NavigationHomePage> {
  NavigationItem currentItem = NavigationItems.feed;

  @override
  void initState(){
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameInSharedPreference();
    Constants.myUID = await HelperFunctions.getUserUIDInSharedPreference();
    Constants.myAvatar = await HelperFunctions.getUserAvatarInSharedPreference();
  }

  Widget getScreen() {
    switch (currentItem){
      case NavigationItems.feed:
        return HomePageTester3();
        break;
      case NavigationItems.profile:
        return ProfilePage();
        break;
      case NavigationItems.tips:
        return TipsMainPage();
        break;
      case NavigationItems.forums:
        return ForumMainPage();
        break;
      case NavigationItems.journal:
        return JournalHomePage();
        break;
      case NavigationItems.notifications:
        return HomePageTester3();
        break;
      case NavigationItems.chats:
        return ChatMainPage();
        break;
      case NavigationItems.helpline:
        return HelplineMainPage();
        break;
      case NavigationItems.admin:
        return AdminMainPage();
        break;

    }
  }

  /* UserAccnt getUserInfo(){
    UserAccnt client = new UserAccnt();

    // put all information into a list
    //pass list of strings into navigation page
    FirebaseFirestore.instance.collection('users').doc(widget.userUID).get().then((docSnapshot){
      print(docSnapshot.data());
      client.UID = widget.userUID.toString();
      client.firstName = docSnapshot.data()['first_name'].toString();
      client.lastName = docSnapshot.data()['last_name'].toString();
      client.email = docSnapshot.data()['email'].toString();
      client.username = docSnapshot.data()['username'].toString();
      client.avatarURL = docSnapshot.data()['url-avatar'].toString();

      print("client email: ${client.email}");
    }
    );

    return client;

  }

  Map getUserInfoList(){
    List client = [];

    var clientinfo = new Map();

    // put all information into a list
    //pass list of strings into navigation page
    FirebaseFirestore.instance.collection('users').doc(widget.userUID).get().then((docSnapshot){
      print(docSnapshot.data());
      clientinfo['UID'] = widget.userUID.toString();
      clientinfo['email'] =  docSnapshot.data()['email'].toString();
      clientinfo['username']   = docSnapshot.data()['username'].toString();
      clientinfo['avatarURL'] = docSnapshot.data()['url-avatar'].toString();

    }
    );

    return clientinfo;

  } */



  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.Style7,
        borderRadius: 40,
        // can change angle : eg angle: -10
        slideWidth: MediaQuery.of(context).size.width * 0.6,
        showShadow: false,
        backgroundColor: Colors.white,
        menuScreen: Builder(
          builder: (context) => NavigationPage(
            user: widget.userDetails,
            currentItem: currentItem,
            onSelectedItem : (item) {
                setState(() {
                  currentItem = item;
                  ZoomDrawer.of(context).close();
                });
            }
          ),
        ),
        mainScreen: getScreen()
    );

  }
}

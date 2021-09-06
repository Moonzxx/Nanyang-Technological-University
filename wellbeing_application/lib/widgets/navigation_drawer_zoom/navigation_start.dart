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



class NavigationHomePage extends StatefulWidget {
  const NavigationHomePage({Key key}) : super(key: key);

  @override
  _NavigationHomePageState createState() => _NavigationHomePageState();
}

class _NavigationHomePageState extends State<NavigationHomePage> {
  NavigationItem currentItem = NavigationItems.feed;

  Widget getScreen() {
    switch (currentItem){
      case NavigationItems.feed:
        return HomePageTester3();
        break;
      case NavigationItems.profile:
        return HomePageTester3();
        break;
      case NavigationItems.settings:
        return HomePageTester3();
        break;
      case NavigationItems.tips:
        return HomePageTester3();
        break;
      case NavigationItems.forums:
        return HomePageTester3();
        break;
      case NavigationItems.journal:
        return JournalHomePage();
        break;
      case NavigationItems.notifications:
        return HomePageTester3();
        break;
      case NavigationItems.chats:
        return HomePageTester3();
        break;

    }
  }




  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.Style1,
        borderRadius: 40,
        // can change angle : eg angle: -10
        slideWidth: MediaQuery.of(context).size.width * 0.5,
        showShadow: true,
        backgroundColor: Colors.pinkAccent,
        menuScreen: Builder(
          builder: (context) => NavigationPage(
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

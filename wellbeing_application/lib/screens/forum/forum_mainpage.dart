import 'package:flutter/material.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_widget.dart';
import 'forum_homepage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'forum_bookmarked.dart';
import 'forum_myPost.dart';
import '../../constants.dart';


class ForumMainPage extends StatelessWidget {
  const ForumMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Forum',
      home: ForumHome(),
    );
  }
}


class ForumHome extends StatefulWidget {
  const ForumHome({Key? key}) : super(key: key);

  @override
  _ForumHomeState createState() => _ForumHomeState();
}

class _ForumHomeState extends State<ForumHome> {
  int index = 0;

  final items = <Widget>[
    Icon(Icons.forum_rounded, size: 25),
    Icon(Icons.view_list_rounded, size: 25),
    Icon(Icons.bookmark_rounded, size: 25,)
  ];

  final List<Widget> screens = [
    ForumHomePage(),
    UserForumPosts(),
    UserBookmarked()
  ];
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
        title:  Text('Forum', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: systemHeaderFontFamiy)),
        leading: NavigationWidget(),
      ),
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData( color: Colors.white),
        ),
        child: CurvedNavigationBar(
            color: Color(Constants.myThemeColour ).withOpacity(1),
            buttonBackgroundColor:  Color(Constants.myThemeColour ).withOpacity(1),
            backgroundColor: Colors.transparent,
            height: 55, // height of bottom navigationbar
            index: index,
            items: items,      // This initialises the bar
            onTap: (index) {
              setState(() {
                this.index = index;
              });
            }
        ),
      ),
    );
  }
  

  
}


class PlaceholderWidget extends StatelessWidget {
  final Color color;
  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}



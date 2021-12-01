import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer_zoom/navigation_widget.dart';
import '../chat/chat_friendspage.dart';
import 'tips_tipshomepage.dart';
import 'tips_toolshomepage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'tiptools_bookmarked.dart';
import '../../constants.dart';

class TipsMainPage extends StatelessWidget {
  const TipsMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tips',
      home: TipsHome(),
    );
  }
}

class TipsHome extends StatefulWidget {
  const TipsHome({Key? key}) : super(key: key);



  @override
  _TipsHomeState createState() => _TipsHomeState();
}

class _TipsHomeState extends State<TipsHome> {

  int index = 0;

  final items = <Widget>[
    Icon(Icons.book_rounded, size:25),
    Icon(Icons.pan_tool_rounded, size :25),
    Icon(Icons.bookmark_rounded, size :25)
  ];

  final List<Widget> screens =[
    TipsHomePage(),
    ToolsHomePage(),
    TTBookmarked(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
        title: Text("Tips", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: systemHeaderFontFamiy),),
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



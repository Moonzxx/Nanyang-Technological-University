import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../widgets/navigation_drawer.dart';
import 'feed_page.dart';
import 'set_mood_page.dart';
import '../../widgets/navigation_drawer_zoom/navigation_widget.dart';
import '../../screens/journal/round_overview_stats.dart';
import '../../constants.dart';


// Helps to verify the user's authenticity before allowing them to create a profile

class HomePageTester3 extends StatelessWidget {
  const HomePageTester3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     title: 'Feed',
     home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

// Main Homepage for Feed
class _HomeState extends State<Home> {
  int index = 0;

  final items = <Widget>[
    Icon(Icons.feed, size:25),
    Icon(Icons.mood_rounded, size :25)
  ];

  final List<Widget> screens = [
    // Add in widgets here
    //PlaceholderWidget(Colors.lightBlueAccent),
    FeedPage(),
    MoodPage(),
    //MoodPage(),
   // PlaceholderWidget(Colors.green)
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      //drawer: NavDrawer(),
      appBar: AppBar(
        title : Text('Feed'),
        backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
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


// Can be used as a Placeholder for a while
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



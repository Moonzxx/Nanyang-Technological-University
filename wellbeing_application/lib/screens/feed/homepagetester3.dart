import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer.dart';
import 'feed_page.dart';
//import 'set_mood_page.dart';

class HomePageTester3 extends StatelessWidget {
  const HomePageTester3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    // Add in widgets here
    //PlaceholderWidget(Colors.lightBlueAccent),
    PlaceholderWidget(Colors.blue),
    PlaceholderWidget(Colors.deepOrange),
    FeedPage(),
    //MoodPage(),
   // PlaceholderWidget(Colors.green)
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title : Text('Feed'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: "Messages"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile"
          ),
        ],
      ),
    );
  }


  void onTabTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }
}


class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);


  // try to make this page scrollable
  // Be able to add the pages here
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}



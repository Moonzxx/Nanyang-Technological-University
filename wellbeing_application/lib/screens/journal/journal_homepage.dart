import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer.dart';
import 'journal_diary.dart';
import '../../widgets/navigation_drawer_zoom/navigation_widget.dart';
import 'habits/journal_habitsCatList.dart';
import 'routine/journal_daily.dart';

class JournalHomePage extends StatelessWidget {
  const JournalHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal',
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
  // Insert pages here
  final List<Widget> _children = [
    PlaceholderWidget(Colors.pinkAccent),
    Calender(),
    PlaceholderWidget(Colors.indigo),
    DailyGoalsCheck(),
    Habits(),
  ];


  /*
  List of pages and their purposes:

  Routines: Daily habits will be placed here
  Habits: Displaying all the habits and adding of habits (Users are able to create their own categories)
  Journal: Display all Journal entries
  Calendar: Tracking of mood, journal entries and routines completion for that day
  Analysis: Shows the analysis of the current user
   */



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
        leading: NavigationWidget(),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Overview"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Journal"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Calendar"   // tracker
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Daily Tasks"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Habits"
          )
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
      child: Column(
        children: [

        ],
      ),
    );
  }
}


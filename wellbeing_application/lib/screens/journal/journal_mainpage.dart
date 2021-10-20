import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer.dart';
import 'journal_calendar.dart';
import '../../widgets/navigation_drawer_zoom/navigation_widget.dart';
import 'habits/journal_habitsCatList.dart';
import 'routine/journal_daily.dart';
import 'diary/journal_diary.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class JournalHomePage extends StatelessWidget {
  const JournalHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  int index = 0;
  // Insert pages here

  final items = <Widget>[
    Icon(Icons.check_circle, size:25),
    Icon(Icons.list, size :25),
    Icon(Icons.book_rounded, size :25),
    Icon(Icons.calendar_today_rounded, size:25)
  ];

  final List<Widget> screens = [
    DailyGoalsCheck(),
    Habits(),
    DiaryEntryList(),
    Calender(),
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
      extendBody: true,
      appBar: AppBar(
        title: Text('Journal'),
        leading: NavigationWidget(),
      ),
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData( color: Colors.white),
        ),
        child: CurvedNavigationBar(
            color: Colors.blue,
            buttonBackgroundColor: Colors.blue,
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


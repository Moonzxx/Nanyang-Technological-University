import 'package:flutter/material.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_widget.dart';
import 'admin_assignment.dart';
import 'admin_homepage.dart';

class AdminMainPage extends StatelessWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Page',
      home: AdminHome(),
    );
  }
}


class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    AdminHomePage(),
    PlaceholderWidget(Colors.pinkAccent)
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        leading: NavigationWidget(),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Admin'   // Can try to see their colour
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Assignment"
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}


import 'package:flutter/material.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_widget.dart';
import 'helpline_outside.dart';
import 'helpline_school.dart';


class HelplineMainPage extends StatelessWidget {
  const HelplineMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Helplines',
      home : HelplineHome(),
    );
  }
}

class HelplineHome extends StatefulWidget {
  const HelplineHome({Key? key}) : super(key: key);

  @override
  _HelplineHomeState createState() => _HelplineHomeState();
}

class _HelplineHomeState extends State<HelplineHome> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    SchoolHelplinePage(),
    ExternalHelplinePage()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Helpline'),
        leading: NavigationWidget(),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'School'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'External'
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




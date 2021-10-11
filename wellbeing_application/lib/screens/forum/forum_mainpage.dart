import 'package:flutter/material.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_widget.dart';


class ForumMainPage extends StatelessWidget {
  const ForumMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.yellowAccent)
  ];
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum'),
        leading: NavigationWidget(),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Forums"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Saved"
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



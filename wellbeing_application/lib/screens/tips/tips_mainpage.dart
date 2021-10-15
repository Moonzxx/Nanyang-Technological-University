import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer_zoom/navigation_widget.dart';
import '../chat/chat_friendspage.dart';
import 'tips_tipshomepage.dart';
import 'tips_toolshomepage.dart';

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

  int _currentIndex = 0;
  final List<Widget> _children =[
    TipsHomePage(),
    ToolsHomePage(),
    PlaceholderWidget(Colors.blue),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tips"),
        leading: NavigationWidget(),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tips'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Tools"
          ),BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Bookmark"
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}



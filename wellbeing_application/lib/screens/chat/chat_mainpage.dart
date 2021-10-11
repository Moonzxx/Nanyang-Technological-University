import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer_zoom/navigation_widget.dart';
import '../chat/chat_friendspage.dart';

class ChatMainPage extends StatelessWidget {
  const ChatMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chats',
      home: ChatHome(),
    );
  }
}

class ChatHome extends StatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    ChatFriendsPage(),
    PlaceholderWidget(Colors.greenAccent)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatroom'),
        leading: NavigationWidget(),
      ),
    body: _children[_currentIndex],
    bottomNavigationBar: BottomNavigationBar(
      onTap: onTabTapped,
      currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Friends'   // Can try to see their colour
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Messages"
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



import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer_zoom/navigation_widget.dart';
import '../chat/chat_friendspage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'chat_blocked.dart';
import '../../constants.dart';

class ChatMainPage extends StatelessWidget {
  const ChatMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  int index = 0;
  final items = <Widget>[
    Icon(Icons.chat_bubble_rounded, size: 25),
    Icon(Icons.block_rounded, size:25)
  ];

  final List<Widget> screens = [
    ChatFriendsPage(),
    ChatBlocked()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
        title: Text('Chatroom', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: systemHeaderFontFamiy)),
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



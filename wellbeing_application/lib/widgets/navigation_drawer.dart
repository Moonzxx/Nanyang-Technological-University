// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/widgets/choosing_avatar.dart';
import '../screens/profile/profile.dart';
import '../screens/feed/homepagetester2.dart';
import '../widgets/choosing_avatar.dart';
import '../screens/forum/forum_homepage.dart';

/*
Navigation Drawer:
The Display of the Side Menu
 */

class NavDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('Remember to change'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Feed'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                //MaterialPageRoute(builder: (context) => ProfilePage()),);
                MaterialPageRoute(builder: (context) => ChooseAvatar()),);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_rounded),
            title: Text('Settings'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Tips'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Forum'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                //MaterialPageRoute(builder: (context) => ProfilePage()),);
                MaterialPageRoute(builder: (context) => ForumPage()),);
            },
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Journal'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.notifications_none_rounded),      // or notifcations_rounded
            title: Text('Notifications'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.chat_bubble_rounded),    // or chat_bubble_outline_rounded
            title: Text('Chat'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {},
          ),
        ],
      ),
    );



  }
}




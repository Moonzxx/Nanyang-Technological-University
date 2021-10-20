
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navigation_item.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';

class NavigationItems {
  static const feed = NavigationItem('Feed', Icons.feed_rounded);
  static const profile = NavigationItem('Profile', Icons.person_pin_rounded);
  static const tips = NavigationItem('Tips', Icons.lightbulb_rounded);
  static const forums = NavigationItem('Forums', Icons.forum_rounded);
  static const journal = NavigationItem('Journal', Icons.book_rounded);
  // use this as helpline first
  static const notifications = NavigationItem('Notifications', Icons.notification_important_rounded);
  static const chats = NavigationItem('Chats', Icons.messenger_outlined);
  static const helpline = NavigationItem('Helpline', Icons.help_rounded);
  static const admin = NavigationItem('Admin', Icons.admin_panel_settings_rounded);



  static const all = <NavigationItem>[
    profile,
    feed,
    tips,
    journal,
    forums,
    notifications,
    chats,
    helpline,
    admin
  ];
}



class NavigationPage extends StatelessWidget {
  const NavigationPage({Key? key, required this.currentItem, required this.onSelectedItem, required this.user}) : super(key: key);

  // Get user information

  final Map user;
  final NavigationItem currentItem;
  final ValueChanged<NavigationItem> onSelectedItem;

  Widget buildNavigationItem(NavigationItem item) => ListTileTheme(
    selectedColor: Colors.white,
    child: ListTile(
      selectedTileColor: Colors.black26,
      selected: currentItem == item,
      minLeadingWidth: 10,
        leading: Icon(item.icon),
      title: Text(item.title),
      onTap: (){
        onSelectedItem(item);
      },
    ),
  );



  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.blue.shade900,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 70, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Add profile avatar here

                  ListTile(
                    title:Text(user['username'],
                        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)
                    ),
                    subtitle: Text(user['email'],
                    style: TextStyle(color: Colors.white, fontSize:20)
                    ),
                    leading: CircleAvatar(
                      radius: 40,
                      child: Container(
                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(Constants.myAvatar), fit: BoxFit.fill),
                            color: Colors.lightBlue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, style: BorderStyle.solid, width : 1.0)),

                      ),/*ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.network(user['avatarURL'],fit: BoxFit.fill)
                      )*/
                    )
                  ),
                  SizedBox(height: 10),
                  Spacer(),
                  ...NavigationItems.all.map(buildNavigationItem).toList(),
                  Spacer(flex: 2),
                  SizedBox(height: 20),
                  Container(
                    child:Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        label: Text("Log Out"),
                        icon: Icon(Icons.logout_rounded),
                        style: ButtonStyle(

                            backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                            padding: MaterialStateProperty.all(EdgeInsets.all(16)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)))
                        ),
                      ),
                    ),
                  )

                ]
            ),

          ),
        ),
      ),
    );

  }
}

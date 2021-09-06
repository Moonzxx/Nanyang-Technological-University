
import 'package:flutter/material.dart';
import 'navigation_item.dart';

class NavigationItems {
  static const feed = NavigationItem('Feed', Icons.payment);
  static const profile = NavigationItem('Profile', Icons.payment);
  static const settings = NavigationItem('Settings', Icons.payment);
  static const tips = NavigationItem('Tips', Icons.payment);
  static const forums = NavigationItem('Forums', Icons.payment);
  static const journal = NavigationItem('Journal', Icons.payment);
  static const notifications = NavigationItem('Notifications', Icons.payment);
  static const chats = NavigationItem('Chats', Icons.payment);



  static const all = <NavigationItem>[
    feed,
    profile,
    settings,
    tips,
    forums,
    journal,
    notifications,
    chats
  ];
}

class NavigationPage extends StatelessWidget {
  const NavigationPage({Key? key, required this.currentItem, required this.onSelectedItem}) : super(key: key);

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
        backgroundColor: Colors.blueAccent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(),
                ...NavigationItems.all.map(buildNavigationItem).toList(),
                Spacer(flex: 2),
              ]
          ),
        ),
      ),
    );

  }
}

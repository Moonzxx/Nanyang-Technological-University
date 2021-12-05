import 'package:flutter/material.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_widget.dart';
import 'admin_assignment.dart';
import 'admin_homepage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../constants.dart';

class AdminMainPage extends StatelessWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin',
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

  int index = 0;

  final items = <Widget>[
    Icon(Icons.admin_panel_settings_rounded, size:25),
    Icon(Icons.mood_rounded, size :25)
  ];

  final List<Widget> screens = [
    AdminHomePage(),
    AdminAssignment()
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
        title: Text('Admin', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: systemHeaderFontFamiy)),
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


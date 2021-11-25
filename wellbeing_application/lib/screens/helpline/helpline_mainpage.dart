import 'package:flutter/material.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_widget.dart';
import 'helpline_outside.dart';
import 'helpline_school.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../constants.dart';


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

  int index = 0;

  final items = <Widget>[
    Icon(Icons.school_rounded, size:25),
    Icon(Icons.flag_rounded, size :25)
  ];

  final List<Widget> screens = [
    SchoolHelplinePage(),
    ExternalHelplinePage()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
        title: Text('Helpline'),
        leading: NavigationWidget(),
      ),
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData( color: Colors.white),
        ),
        child: CurvedNavigationBar(
            color: Colors.blue,
            buttonBackgroundColor: Colors.blue,
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




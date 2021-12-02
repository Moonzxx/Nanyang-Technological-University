import 'package:flutter/material.dart';
import 'package:wellbeing_application/constants.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_widget.dart';

class AdminNoAccess extends StatefulWidget {
  const AdminNoAccess({Key? key}) : super(key: key);

  @override
  _AdminNoAccessState createState() => _AdminNoAccessState();
}

class _AdminNoAccessState extends State<AdminNoAccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
        title: Text("Admin"),
        leading: NavigationWidget(),
      ),
      body: Center(
        child: Text("NO ACCESS", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontSize: 40, fontWeight: FontWeight.bold)),
      )
    );
  }
}

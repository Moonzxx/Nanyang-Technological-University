import 'package:flutter/material.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_widget.dart';

class UserNotifcations extends StatefulWidget {
  const UserNotifcations({Key? key}) : super(key: key);

  @override
  _UserNotifcationsState createState() => _UserNotifcationsState();
}

class _UserNotifcationsState extends State<UserNotifcations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: NavigationWidget() ,
        backgroundColor: Colors.blue[700],
        title: Text("Notifications", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.delete ))],
      ),
    );
  }
}

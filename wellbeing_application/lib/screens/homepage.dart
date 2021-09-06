// @dart=2.10
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/screens/loginpage.dart';
import 'homepagetester.dart';
import 'feed/homepagetester2.dart';
import 'feed/homepagetester3.dart';
import '../widgets/navigation_drawer_zoom/navigation_start.dart';
import '../widgets/bottom_navigation_home.dart';
import '../screens/feed/journal_overview.dart';


class HomePage extends StatefulWidget {
  final String accountUID;
  //CreateProfile({ this.chosenProfilePic});
  HomePage({Key key, this.accountUID}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Homepage"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              MaterialButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                child: Text("Sign Out")
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JournalOverview()),);
                },
                child: Text("HomePage Tester")
              ),ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NavHomePage()),);
                  },
                  child: Text("HomePage Tester 2")
              ),
        // Testing HomePage with navigation system
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NavigationHomePage()),);
          },
          child: Text("HomePage Tester 3")
          ),


            ],
          ),
        ),
      ),
    );
  }
}


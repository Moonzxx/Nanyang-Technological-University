import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homepagetester.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    MaterialPageRoute(builder: (context) => HomePageTester()),);
              },
              child: Text("HomePage Tester")
            ),
          ],
        ),
      ),
    );
  }
}


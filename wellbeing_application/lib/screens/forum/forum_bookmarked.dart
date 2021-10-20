import 'package:flutter/material.dart';

class UserBookmarked extends StatefulWidget {
  const UserBookmarked({Key? key}) : super(key: key);

  @override
  _UserBookmarkedState createState() => _UserBookmarkedState();
}

class _UserBookmarkedState extends State<UserBookmarked> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text("Bookmarked", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
    );
  }
}

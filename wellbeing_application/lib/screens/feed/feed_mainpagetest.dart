/*

Feed Page
Display what's new, basically a compilation fo their favourite stuff
Display lastest update <--  Shall update once data has been finalised

*/

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'example_data.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';


/*
Need ot get images and title, then link to the pages
 */
class TextFeedPage extends StatefulWidget {
  const TextFeedPage({Key? key}) : super(key: key);

  @override
  _TextFeedPageState createState() => _TextFeedPageState();
}

class _TextFeedPageState extends State<TextFeedPage> {

  int index = 0;

  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.search, size: 30),
    Icon(Icons.favorite, size: 30),
    Icon(Icons.settings, size: 30),
    Icon(Icons.person, size: 30,)
  ];

  final screens = [
    PlaceholderPage(color: Colors.white54),
    PlaceholderPage(color: Colors.white54),
    PlaceholderPage(color: Colors.white54),
    PlaceholderPage(color: Colors.white54),
    PlaceholderPage(color: Colors.white54)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text("Testing"),
      ),
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue,
        buttonBackgroundColor: Colors.purple,
        backgroundColor: Colors.transparent,
        height: 60, // height of bottom navigationbar
          index: index,
        items: items,      // This initialises the bar
      onTap: (index) {
          setState(() {
            this.index = index;
          });
      }
      ),
    );
  }
}

// By default first item is selected, but can cahnage that

class PlaceholderPage extends StatelessWidget {
  final Color color;
  PlaceholderPage({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

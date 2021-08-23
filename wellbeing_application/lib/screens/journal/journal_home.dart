import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'dart:convert';


class JournalHomePage extends StatefulWidget {
  const JournalHomePage({Key? key}) : super(key: key);

  @override
  _JournalHomePageState createState() => _JournalHomePageState();
}

class _JournalHomePageState extends State<JournalHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(kJournalMain),

        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
            label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: "Messages"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Analysis"
            ),
          ],
        ),
      ),
    );
  }
}

class JournalPage extends StatelessWidget {
  const JournalPage({Key? key}) : super(key: key);

  // Create botton navigation

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



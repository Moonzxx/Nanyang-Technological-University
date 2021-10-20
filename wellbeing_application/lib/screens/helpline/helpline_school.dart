import 'package:flutter/material.dart';

class SchoolHelplinePage extends StatefulWidget {
  const SchoolHelplinePage({Key? key}) : super(key: key);

  @override
  _SchoolHelplinePageState createState() => _SchoolHelplinePageState();
}

class _SchoolHelplinePageState extends State<SchoolHelplinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text("School Helpline", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
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

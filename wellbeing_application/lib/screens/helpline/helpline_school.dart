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
        title: Text("School Helpline"),
        centerTitle: true,
      ),
    );
  }
}

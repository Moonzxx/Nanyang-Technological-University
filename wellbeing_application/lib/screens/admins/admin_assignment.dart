import 'package:flutter/material.dart';

class AdminAssignment extends StatefulWidget {
  const AdminAssignment({Key? key}) : super(key: key);

  @override
  _AdminAssignmentState createState() => _AdminAssignmentState();
}

class _AdminAssignmentState extends State<AdminAssignment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text('Assignment'),
        centerTitle: true,
      ),
     // body: ,
    );
  }
}

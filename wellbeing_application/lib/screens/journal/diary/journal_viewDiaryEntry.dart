import 'package:flutter/material.dart';

class ViewDiaryEntry extends StatefulWidget {
  // need to pass the date here to get information
  const ViewDiaryEntry({Key? key}) : super(key: key);

  @override
  _ViewDiaryEntryState createState() => _ViewDiaryEntryState();
}

class _ViewDiaryEntryState extends State<ViewDiaryEntry> {

  @override
  void initState(){
    // can get from previous  diarylist
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title here")
      ),
    );
  }
}


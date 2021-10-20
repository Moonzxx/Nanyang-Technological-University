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
        backgroundColor: Colors.blue[700],
        title: Text("Managing Stress", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.bookmark_rounded, color: Colors.black ))],
      ),
    );
  }
}


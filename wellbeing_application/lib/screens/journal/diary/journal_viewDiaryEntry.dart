// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:wellbeing_application/widgets/custom_AlertBox.dart';
import '../../../constants.dart';
import 'journal_editDiaryEntry.dart';

class ViewDiaryEntry extends StatefulWidget {
  // need to pass the date here to get information
  final String diaryName;
  final String diaryContent;
  final String diaryMood;
  ViewDiaryEntry({this.diaryName, this.diaryContent, this.diaryMood});

  @override
  _ViewDiaryEntryState createState() => _ViewDiaryEntryState();
}

class _ViewDiaryEntryState extends State<ViewDiaryEntry> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text(widget.diaryName, style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
        actions: [IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
        }, icon: Icon(Icons.edit, color: Colors.white )),
          IconButton(onPressed: (){
            CustomAlertBox.deleteDiaryEntryConfirmation(context, "Delete diary Entry?", Constants.myUID, widget.diaryName);
          }, icon: Icon(Icons.delete, color: Colors.white ))],
      ),
      body: SingleChildScrollView(
        child:Column(
          children: [
            Row(
              children: [
                Text("Mood: "),
                SizedBox(width: 20,),
                Text(widget.diaryMood)
              ],
            ),
            SizedBox(height: 30),
            Text("Thoughts"),
            SizedBox(height:10),
            Container(
              height: MediaQuery.of(context).size.height/1.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(widget.diaryContent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


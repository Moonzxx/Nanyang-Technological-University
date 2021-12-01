// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';
import 'journal_viewDiaryEntry.dart';
import 'journal_addDiaryEntry.dart';

class DiaryEntryList extends StatefulWidget {
  const DiaryEntryList({Key key}) : super(key: key);

  @override
  _DiaryEntryListState createState() => _DiaryEntryListState();
}




class _DiaryEntryListState extends State<DiaryEntryList> {
  FirebaseApi databaseMethods = new FirebaseApi();
  Stream UserDiaryEntries;
  bool here = false;



  @override
  void initState(){
    databaseMethods.getUserDiaryEntries(Constants.myUID).then((val){
      setState(() {
        UserDiaryEntries = val;
      });
    });
    //print(Constants.myUID);
    // or check if current date hs beem retrieved. remember tos etstate
    super.initState();
  }


  // try retreiving according to date
  Widget getDiaryEntries(){
    return StreamBuilder(
      stream : UserDiaryEntries,
      builder: (context, snapshot){
        return ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                // sned over content, mood and name
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    ViewDiaryEntry(diaryName: (snapshot.data as QuerySnapshot).docs[index]["name"],
                      diaryContent: (snapshot.data as QuerySnapshot).docs[index]["content"] ,
                      diaryMood: (snapshot.data as QuerySnapshot).docs[index]["mood"],)));
              },
              child: diaryTiles(
                  entryDate: (snapshot.data as QuerySnapshot).docs[index]["name"]
              ),
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
        title: Text("Diary", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
      body: getDiaryEntries(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddDiaryEntry()));
          }, //make sure of bool to make it null,
          child: Icon(Icons.add),
          backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
        ),
      ),
    );
  }
}


class diaryTiles extends StatelessWidget {
  final String entryDate;
  diaryTiles({ this.entryDate});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(this.entryDate)
      ),
    );
  }
}


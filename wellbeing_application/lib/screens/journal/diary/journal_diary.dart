// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';

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
            return diaryTiles(
                entryDate: (snapshot.data as QuerySnapshot).docs[index]["date"]
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
        title: Text("Diary Entries"),
        centerTitle: true,
      ),
      body: getDiaryEntries(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){}, //make sure of bool to make it null,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
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


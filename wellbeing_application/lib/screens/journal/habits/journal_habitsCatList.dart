// @dart=2.10
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'journal_habits_model.dart';
import '../../../constants.dart';
import 'journal_habitsList.dart';

class Habits extends StatefulWidget {
  const Habits({Key key}) : super(key: key);

  @override
  _HabitsState createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {

  FirebaseApi databaseMethods = new FirebaseApi();
  Stream userHabitCatList;



  @override
  void initState(){
    databaseMethods.getUsersHabitCategories(Constants.myUID).then((value){
      setState(() {
        userHabitCatList = value;
      });
    });
    super.initState();
  }

  Widget HabitCatList(){
    return StreamBuilder(
      stream: userHabitCatList,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
         itemCount: (snapshot.data as QuerySnapshot).docs.length ,
          itemBuilder: (context, index){
           return HabitCatTile(habitName: (snapshot.data as QuerySnapshot).docs[index]["name"],
               shortDescp: (snapshot.data as QuerySnapshot).docs[index]["short_description"]);
          },
        ) : Container();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Habits'),
        ),
        // include action to delete and edit(?) category
        body: HabitCatList(),
      floatingActionButton: ElevatedButton.icon(
          onPressed: (){},
          icon: Icon(Icons.add),
          label: Text("Add a new cateogry")),
    );
  }
}

class HabitCatTile extends StatelessWidget {
  final String habitName;
  final String shortDescp;
  HabitCatTile({ this.habitName,  this.shortDescp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HabitsList(categoryName: this.habitName)));
      },
      child: Card(
        color: Colors.redAccent,
        child: ListTile(
          title: Text(this.habitName),
          subtitle: Text(this.shortDescp),
          trailing: Icon(Icons.arrow_forward_rounded)
        ),
      ),
    );
  }
}

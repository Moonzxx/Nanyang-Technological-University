// @dart=2.10
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wellbeing_application/screens/journal/habits/journal_habit_description.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';
import 'journal_habits_add.dart';

/*
Purpose of this page: To list all the habits in that specific category
 */

class HabitsList extends StatefulWidget {
  final String categoryName;
  HabitsList({ this.categoryName});

  @override
  _HabitsListState createState() => _HabitsListState();
}

class _HabitsListState extends State<HabitsList> {

  FirebaseApi databaseMethods = new FirebaseApi();
  Stream userHabitList;

  @override
  void initState(){
    databaseMethods.getUsersHabitsfromCategory(Constants.myUID, widget.categoryName).then((value){
      setState(() {
        userHabitList = value;
      });
    });
    super.initState();
  }

  Widget HabitList(){
    return StreamBuilder(
      stream: userHabitList,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length ,
          itemBuilder: (context, index){
            return HabitTile(habitName: (snapshot.data as QuerySnapshot).docs[index]["name"],
              habitDescription: (snapshot.data as QuerySnapshot).docs[index]["description"],
              habitdays: (snapshot.data as QuerySnapshot).docs[index]["days"],
              habitActivation: (snapshot.data as QuerySnapshot).docs[index]["activated"],
            );
          },
        ) : Center(
            child: Align(
              alignment: Alignment.center,
              child: Text("No Habits", style: TextStyle(color: Colors.black)),
            ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),

      body: HabitList(),
      floatingActionButton: ElevatedButton.icon(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                AddNewHabit(categoryName: widget.categoryName)));
          },
          icon: Icon(Icons.add),
          label: Text("Add a new habit")),
    );
  }

}

class HabitTile extends StatelessWidget {
  final String habitName;
  final String habitDescription;
  final bool habitActivation;
  final List habitdays;
  HabitTile({ this.habitName, this.habitDescription, this.habitdays, this.habitActivation});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            HabitDescription(Hname: this.habitName, Hdescription: this.habitDescription,
                Hactivation: this.habitActivation, Hdays: this.habitdays)));
      },
      child: Card(
        color: Colors.pink,
        child: ListTile(
            title: Text(this.habitName),
            trailing: Icon(Icons.arrow_forward_rounded)
        ),
      ),
    );
  }
}
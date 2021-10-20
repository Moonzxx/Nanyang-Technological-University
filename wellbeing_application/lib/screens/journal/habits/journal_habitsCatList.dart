// @dart=2.10
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';
import 'journal_habitsList.dart';
import 'journal_cat_add.dart';

class Habits extends StatefulWidget {
  const Habits({Key key}) : super(key: key);

  @override
  _HabitsState createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {

  FirebaseApi databaseMethods = new FirebaseApi();
  Stream userHabitCatList;
  List<Color> colors = [Colors.blue, Colors.green, Colors.pinkAccent,Colors.deepPurpleAccent, Colors.yellow, Colors.blueGrey];



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
               shortDescp: (snapshot.data as QuerySnapshot).docs[index]["short_description"],
           colors: colors[index],);
          },
        ) : Container();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text("Habits", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
        // include action to delete and edit(?) category
        body: HabitCatList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: ElevatedButton.icon(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => JournalCatAdd()
                  ));
            },
            icon: Icon(Icons.add),
            label: Text("Add a new cateogry")),
      ),
    );
  }
}

class HabitCatTile extends StatelessWidget {
  final String habitName;
  final String shortDescp;
  final Color colors;
  HabitCatTile({ this.habitName,  this.shortDescp, this.colors});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HabitsList(categoryName: this.habitName)));
      },
      child: Card(
        color: this.colors,
        child: ListTile(
          title: Text(this.habitName),
          subtitle: Text(this.shortDescp),
          trailing: Icon(Icons.arrow_forward_rounded)
        ),
      ),
    );
  }
}

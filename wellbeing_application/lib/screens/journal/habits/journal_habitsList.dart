// @dart=2.10
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wellbeing_application/screens/journal/habits/journal_habit_description.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';
import 'journal_habits_add.dart';
import '../../../widgets/custom_AlertBox.dart';
import 'journal_ editCategory.dart';

/*
Purpose of this page: To list all the habits in that specific category
 */

class HabitsList extends StatefulWidget {
  final String categoryName;
  final int catColour;
  final String HDescription;
  HabitsList({ this.categoryName, this.catColour, this.HDescription});

  @override
  _HabitsListState createState() => _HabitsListState();
}

class _HabitsListState extends State<HabitsList> {

  bool mainCategory = false;
  FirebaseApi databaseMethods = new FirebaseApi();
  Stream userHabitList;

  @override
  void initState(){
    databaseMethods.getUsersHabitsfromCategory(Constants.myUID, widget.categoryName).then((value){
      setState(() {
        userHabitList = value;
        if(widget.categoryName == "Be Aware" || widget.categoryName == "Be Active" ||  widget.categoryName == "Help Others" ||  widget.categoryName == "Connect" || widget.categoryName == "Keep Learning" ){
          mainCategory = true;
        }
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
              colors: widget.catColour,
              habitCat: widget.categoryName,
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



  /*
  AppBar(
        title: Text(widget.categoryName, style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,

        actions: (mainCategory == true) ? [IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.grey )),
          IconButton(onPressed: (){}, icon: Icon(Icons.delete, color: Colors.grey ))]
          : [IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.white )),
    IconButton(onPressed: (){
    //CustomAlertBox.deleteDiaryEntryConfirmation(context, "Delete diary Entry?", Constants.myUID, widget.diaryName);
    }, icon: Icon(Icons.delete, color: Colors.white ))],
        bottom: PreferredSize(
    preferredSize: Size.fromHeight(100),
    child: Container(
    margin: EdgeInsets.all(20),
    height: MediaQuery.of(context).size.height/10,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
    color: Colors.black
    )
    ),
    child: Scrollbar(
    child: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(child: Text(widget.HDescription, style: TextStyle(fontFamily: systemHeaderFontFamiy)))
    ),
    ),
    )
    ),
    ),
      ),
   */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (mainCategory == true) ? AppBar(
        title: Text(widget.categoryName, style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.blueGrey )),
    IconButton(onPressed: (){
    //CustomAlertBox.deleteDiaryEntryConfirmation(context, "Delete diary Entry?", Constants.myUID, widget.diaryName);
    }, icon: Icon(Icons.delete, color: Colors.blueGrey ))],
        bottom: PreferredSize(
    preferredSize: Size.fromHeight(100),
    child: Container(
    margin: EdgeInsets.all(20),
    height: MediaQuery.of(context).size.height/10,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
    color: Colors.black
    )
    ),
    child: Scrollbar(
    child: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(child: Text(widget.HDescription, style: TextStyle(fontFamily: systemHeaderFontFamiy)))
    ),
    ),
    )
    ),
    ),
      ):
      AppBar(
        title: Text(widget.categoryName, style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,

        actions: [IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditCategory(selectedCat: widget.categoryName,)
          ));
        }, icon: Icon(Icons.edit, color: Colors.white )),
          IconButton(onPressed: (){
            CustomAlertBox.deleteJournalCategory(context, "Delete Category? ", Constants.myUID, widget.categoryName);
            //CustomAlertBox.deleteDiaryEntryConfirmation(context, "Delete diary Entry?", Constants.myUID, widget.diaryName);
          }, icon: Icon(Icons.delete, color: Colors.white ))],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
              margin: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height/10,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: Colors.black
                  )
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text(widget.HDescription, style: TextStyle(fontFamily: systemHeaderFontFamiy)))
                  ),
                ),
              )
          ),
        ),
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
  final String habitCat;
  final int colors;
  HabitTile({ this.habitName, this.habitDescription, this.habitdays, this.habitActivation, this.colors, this.habitCat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            HabitDescription(Hname: this.habitName, Hdescription: this.habitDescription,
                Hactivation: this.habitActivation, Hdays: this.habitdays, Hcat: this.habitCat)));
      },
      child: Card(
        color: Color(this.colors).withOpacity(1),
        child: ListTile(
            title: Text(this.habitName),
            trailing: Icon(Icons.arrow_forward_rounded)
        ),
      ),
    );
  }
}
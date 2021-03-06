// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';
//import 'package:flutter/scheduler.dart' show timeDilation;

// Creation to show checkboxes and print out what has been completed
class DailyGoalsCheck extends StatefulWidget {
  const DailyGoalsCheck({Key key}) : super(key: key);

  @override
  _DailyGoalsCheckState createState() => _DailyGoalsCheckState();
}

// Need to add radio buttons for check of lists and habits

class _DailyGoalsCheckState extends State<DailyGoalsCheck> {
  // default is the current date
  bool selected = false;
  FirebaseApi databaseMethods = new FirebaseApi();
  String currentDay = DateFormat('E').format(DateTime.now());
  DateTime selectedDate = DateTime.now();
  String selectedDay;
  QuerySnapshot UserCatList;
  List<String> RoutineCategories = [];

  List morningRoutine = [];
  List afternoonRoutine = [];
  List eveningRoutine = [];
  List nightRoutine = [];
  List<double> cat = [1,1,1,0,0,1,0,1,0,0,1];

  List<String> categories;

 /* bool _decideWhichDayToEnable(DateTime day){
    bool _decideWhichDayToEnable(DateTime day) {
      if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
          day.isBefore(DateTime.now().add(Duration(days: 10))))) {
        return true;
      }
      return false;
    }
  }


  */
  Future<void> testRoutine(List categories, int numCategories, String selectedDay) async{
    morningRoutine = [];
    afternoonRoutine = [];
    eveningRoutine = [];
    nightRoutine = [];

    // check is UserCatStream is null
    for(var j = 0; j < numCategories; j++) {
      QuerySnapshot UserCatStream;
      databaseMethods.getUserRoutineInformation(Constants.myUID, categories[j], selectedDay).then((val){
        setState(() {
          UserCatStream = val;
          for (var i = 0; i < UserCatStream.docs.length; i++) {

            // working
            // Make sure the database is constant
            //May not have routine
            var details = new Map();
            print(UserCatStream.docs[i]["name"]);
            details['name'] = UserCatStream.docs[i]["name"];
            details['description'] = UserCatStream.docs[i]["description"];
            details['time_hour'] = UserCatStream.docs[i]["time_hour"];
            details['time_minute'] = UserCatStream.docs[i]["time_minute"];
            details['categoryName'] = UserCatStream.docs[i]["categoryName"];
            details['partOfDay'] = UserCatStream.docs[i]["partOfDay"];
            details['currSeen'] = DateFormat('yyyy-MM-dd').format(selectedDate);
            details['completion'] = UserCatStream.docs[i]["completed"];
            details['check'] = false;

            for(var k = 0; k < details['completion'].length; k++){
              if(details['completion'][k] == details['currSeen']){
                print(details['completion'][k]);
                print(details['currSeen']);
                details['check'] = true;
              }
            }

            //rName.add(UserCatStream.docs[i]["name"]);
            //rDescp.add(UserCatStream.docs[i]["description"]);
            String partDay = UserCatStream.docs[i]["partOfDay"];
            if(partDay == "Morning"){
              morningRoutine.add(details);
            }
            else if(partDay == "Afternoon"){
              print(details);
              afternoonRoutine.add(details);
            }
            else if(partDay == "Evening"){
              eveningRoutine.add(details);
            }
            else{
              nightRoutine.add(details);
            }

          }
        });
      });
    }




   // for(var i = 0; i > UserCatStream.docs.length; i++){
    //  print( UserCatList.docs[i]["name"]);
  // }

  }


  // Need to show routines for that day
  /*List RoutineList(List cats, int numCats, String day){
    List<String> rName;
    List<String> rDescription;

    for(var i = 0; i >= numCats; i++){
      Stream userCatStream;
      databaseMethods.getUsersHabitRoutinefromCategory(Constants.myUID, cats[i], day).then((val){
        setState(() {
          userCatStream = val;
        });
      });
      StreamBuilder(
        stream: userCatStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            int checks = (snapshot.data as QuerySnapshot).docs.length;
            for(var i = 0; i > checks; i++){
              print((snapshot.data as QuerySnapshot).docs[i]["name"]);
              rName.add((snapshot.data as QuerySnapshot).docs[i]["name"]);
              rDescription.add((snapshot.data as QuerySnapshot).docs[i]["description"]);
            }

          }
        }
      );
      print(rName);
      return rName;
    }

  }

   */
  /*
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
   */

  Widget getRoutines(List routineList){
    return ListView.builder(
        itemCount: routineList.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          print(index);
          return RoutineTile(rTitle: routineList[index]['name'],
          rDescription: routineList[index]['description'],
          rCategory: routineList[index]['categoryName'],
          rPartOfDay: routineList[index]['partOfDay'],
          rHour: routineList[index]['time_hour'],
          rMinute: routineList[index]['time_minute'],
          checkCurrDate: routineList[index]['currSeen'],
          completion: routineList[index]['completion'],
          check: routineList[index]['check'],);
        },
    );
  }


  initialise(){
    RoutineCategories = [];
    databaseMethods.getUsersNumCategories(Constants.myUID).then((value){
      setState(() {
        UserCatList = value;
        for(var a = 0; a < UserCatList.docs[0]["userCategories"].length; a++){
          String cat = UserCatList.docs[0]["userCategories"][a];
          bool checkRoutine = UserCatList.docs[0]["userHabits"][cat][2];
          if(checkRoutine == true){
            RoutineCategories.add(cat);
          }
        }
        // print(UserCatList.docs[0]["userHabits"]);
        //print(UserCatList.docs[0]["userHabits"]["Connect"][2]);
        // testRoutine(UserCatList.docs[0]["userCategories"],UserCatList.docs[0]["userCategories"].length, "Tue");


        testRoutine(RoutineCategories,RoutineCategories.length, selectedDay);
      });

      //print(UserCatList.docs[0]["userCategories"]);
      // print(UserCatList.docs[0]["userCategories"].length);

    });
  }

  initialiseStart2(String currDay) {
    RoutineCategories = [];
    databaseMethods.getUserCategories(Constants.myUID).then((val) async {
      setState(() async {
        UserCatList = val;   // usercat lsit
        List<DocumentSnapshot> collDocs = UserCatList.docs;
        for(var i = 0; i < collDocs.length; i++){
          String cat = collDocs[i]["name"];
          bool checkRoutine = false;
          // checking if any routines are activated
          QuerySnapshot routineColl = await FirebaseFirestore.instance.collection("habits").doc(Constants.myUID).collection("categories").doc(cat).collection("routines").get();
          if(routineColl.docs.length != 0){
            for(var a = 0; a < routineColl.docs.length; a++){
              if(routineColl.docs[a]["activated"] == true){
                RoutineCategories.add(cat);
                // It is working
                print("here");
                print(cat);
                break;
              }
            }
          }

        }
        testRoutine(RoutineCategories,RoutineCategories.length, currDay);
      });


    }

    );


  }

  // Initialise start with current say
  // checking for routine for the day
  initialiseStart(String currDay){
    RoutineCategories = [];
    databaseMethods.getUsersNumCategories(Constants.myUID).then((value){
      setState(() {
         // getting number of categories from user
        UserCatList = value;
        // for loop user categories
        for(var a = 0; a < UserCatList.docs[0]["userCategories"].length; a++){
          //
          String cat = UserCatList.docs[0]["userCategories"][a];
          bool checkRoutine = UserCatList.docs[0]["userHabits"][cat][2];
          // Checking if there is any activated??
          if(checkRoutine == true){
            RoutineCategories.add(cat);
          }
        }
        // print(UserCatList.docs[0]["userHabits"]);
        //print(UserCatList.docs[0]["userHabits"]["Connect"][2]);
        // testRoutine(UserCatList.docs[0]["userCategories"],UserCatList.docs[0]["userCategories"].length, "Tue");

        // Dividing all the routines accordingly (?)
        testRoutine(RoutineCategories,RoutineCategories.length, currDay);
      });

      //print(UserCatList.docs[0]["userCategories"]);
      // print(UserCatList.docs[0]["userCategories"].length);

    });
  }

  @override
  void initState(){
    initialiseStart2(currentDay);
    super.initState();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        selectedDay = DateFormat('E').format(selectedDate);
        print(selectedDate);
        print(DateFormat('E').format(selectedDate));
        print(DateFormat('yyyy-MM-dd').format(selectedDate));
        //testRoutine(RoutineCategories,RoutineCategories.length, selectedDay);
        initialise();
      });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
        title: Text("Daily Goals", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),

            child: GestureDetector(
              onTap: (){
                selectDate(context);
              },
              child: Icon(
                  Icons.calendar_today_rounded,
                  size: 26.0
              ),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            // To display Morning Title
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/12,
            decoration: BoxDecoration(
                color: Colors.indigo,
                border: Border.all(color: Colors.black, width: 2)
            ),
            child: Align(
                alignment: Alignment.center,
                child:
                Text("Morning",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0),)),

          ),
            getRoutines(morningRoutine),
            SizedBox(height: 20),
            // To display Morning Title
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/12,
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  border: Border.all(color: Colors.black, width: 2)
              ),
              child: Align(
                  alignment: Alignment.center,
                  child:
                  Text("Afternoon",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0),)),

            ),
            getRoutines(afternoonRoutine),
            SizedBox(height: 20),
            // To display Morning Title
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/12,
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  border: Border.all(color: Colors.black, width: 2)
              ),
              child: Align(
                  alignment: Alignment.center,
                  child:
                  Text("Evening",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0),)),

            ),
            getRoutines(eveningRoutine),

            SizedBox(height: 20),
            // To display Morning Title
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/12,
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  border: Border.all(color: Colors.black, width: 2)
              ),
              child: Align(
                  alignment: Alignment.center,
                  child:
                  Text("Night",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0),)),

            ),
            getRoutines(nightRoutine),

          ],
        ),
      ), /* Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            routineHeaders(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/12,
                Colors.lightBlue, "Morning", Colors.white, 40.0),
            getRoutines(morningRoutine),
            SizedBox(height: 15),
            routineHeaders(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/12,
                Colors.orangeAccent, "Afternoon", Colors.white, 40.0),
            getRoutines(afternoonRoutine),
            SizedBox(height: 15),
            routineHeaders(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/12,
                Colors.deepOrangeAccent, "Evening", Colors.white, 40.0),
            getRoutines(eveningRoutine),
            SizedBox(height: 15),
            routineHeaders(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/12,
                Colors.blueGrey, "Night", Colors.white, 40.0),
            getRoutines(nightRoutine),

          ],

        ),*/

      );

  }

}



// Maybe can add background images for the different parts of the days and darken the background to make words pop
Container routineHeaders(double headerWidth, double headerHeight, colour, String partOfTheDay, textColour, double textFontSize){
  return Container(
    width: headerWidth,
    height: headerHeight,
    decoration: BoxDecoration(
      color: colour,
      border: Border.all(color: Colors.black, width: 2)
    ),
    child: Align(
        alignment: Alignment.center,
        child:
        Text(partOfTheDay,
          style: TextStyle(
              color: textColour,
              fontSize: textFontSize),)),

  );
}

class RoutineTile extends StatefulWidget {
  final String rTitle;
  final String rDescription;
  final int rHour;
  final int rMinute;
  final String rCategory;
  final String rPartOfDay;
  final String checkCurrDate;
  final List completion;
   bool check;
  RoutineTile({this.rTitle, this.rDescription, this.rHour, this.rMinute, this.rCategory, this.rPartOfDay, this.checkCurrDate, this.completion, this.check});

  @override
  _RoutineTileState createState() => _RoutineTileState();
}

class _RoutineTileState extends State<RoutineTile> {
  FirebaseApi databaseMethods = new FirebaseApi();
  QuerySnapshot rTile;


  // have current completion data
  // if completion array is empty, just need to set (Need to check that array is created)
  // if checked = update array on completed[append] and notcomplete[remove]
  // If unchecked = update array on complete[removed if not added yet] and notcompleted[append]
  bool setNewCompletionState(bool checks){
    if(checks == false){
        databaseMethods.UpdateUserRoutineCompletionTileUnchecked(Constants.myUID, widget.rCategory, widget.rTitle, widget.checkCurrDate).then((val){
          setState(() {
            widget.completion.remove(widget.checkCurrDate);
          });
        });

        // do we need to initstate? check
    }
    else{
        databaseMethods.UpdateUserRoutineCompletionTileChecked(Constants.myUID, widget.rCategory, widget.rTitle, widget.checkCurrDate).then((val){
          setState(() {
            widget.completion.add(widget.checkCurrDate);
          });
        });

    }
  }

  
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(widget.rTitle),
        value: widget.check,
        activeColor: Colors.grey,
        onChanged: (bool newValue){
          setState(() {
            widget.check = newValue;
            setNewCompletionState(widget.check);
          });
        },
          secondary: Icon(Icons.hourglass_empty)
      );
  }
}

/*

Feed Page
Display what's new, basically a compilation fo their favourite stuff
Display lastest update <--  Shall update once data has been finalised

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'example_data.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../constants.dart';
import 'package:intl/intl.dart';

/*
Need ot get images and title, then link to the pages
 */

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;



class _FeedPageState extends State<FeedPage> {

  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  FirebaseApi databaseMethods = new FirebaseApi();
  //DateTime.now().millisecondsSinceEpoch
  //DateTime date = new DateTime.fromMillisecondsSinceEpoch(1486252500000)

  // mapping for wellbeing scores
  List wholeUserWellbeing = [];


  var currentPage = images.length - 1.0;
  List eg = [[1.0, Colors.blue, "Be Active"],
    [0.0, Colors.green, "Be Aware"],
    [0.0, Colors.pinkAccent, "Connect"],
    [0.0, Colors.deepPurpleAccent, "Keep Learning"],
    [0.0, Colors.yellow, "Help Others"]];

  /*
  QuerySnapshot coll = await FirebaseFirestore.instance.collection("diary").doc(Constants.myUID).collection("diaryEntries").orderBy("date", descending: false).get();
    List<DocumentSnapshot> collDocs = coll.docs;
    it is retrieving from the earliest to least

    for(var i = 0; i < collDocs.length; i++){
      DateTime date = new DateTime.fromMillisecondsSinceEpoch(collDocs[i]["date"]);
      String convertedDate = DateFormat('yyyy-MM-dd').format(date);
      // currentDate exist in database
      if(currentDate == convertedDate){
        //check for updates
        checker++;
      }
    }
   */

  calculateUserWellbeingTwo(List categories) async{
    // Should consist maps of cats and values?

    // traverse through map by traversing though categories that user have

    QuerySnapshot coll = await FirebaseFirestore.instance.collection("users").doc(Constants.myUID).collection("wellbeing").orderBy("datetime", descending: false).get();
    List<DocumentSnapshot> collDocs = coll.docs;
    //collDocs[i]['wellbeing']
    // Traverse through categories first
    for(var i = 0; i < categories.length; i++){
      List catDailyWellbeing = [];
      String category = categories[i];
      // Traversing through dates
      for(var a =0; a < collDocs.length; a++){
        print(collDocs[a]);
        //get daily wellbeing information (each date)
        Map<String, dynamic> wellbeing = new Map();
        wellbeing = collDocs[a]['wellbeing'];
        // getting daily dates category info
        //print("wellbeing: " + wellbeing.toString());
        if(wellbeing[category] == 1.0 || wellbeing[category] == 0.0){
          catDailyWellbeing.add(wellbeing[category]);
        }


      }
      //After traversing through the dates
      // calculate prediction
      print(category);
      print(catDailyWellbeing);
      double userCatWellbeing = calculateWellB(0.4, catDailyWellbeing);
      //save cat results

      List savingCatResults = [];
      savingCatResults.add(userCatWellbeing);
      savingCatResults.add(Colors.blueGrey);    //can sub colourhere
      savingCatResults.add(category);
      // can add in colour if needed!
      setState(() {
        wholeUserWellbeing.add(savingCatResults);
      });

    }
    print(wholeUserWellbeing);
    // After traversing all categories and calculating their prediction
    // display results

  }


  double calculateWellB(double a, List catWellbeing){
    double wb = 0.0;
    //Alpha controls the rate of learning
    double alpha = a;

    for(var i = 0; i < catWellbeing.length; i++){
      if(i == 0){
        wb = catWellbeing[i];
      }
      else{
        wb = wb + (alpha * (catWellbeing[i-1] - wb));
      }
    }
    return wb;
  }


  getUserWellbeingInfo() async{

    List allCat = [];
    List completedCat = [];

    // can remove if else

    DocumentSnapshot coll = await FirebaseFirestore.instance.collection("users").doc(Constants.myUID).collection("wellbeing").doc(currentDate).get();
    if(coll.exists){
     //update
      QuerySnapshot userHabitsColl = await FirebaseFirestore.instance.collection("habits").doc(Constants.myUID).collection("categories").get();
      List<DocumentSnapshot> userHabitDocs = userHabitsColl.docs;
      // traverse through the categories
      for(var i = 0; i < userHabitDocs.length; i++){
        // Traverse through habits from the category
        String cat = userHabitDocs[i]["name"];
        allCat.add(cat);
        QuerySnapshot userHabitCat = await FirebaseFirestore.instance.collection("habits").doc(Constants.myUID).collection("categories").doc(cat).collection("routines").get();
        List<DocumentSnapshot> userHabitCatRoutines = userHabitCat.docs;
        // Go through each habits and see if it is completed on that dat
        for(var a = 0; a < userHabitCatRoutines.length; a++){
          List completed = userHabitCatRoutines[a]["completed"];
          for(var b = 0; b < completed.length; b++){
            if(completed[b] == currentDate){
              completedCat.add(cat);
              // put the cat name on the list
            }
          }

        }

      }
      // returns unique identifier inside completedCat List
      completedCat = completedCat.toSet().toList();

      // creation of map to set into database
      Map<String, dynamic> categoryWellbeing = new Map();
      for(var c= 0 ; c < allCat.length; c++){
        bool checked = false;
        for(var d= 0; d < completedCat.length; d++){
          if(allCat[c] == completedCat[d]){
            categoryWellbeing[allCat[c]] = 1.0;
            checked = true;
          }
        }
        if(checked != true){
          categoryWellbeing[allCat[c]] = 0.0;
        }
      }

      Map<String, dynamic> dailyUserWellbeing = {
        "name": currentDate,
        "datetime": DateTime.now().millisecondsSinceEpoch,
        "wellbeing" : categoryWellbeing// insert map
      };
      databaseMethods.updateUserCurrentDayWellbeing(Constants.myUID, currentDate, dailyUserWellbeing);
      calculateUserWellbeingTwo(allCat);
    }
    else{
      //set
      // go through all user habit categories
      QuerySnapshot userHabitsColl = await FirebaseFirestore.instance.collection("habits").doc(Constants.myUID).collection("categories").get();
      List<DocumentSnapshot> userHabitDocs = userHabitsColl.docs;
      // traverse through the categories
      for(var i = 0; i < userHabitDocs.length; i++){
        // Traverse through habits from the category
        String cat = userHabitDocs[i]["name"];
        allCat.add(cat);
        QuerySnapshot userHabitCat = await FirebaseFirestore.instance.collection("habits").doc(Constants.myUID).collection("categories").doc(cat).collection("routines").get();
        List<DocumentSnapshot> userHabitCatRoutines = userHabitCat.docs;
        // Go through each habits and see if it is completed on that dat
        for(var a = 0; a < userHabitCatRoutines.length; a++){
          List completed = userHabitCatRoutines[a]["completed"];
          for(var b = 0; b < completed.length; b++){
            if(completed[b] == currentDate){
              completedCat.add(cat);
              // put the cat name on the list
            }
          }

        }

      }
      // returns unique identifier inside completedCat List
      completedCat = completedCat.toSet().toList();

      // creation of map to set into database
      Map<String, dynamic> categoryWellbeing = new Map();
      for(var c= 0 ; c < allCat.length; c++){
        bool checked = false;
        for(var d= 0; d < completedCat.length; d++){
          if(allCat[c] == completedCat[d]){
            categoryWellbeing[allCat[c]] = 1.0;
            checked = true;
          }
        }
        if(checked != true){
          categoryWellbeing[allCat[c]] = 0.0;
        }
      }

      Map<String, dynamic> dailyUserWellbeing = {
        "name": currentDate,
        "datetime": DateTime.now().millisecondsSinceEpoch,
        "wellbeing" : categoryWellbeing// insert map
      };
      databaseMethods.updateUserCurrentDayWellbeing(Constants.myUID, currentDate, dailyUserWellbeing);
      calculateUserWellbeingTwo(allCat);
      //Once check comeptled, add the daily result touser wellbeing current day

    }



   // print("Converted Date: " + convertedDate);

    // check if current date exist
    // if exist, ?
    // if does not exist, set a new map (How)
      // get the user habit categories
      // as long as one habit is completed on that day from that cat, cat gets 1
      // if not, cat will get 0
      // save the results for that category into map
      // check other cats
      // once all cat checks are done
      // save map into




  }


  @override
  void initState(){
    getUserWellbeingInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    PageController controller = PageController(initialPage: images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page!;
        print(Colors.blue[700]);
      });
    });


    getGridView(){
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            childAspectRatio: 1,
            crossAxisSpacing: 60,
            mainAxisSpacing: 60
        ),
        itemCount: wholeUserWellbeing.length,
        itemBuilder: (BuildContext ctx, index){
          return roundstats(percentage: wholeUserWellbeing[index][0], cat: wholeUserWellbeing[index][2]);
          //return roundstats(percentage: eg[index][0], color: wholeUserWellbeing[index][1], cat: wholeUserWellbeing[index][2]);
        },
         );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
        title: Text("Wellbeing", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
      body: getGridView()
    );
  }
}




class roundstats extends StatelessWidget {
  final double percentage;
  final String cat;
  //final Color color;
  roundstats({ required this.percentage, required this.cat});
  //roundstats({ required this.percentage, required this.color, required this.cat});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 13.0,
      animation: true,
      percent: this.percentage, // Have ot be double
      center: Text(
        "${this.percentage*100}%",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0
        ),
      ),
      footer: Text(
        cat,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 17.0
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.blue,
    );
  }
}

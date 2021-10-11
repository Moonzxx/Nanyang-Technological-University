// @dart=2.10
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Creation to show checkboxes and print out what has been completed
class DailyGoalsCheck extends StatefulWidget {
  const DailyGoalsCheck({Key key}) : super(key: key);

  @override
  _DailyGoalsCheckState createState() => _DailyGoalsCheckState();
}

// Need to add radio buttons for check of lists and habits

class _DailyGoalsCheckState extends State<DailyGoalsCheck> {
  // default is the current date
  DateTime selectedDate = DateTime.now();

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

  // Need to show routines for that day
  Widget RoutineList(String day){


  }

  @override
  void initState(){

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
        print(selectedDate);
        print(DateFormat('E').format(selectedDate));
        print(DateFormat('yyyy-MM-dd').format(selectedDate));
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Daily Goals"),
        actionsIconTheme: IconThemeData(
          size: 30.0,
          color: Colors.black,
          opacity: 10.0
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
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            routineHeaders(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/12,
                Colors.lightBlue, "Morning", Colors.white, 40.0),
            SizedBox(height: 15),
            routineHeaders(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/12,
                Colors.orangeAccent, "Afternoon", Colors.white, 40.0),
            SizedBox(height: 15),
            routineHeaders(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/12,
                Colors.deepOrangeAccent, "Evening", Colors.white, 40.0),
            SizedBox(height: 15),
            routineHeaders(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/12,
                Colors.blueGrey, "Night", Colors.white, 40.0),
          ],
        ),
      ),
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

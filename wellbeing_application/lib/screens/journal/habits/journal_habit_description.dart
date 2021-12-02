// @dart=2.10
import 'package:flutter/material.dart';
import 'package:day_picker/day_picker.dart';
import '../../../constants.dart';


class HabitDescription extends StatefulWidget {
  final String Hname;
  final String Hdescription;
  final bool Hactivation;
  final List Hdays;
  HabitDescription({  this.Hname,  this.Hdescription,  this.Hactivation,  this.Hdays});

  @override
  _HabitDescriptionState createState() => _HabitDescriptionState();
}

class _HabitDescriptionState extends State<HabitDescription> {

  String daysActivated;

  getdaysActivated(List days){
    setState(() {
      daysActivated = widget.Hdays.join(", ");
    });
  }

  @override
  void initState(){
    getdaysActivated(widget.Hdays);
    super.initState();
  }


  List<DayInWeek> _days = [
    DayInWeek(
      "Mon",
    ),
    DayInWeek(
      "Tue",

    ),
    DayInWeek(
      "Wed",
    ),
    DayInWeek(
      "Thu",
    ),
    DayInWeek(
      "Fri",
    ),
    DayInWeek(
      "Sat",
    ),
    DayInWeek(
      "Sun",
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
          title: Text( widget.Hname, style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
          centerTitle: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                //top: Radius.circular(30),
                  bottom: Radius.circular(30)
              )
          ),
          actions:  [IconButton(onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
          }, icon: Icon(Icons.edit, color: Colors.white )),
            IconButton(onPressed: (){
              //CustomAlertBox.deleteDiaryEntryConfirmation(context, "Delete diary Entry?", Constants.myUID, widget.diaryName);
            }, icon: Icon(Icons.delete, color: Colors.white ))],
        ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(widget.Hname),
              Text(widget.Hdescription),
              Text(daysActivated),
              Text((widget.Hactivation) ? "Yes" : "No"),

              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectWeekDays(
                    days: _days,
                    border: true,
                    boxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        colors: [Colors.lightBlue, Colors.blue],
                        tileMode: TileMode.repeated,
                      )
                    ),
                    selectedDayTextColor: Colors.black,
                    unSelectedDayTextColor: Colors.white,
                    onSelect: (values){
                      // returns as a list
                      print(values);
                    },
                  ),
                ),


              )
            ],
          ),
        )
      )
    );
  }
}

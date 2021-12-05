// @dart=2.10
import 'package:flutter/material.dart';
import 'package:day_picker/day_picker.dart';
import '../../../constants.dart';
import '../../../widgets/custom_AlertBox.dart';

class HabitDescription extends StatefulWidget {
  final String Hname;
  final String Hdescription;
  final bool Hactivation;
  final List Hdays;
  final String Hcat;
  HabitDescription({  this.Hname,  this.Hdescription,  this.Hactivation,  this.Hdays, this.Hcat});

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
              print(widget.Hcat);
              print(widget.Hname);
              CustomAlertBox.deleteJournalCategorHabit(context, "Delete habit?", Constants.myUID, widget.Hcat, widget.Hname);
              Navigator.pop(context);
              //CustomAlertBox.deleteDiaryEntryConfirmation(context, "Delete diary Entry?", Constants.myUID, widget.diaryName);
            }, icon: Icon(Icons.delete, color: Colors.white ))],

        ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Habit Name:", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontSize: 25, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                SizedBox(height: 5),
                Text(widget.Hname, style: TextStyle(fontFamily: systemHeaderFontFamiy, fontSize: 20)),
                SizedBox(height: 25),
                Text("Habit Description:", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontSize: 25, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                SizedBox(height: 5),
                Text(widget.Hdescription, style: TextStyle(fontFamily: systemHeaderFontFamiy, fontSize: 20)),
                SizedBox(height: 25),
                Text("Days Activated:", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontSize: 25, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                SizedBox(height: 5),
                Text(daysActivated, style: TextStyle(fontFamily: systemHeaderFontFamiy, fontSize: 20)),
                SizedBox(height: 25),
                Text("Activated:", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontSize: 25, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                SizedBox(height: 5),
                Text((widget.Hactivation) ? "Yes" : "No", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontSize: 20)),
                SizedBox(height: 25),


              ],
            ),
          ),
        )
      )
    );
  }
}

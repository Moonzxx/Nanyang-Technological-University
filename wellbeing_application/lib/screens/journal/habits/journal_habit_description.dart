import 'package:flutter/material.dart';
import 'package:day_picker/day_picker.dart';


class HabitDescription extends StatefulWidget {
  final String Hname;
  final String Hdescription;
  final bool Hactivation;
  final List Hdays;
  HabitDescription({ required this.Hname, required this.Hdescription, required this.Hactivation, required this.Hdays});

  @override
  _HabitDescriptionState createState() => _HabitDescriptionState();
}

class _HabitDescriptionState extends State<HabitDescription> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descController = new TextEditingController();

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
        title: Text(widget.Hname),
        actions: [
          // to edit or delete
        ],

      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(labelText: "Testing"),
                controller: nameController,
              ),
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

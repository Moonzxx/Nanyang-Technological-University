// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/constants.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:day_picker/day_picker.dart';
import 'package:wellbeing_application/constants.dart';
import '../../../utils/firebase_api.dart';
import 'package:date_format/date_format.dart';

class EditHabit extends StatefulWidget {
  final String habitName;
  final String habitDesc;
  final bool habitActivation;
  final List habitActivatedDays;
  EditHabit({this.habitName, this.habitDesc, this.habitActivation, this.habitActivatedDays});

  @override
  _EditHabitState createState() => _EditHabitState();
}

class _EditHabitState extends State<EditHabit> {

  final _editHabitFormKey = GlobalKey<FormState>();
  FirebaseApi databaseMethods = new FirebaseApi();

  TextEditingController habitNameController = new TextEditingController();
  TextEditingController habitDescController = new TextEditingController();
  bool isSwitched = false;
  List<String> finalDays;

  String savedHabitName;
  String savedHabitDesc;

  String validateName(String value){

    RegExp habitName = new RegExp(r'^[a-zA-Z0-9 ]*$');
    if (!habitName.hasMatch(value)){
      return 'Name must contain only alphabets and/or numbers';
    }
    else{
      return null;
    }
  }

  String validateDesc(String value){

    RegExp nameDesc = new RegExp(r'^[a-zA-Z0-9 ]*$');
    if (!nameDesc.hasMatch(value)){
      return 'Name must contain only alphabets';
    }
    else{
      return null;
    }
  }

  // edit days and time

  @override
  void initState(){
    setState(() {
      habitNameController.text = widget.habitName;
      habitDescController.text = widget.habitDesc;
      isSwitched = widget.habitActivation;
      finalDays = widget.habitActivatedDays;
    });
    super.initState();
  }


  int hour;
  int minute;

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

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        hour = selectedTime.hour;
        minute = selectedTime.minute;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        print(selectedTime.hour);
      });}

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _hour, _minute, _time;
  String _setTime;
  TextEditingController _timeController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editing " + widget.habitName),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _editHabitFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: habitNameController,
                decoration: inputDecoration("Habit Name:"
                ),
                maxLength: 50,
                // accept alphabet, number and spaces
                validator: validateName,
                onSaved: (value){
                  setState(() {
                    savedHabitName = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: habitDescController,
                decoration: inputDecoration("Habit Description:"
                ),
                maxLength: 50,
                // accept alphabet, number and spaces
                validator: validateDesc,
                onSaved: (value){
                  setState(() {
                    savedHabitDesc = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Activated: "),
                  SizedBox(width: 30,),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ],
              ),
              Text("Day Selection"),
              Padding(
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
                    setState(() {
                      finalDays = values;
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: (){
                  _selectTime(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top:30),
                  //height: MediaQuery.of(context).size.height/11,
                  //width: MediaQuery.of(context).size.width/5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 40
                    ),
                    textAlign: TextAlign.center,
                    onSaved: (String val){
                      _setTime = val;
                    },
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _timeController,
                    decoration: InputDecoration(
                      disabledBorder:UnderlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.all(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
/*

*/
// @dart=2.10
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:day_picker/day_picker.dart';
import 'package:wellbeing_application/constants.dart';
import '../../../utils/firebase_api.dart';
import 'package:date_format/date_format.dart';


class AddNewHabit extends StatefulWidget {
  final String categoryName;
  AddNewHabit({this.categoryName});

  @override
  _AddNewHabitState createState() => _AddNewHabitState();
}

class _AddNewHabitState extends State<AddNewHabit> {

  FirebaseApi databaseMethods = new FirebaseApi();
  TextEditingController nameController = new TextEditingController();
  TextEditingController descController = new TextEditingController();

  bool btn1 = false;
  bool btn2 = false;
  final _habitFormKey = GlobalKey<FormState>();
  int hour;
  int minute;

  int selectedDropDownMenu = 1;
  List<int> frequency = [1,2,3,4,5,6,7,8,9];
  List<int> finalFreq;

  List<String> finalDays;

  String selectedRoutineDropDownMenu = "Morning";
  List<String> routine = ["Morning", "Afternoon", "Evening", "Night"];
  List<String> finalRoutine;

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
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _hour, _minute, _time;
  String _setTime;
  TextEditingController _timeController = new TextEditingController();

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

  String validateStrings(String value){

    RegExp nameregex = new RegExp(r'^[a-zA-Z]*$');
    if (!nameregex.hasMatch(value)){
      return 'Name must contain only alphabets';
    }
    else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new Habit")
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _habitFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: validateStrings,
                  decoration: inputDecoration("Name of Habit"),
                  controller: nameController,
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: validateStrings,
                  decoration: inputDecoration("Description"),
                  controller: descController
                ),
                /* Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Habit Frequency:'),
                    SizedBox(width: 15,),
                    DropdownButton(
                      value: selectedDropDownMenu,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 20,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                        color: Colors.black),
                        onChanged: (int newValue){
                        setState(() {
                          selectedDropDownMenu = newValue;
                        });
                        },
                        items:  frequency
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList()),
                  ],
                ), */
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
                SizedBox(height:10),
                /* Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Time of the day :'),
                    SizedBox(width: 15,),
                    DropdownButton(
                        value: selectedRoutineDropDownMenu,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 20,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                            height: 2,
                            color: Colors.black),
                        onChanged: (String newValue){
                          setState(() {
                            selectedRoutineDropDownMenu = newValue;
                          });
                        },
                        items:  routine
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()
                    ),
                  ],
                ),*/
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
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 50.0,
                      child: ElevatedButton(
                          onPressed: () {
                            String partOfDay = "";
                            if(hour < 12){
                              partOfDay = "Morning";
                            }
                            else if( 12 >= hour && hour < 17){
                              partOfDay = "Afternoon";
                            }
                            else if( hour < 20){
                              partOfDay = "Evening";
                            }
                            else{
                              partOfDay = "Night";
                            }

                            Map<String, dynamic> createHabitInfoMap = {
                              "name" : nameController.text,
                              "description": descController.text,
                              "days" : finalDays,
                              "partOfDay" : partOfDay,
                              "activated": true,
                              "time_hour" : hour,
                              "time_minute" : minute,
                              "categoryName" : widget.categoryName,
                              "completed": [""],
                              "notCompleted" : [""]
                            };
                            databaseMethods.setUsersHabitsfromCategory(Constants.myUID, widget.categoryName, nameController.text, createHabitInfoMap);
                            Navigator.pop(context);
                          },
                          child: const Text('Create')
                      ),
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}


InputDecoration inputDecoration(String labelText){
  return InputDecoration(
    focusColor: Colors.black,
    labelStyle: TextStyle(color: Colors.black),
    labelText: labelText,
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.black),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
    ),
  );
}
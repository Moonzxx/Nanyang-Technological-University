import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constants.dart';


class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
        title: Text("Calendar", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
       body: TableCalendar(
        focusedDay: selectedDay,
        firstDay: DateTime(2010),
        lastDay: DateTime(2035),
        calendarFormat: format,
        onFormatChanged: (CalendarFormat _format){
          setState(() {
            format = _format;
          });
        },
        // can be changed
        startingDayOfWeek: StartingDayOfWeek.monday,
        daysOfWeekVisible: true,


        // Day Changed
        onDaySelected: (DateTime selectDay, DateTime focusDay){
          setState(() {
            selectedDay = selectDay;
            focusedDay = focusDay;
          });
          print(focusDay);
        },
        selectedDayPredicate:(DateTime date){
          return isSameDay(selectedDay, date);
        },

        // To style the calendar
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
         // selectedDecoration: BoxDecoration(
         //   color: Colors.blue,
         //   borderRadius: BorderRadius.circular(5.0)
        //  ),
          selectedTextStyle: TextStyle(color: Colors.white),
          //todayDecoration: BoxDecoration(
           // color: Colors.purpleAccent,
         //   borderRadius: BorderRadius.circular(5.0)
         // ),
        ),
        // Will show format title as current display
        headerStyle: HeaderStyle(
            formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration:  BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5.0),
          ),
          formatButtonTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ), 
    );
  }
}

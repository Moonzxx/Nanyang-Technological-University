// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../constants.dart';
import 'settings_updateUserInfo.dart';
import '../../widgets/custom_snackbar.dart';
import '../profile/profile.dart';

class SettingsPage extends StatefulWidget {
  int themeColour;
  SettingsPage({ this.themeColour});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  FirebaseApi databaseMethods = new FirebaseApi();
  DocumentSnapshot UserAppColour;
  Color color;
  bool isSwitched = true;



  @override
  void initState(){
    setState(() {
      color = Color(widget.themeColour).withOpacity(1);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Settings"),
          backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
        ),
         body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10.0)),
                Text("User Information", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                settingsButton(btnName: "Update Details", action: "UpdateUser"),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Theme"),
                    SizedBox(width: 30,),
                    GestureDetector(
                      onTap: (){
                        pickColor(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: this.color,
                        ),
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Random Notification: "),
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
                SizedBox(height: 30),
                Text("About the App", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                settingsButton(btnName: "Random Notifications", action: "",),
                // can add in for random notification pushes
                settingsButton(btnName: "Feedback", action: "",),
                settingsButton(btnName: "Help", action: "",),
                settingsButton(btnName: "About uJournal", action: "",)
              ],
            ),
          ),
        )


    );
  }

  Widget buildColorPicker() => BlockPicker(
    pickerColor: color,
     availableColors: [
       Colors.blue,
       Colors.green,
       Colors.cyan,
       Colors.deepPurple,
       Colors.teal,
       Colors.amber,
       Colors.blueGrey,
       Colors.pinkAccent,
       Colors.pink,
       Colors.red,
       Colors.indigo
     ],
    onColorChanged: (color) => setState(() =>  this.color = color),
  );

  void pickColor(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.all(10),
      title: Text('Pick your colour'),
      content: Column(
        children: <Widget>[
          buildColorPicker(),
          TextButton(
            child: Text(
              "SELECT",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: (){
              databaseMethods.setAppThemeColour(Constants.myUID, this.color.value).then((val){
                setState(() {
                  Constants.myThemeColour = this.color.value;
                });
              });
              Navigator.of(context).pop();
              CustomSnackBar.buildPositiveSnackbar(context, "New Colour Theme Updated!");
            }
          ),
        ],
      ),
    ),
  );
}



// Help to create multiple buttons

class settingsButton extends StatefulWidget {
  final String btnName;
  final String action;
  settingsButton({ this.btnName, this.action}); //this.action

  @override
  _settingsButtonState createState() => _settingsButtonState();
}

class _settingsButtonState extends State<settingsButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: ElevatedButton(onPressed: (){
       if(widget.action == "UpdateUser"){
         Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateUserDetails()));
       }
      },
          child: Text(widget.btnName),
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width/1.5, MediaQuery.of(context).size.width/9),
          primary: Color(Constants.myThemeColour).withOpacity(1)
        )
      ),
    );
  }
}



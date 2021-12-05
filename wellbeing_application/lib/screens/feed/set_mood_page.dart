// @dart=2.10

/*

Set Mood Page
- User can choose colour to display their mood
- Colour display around user's DP

*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../constants.dart';
import '../../widgets/custom_snackbar.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({Key key}) : super(key: key);

  @override
  _MoodPageState createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  FirebaseApi databaseMethods = new FirebaseApi();
  Color color;

  @override
  void initState(){
    setState(() {
      color = Color(Constants.myMoodColour).withOpacity(1);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(Constants.myThemeColour + 25).withOpacity(1),
        title: Text("Select Mood", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                width: 150,
                  height: 150,
              ),
              SizedBox(height:15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24,)
                ),
                child: Text(
                  "Pick Color",
                  style: TextStyle(fontSize:24)
                ),
                onPressed: () => pickColor(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Can be changed into a block picker as well
  // Function to choose a colour
  Widget buildColorPicker() => ColorPicker(
    pickerColor: color,
    enableAlpha: false, // Hides the advance option to not change the colour's opacity
    showLabel: false, // Hiding the Hex value
    onColorChanged: (color) => setState(() => this.color = color),
  );

  void pickColor(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.all(10),
      title: Text('Pick your Mood Colour'),
      content: Column(
        children: <Widget>[
          buildColorPicker(),
          TextButton(
            child: Text(
              "SELECT",
              style: TextStyle(fontSize: 20),
            ),
              onPressed: (){
                databaseMethods.setUserMoodColour(Constants.myUID, this.color.value).then((val){
                  setState(() {
                    Constants.myMoodColour = this.color.value;
                  });
                });
                Navigator.of(context).pop();
                CustomSnackBar.buildPositiveSnackbar(context, "Mood Colour Updated!");
              }
          ),
        ],
      ),
    ),
  );



}

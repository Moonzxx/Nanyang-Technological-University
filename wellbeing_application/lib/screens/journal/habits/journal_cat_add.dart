// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'journal_habits_add.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../constants.dart';
import '../../../widgets/custom_snackbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';

class JournalCatAdd extends StatefulWidget {
  const JournalCatAdd({Key key}) : super(key: key);

  @override
  _JournalCatAddState createState() => _JournalCatAddState();
}

class _JournalCatAddState extends State<JournalCatAdd> {

  TextEditingController catController = new TextEditingController();
  TextEditingController catDescController = new TextEditingController();
  TextEditingController aboutCatController = new TextEditingController();
  FirebaseApi databaseMethods = new FirebaseApi();
  final _catFormKey = GlobalKey<FormState>();
  Color color = Colors.blue;
  int savedColour;
  List<String> existingCategories = [];

  getAllExistingCategories() async{
    QuerySnapshot coll = await FirebaseFirestore.instance.collection("habits").doc(Constants.myUID).collection("categories").get();
    List<DocumentSnapshot> collDocs = coll.docs;
    for(var i = 0; i < collDocs.length; i++){
      setState(() {
        existingCategories.add(collDocs[i]["name"]);
      });
    }
  }

  @override
  void initState(){
    getAllExistingCategories();
    super.initState();
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
                savedColour = this.color.value;
                Navigator.pop(context);
              }
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Add a new Category")
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _catFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: inputDecoration("Name of Category"),
                  controller: catController,
                ),
                SizedBox(height: 30),
                TextFormField(
                  decoration: inputDecoration("Category Short Description"),
                  controller: catDescController,
                ),
                SizedBox(height: 30),
                TextFormField(
                  decoration: inputDecoration("About Category"),
                  controller: aboutCatController,
                ),
                SizedBox(height: 20),
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

                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 50.0,
                      child: ElevatedButton(
                          onPressed: () {

                            Map<String, dynamic> catInfo = {
                              "name": catController.text,
                              "short_desc" : catDescController.text,
                              "about": aboutCatController.text,
                              "colour": savedColour
                            };


                            databaseMethods.setUserNewCat(Constants.myUID, catController.text, catInfo);
                            Navigator.pop(context);
                            CustomSnackBar.buildPositiveSnackbar(context, "Category " + catController.text +  " created");
                           // Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewHabit(categoryName: catController.text, catColor: this.color,)
                            //));
                          },
                          child: const Text('Create Category')
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

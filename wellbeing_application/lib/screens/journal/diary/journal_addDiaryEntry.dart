// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';
import '../../../widgets/custom_snackbar.dart';

class AddDiaryEntry extends StatefulWidget {
  const AddDiaryEntry({Key key}) : super(key: key);

  @override
  _AddDiaryEntryState createState() => _AddDiaryEntryState();
}



class _AddDiaryEntryState extends State<AddDiaryEntry> {

  final _addDiaryFormKey = GlobalKey<FormState>();
  FirebaseApi databaseMethods = new FirebaseApi();
  TextEditingController thoughtsController = new TextEditingController();
  String diaryContent;
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());


  String selectedMoodDropDownMenu = "Happy";
  List<String> mood = ["Happy", "Sad", "Disgusted", "Night"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adding new Diary Entry"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _addDiaryFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add mood here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Mood:'),
                    SizedBox(width: 15,),
                    DropdownButton(
                        value: selectedMoodDropDownMenu,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 20,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                            height: 2,
                            color: Colors.black),
                        onChanged: (String newValue){
                          setState(() {
                            selectedMoodDropDownMenu = newValue;
                          });
                        },
                        items:  mood
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList()),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: inputDecoration("Thoughts"),
                    controller: thoughtsController,
                    onSaved: (String val){
                      diaryContent = val;
                    },
                  ),
                ),




                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 50.0,
                      child: ElevatedButton(
                          onPressed: () {

                            // Check if form is valid first
                            final isValid = _addDiaryFormKey.currentState.validate();
                            if(isValid){
                              _addDiaryFormKey.currentState.save();

                              Map<String, dynamic> diaryEntryInfo = {
                                "name" : currentDate,
                                "content": diaryContent,
                                "mood": selectedMoodDropDownMenu
                              };

                              databaseMethods.createUserDiaryEntry(Constants.myUID, currentDate, diaryEntryInfo);
                              Navigator.pop(context);
                              CustomSnackBar.buildPositiveSnackbar(context, "Entry Successfully Created");

                              // Once button is pressed, Diary entry will be created
                              // Diary Entry -> Mood, name(date String), content
                              // Name of document will be string date


                            }




                          },
                          child: const Text('Next Step')
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



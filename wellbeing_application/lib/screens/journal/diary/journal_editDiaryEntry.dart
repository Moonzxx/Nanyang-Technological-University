// @dart=2.10
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';
import '../../../widgets/custom_snackbar.dart';
import 'journal_viewDiaryEntry.dart';

class EditDiaryEntry extends StatefulWidget {
  final String diaryEntryName;
  final String editDiaryMood;
  final String editDiaryContent;
  EditDiaryEntry({ this.diaryEntryName,this.editDiaryMood, this.editDiaryContent});

  @override
  _EditDiaryEntryState createState() => _EditDiaryEntryState();
}

class _EditDiaryEntryState extends State<EditDiaryEntry> {

  FirebaseApi databaseMethods = new FirebaseApi();
  final _editDiaryFormKey = GlobalKey<FormState>();
  String editSelectedDiaryMood;
  String editDiaryContent;
  TextEditingController editDiaryContentController = new TextEditingController();

  List<String> mood = ["Happy", "Sad", "Disgusted", "Night"];


  @override
  void initState(){
    setState(() {
      editSelectedDiaryMood = widget.editDiaryMood;
      editDiaryContentController.text = widget.editDiaryContent;
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit " + widget.diaryEntryName),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _editDiaryFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Mood:'),
                    SizedBox(width: 15,),
                    DropdownButton(
                        value: editSelectedDiaryMood,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 20,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                            height: 2,
                            color: Colors.black),
                        onChanged: (String newValue){
                          setState(() {
                            editSelectedDiaryMood = newValue;
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
                    controller: editDiaryContentController,
                    onSaved: (String val){
                      editDiaryContent = val;
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
                            final isValid = _editDiaryFormKey.currentState.validate();
                            if(isValid){
                              _editDiaryFormKey.currentState.save();
                              databaseMethods.updateUserDiaryEntry(Constants.myUID, widget.diaryEntryName, editSelectedDiaryMood, editDiaryContent);
                              //databaseMethods.createUserDiaryEntry(Constants.myUID, currentDate, diaryEntryInfo);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  ViewDiaryEntry(diaryName: widget.diaryEntryName,
                                    diaryContent: editDiaryContent ,
                                    diaryMood: editSelectedDiaryMood)));
                              CustomSnackBar.buildPositiveSnackbar(context, "Entry Successfully Edited");

                              // Once button is pressed, Diary entry will be created
                              // Diary Entry -> Mood, name(date String), content
                              // Name of document will be string date


                            }
                          },
                          child: const Text('Save Changes')
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

// @dart=2.10
import 'package:flutter/material.dart';
import '../../../widgets/custom_snackbar.dart';

class AddDiaryEntry extends StatefulWidget {
  const AddDiaryEntry({Key key}) : super(key: key);

  @override
  _AddDiaryEntryState createState() => _AddDiaryEntryState();
}



class _AddDiaryEntryState extends State<AddDiaryEntry> {

  final _addDiaryFormKey = GlobalKey<FormState>();
  TextEditingController moodController = new TextEditingController();
  TextEditingController thoughtsController = new TextEditingController();

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
                SizedBox(
                  height: 200,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: inputDecoration("Thoughts"),
                    controller: thoughtsController,
                  ),
                ),


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

                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 50.0,
                      child: ElevatedButton(
                          onPressed: () {
                           // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                           // ));

                            // Once button is pressed, Diary entry will be created

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

import 'package:flutter/material.dart';
import 'journal_habits_add.dart';

class JournalCatAdd extends StatefulWidget {
  const JournalCatAdd({Key? key}) : super(key: key);

  @override
  _JournalCatAddState createState() => _JournalCatAddState();
}

class _JournalCatAddState extends State<JournalCatAdd> {

  TextEditingController catController = new TextEditingController();
  final _catFormKey = GlobalKey<FormState>();

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
                SizedBox(height: 70),

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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewHabit(categoryName: catController.text,)
                            ));
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

// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';
import '../../../widgets/custom_AlertBox.dart';

class CreateTips extends StatefulWidget {
  const CreateTips({Key key}) : super(key: key);

  @override
  _CreateTipsState createState() => _CreateTipsState();
}

class _CreateTipsState extends State<CreateTips> {
  final _createTipsFormKey = GlobalKey<FormState>();
  FirebaseApi databaseMethods = new FirebaseApi();
  TextEditingController tipSources = new TextEditingController(); //Maybe split string using commas?
  TextEditingController tipMainTitle = new TextEditingController();
  TextEditingController tipDescription = new TextEditingController();
  QuerySnapshot categoriesSnapshot = null;
  // Add dropdown category

  String postName = "";
  String postDescription = "";
  List<String> postSources = [];
  String postCategory = "";
  String selectedPostCategory = "Finance";
  List<String> tipsPostCategory = [];


  getTipsCategories() async{
    QuerySnapshot coll = await FirebaseFirestore.instance.collection("tips").doc("Tips").collection("categories").get();
    List<DocumentSnapshot> collDocs = coll.docs;
    print(collDocs.length); // returns 3
    for(var i = 0; i < collDocs.length; i++) {
      setState(() {
        tipsPostCategory.add(collDocs[i]['name']);
      });

    }

  }

  // Description to accept alphabets, numbers,
  // spaces and symbols
  // Need to rectify regular expression
  String validateDesc(String value){

    RegExp nameDesc = new RegExp(r'^[a-zA-Z0-9 ]*$');
    if (!nameDesc.hasMatch(value)){
      return 'Name must contain only alphabets';
    }
    else{
      return null;
    }
  }

  // Postname only accept alphabets, numbers and spaces
  String validateTitle(String value){

    RegExp nameTitle = new RegExp(r'^[a-zA-Z0-9 ]*$');
    if (!nameTitle.hasMatch(value)){
      return 'Name must contain only alphabets';
    }
    else{
      return null;
    }
  }


  String validateSources(String value){
  ///[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)?/gi
    RegExp nameSources = new RegExp(r'[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)?');
    if (!nameSources.hasMatch(value)){
      return 'Name must contain only alphabets';
    }
    else{
      return null;
    }
  }


  @override
  void initState(){
    getTipsCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Tip"),
        backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _createTipsFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: tipMainTitle,
                decoration: inputDecoration("Post Title"
                ),
                maxLength: 20,
                validator: validateTitle,
                onSaved: (value){
                  setState(() {
                    postName = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: tipDescription,
                decoration: inputDecoration("Post Description"
                ),
                maxLength: null,
                validator: validateDesc,
                onSaved: (value){
                  setState(() {
                    postDescription = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: tipSources,
                decoration: inputDecoration("Post Sources: (separate sources using commas)"
                ),
                maxLength: null,
                validator: validateSources,
                onSaved: (value){
                  setState(() {
                    // Firstly, remove whitespaces
                    // Then, split into List using commas
                    // Post Sources contains a list of sources
                    value = value.replaceAll(' ', '');
                    postSources = value.split(',');
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Time of the day :'),
                  SizedBox(width: 15,),
                  DropdownButton(
                      value: selectedPostCategory,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 20,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                          height: 2,
                          color: Colors.black),
                      onChanged: (String newValue){
                        setState(() {
                          selectedPostCategory = newValue;
                        });
                      },
                      items:  tipsPostCategory
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()
                  ),
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
                        onPressed: (){

                          final valid = _createTipsFormKey.currentState.validate();
                          if(valid){
                            _createTipsFormKey.currentState.save();
                            // information is a map of items
                            Map<String, dynamic> postInformation = {
                              "bookmarkedBy" : [""],
                              "content" : postDescription,
                              "name" : postName,
                              "sourcesFrom": postSources
                            };
                            CustomAlertBox.createTipPostAlert(context, "Confirm Post Information?", selectedPostCategory, postName, postInformation);
                          }

                        } ,
                        style: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20), primary: Colors.green , elevation: 5, ),
                        child: Text('Create'))
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

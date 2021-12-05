// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';
import '../../../widgets/custom_AlertBox.dart';

class CreateTools extends StatefulWidget {
  const CreateTools({Key key}) : super(key: key);

  @override
  _CreateToolsState createState() => _CreateToolsState();
}

class _CreateToolsState extends State<CreateTools> {

  final _createToolsFormKey = GlobalKey<FormState>();
  FirebaseApi databaseMethods = new FirebaseApi();
  TextEditingController andriodSourceController = new TextEditingController();
  TextEditingController iosSourceController = new TextEditingController();
  TextEditingController toolsMainTitleController = new TextEditingController();
  TextEditingController toolsDescriptionController = new TextEditingController();
  QuerySnapshot categoriesSnapshot = null;

  String postName = "";
  String postDescription = "";
  String postIosSource = "";
  String postAndroidSource = "";
  String postCategory = "";
  String selectedPostCategory;
  List<String> toolsPostCategory = [];


  getToolsCategories() async{
    QuerySnapshot coll = await FirebaseFirestore.instance.collection("tips").doc("Tools").collection("categories").get();
    List<DocumentSnapshot> collDocs = coll.docs;

    for(var i = 0; i < collDocs.length; i++){
      setState(() {
        toolsPostCategory.add(collDocs[i]['name']);
      });
    }

    selectedPostCategory = toolsPostCategory[0];
  }

  @override
  void initState(){
    getToolsCategories();
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Tool Post"),
        backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _createToolsFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 15),
              TextFormField(
                controller: toolsMainTitleController,
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
                controller: toolsDescriptionController,
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
                controller: iosSourceController,
                decoration: inputDecoration("IOS Source: "
                ),
                maxLength: null,
                validator: validateSources,
                onSaved: (value){
                  setState(() {
                    // Firstly, remove whitespaces
                    // Then, split into List using commas
                    // Post Sources contains a list of sources

                    postIosSource = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: andriodSourceController,
                decoration: inputDecoration("Android Source: "
                ),
                maxLength: null,
                validator: validateSources,
                onSaved: (value){
                  setState(() {
                    // Firstly, remove whitespaces
                    // Then, split into List using commas
                    // Post Sources contains a list of sources

                    postAndroidSource = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Category :'),
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
                      items:  toolsPostCategory
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

                            final valid = _createToolsFormKey.currentState.validate();
                            if(valid){
                              _createToolsFormKey.currentState.save();
                              // information is a map of items

                              Map<String, String> appLinks = new Map();
                              appLinks["android"] = postAndroidSource;
                              appLinks["ios"] = postIosSource;

                              Map<String, dynamic> postInformation = {
                                "appLinks" : appLinks,
                                "bookmarkedBy" : {},
                                "content" : postDescription,
                                "name" : postName,
                              };

                              CustomAlertBox.createToolPostAlert(context, "Confirm Post Information?", selectedPostCategory, postName, postInformation);
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

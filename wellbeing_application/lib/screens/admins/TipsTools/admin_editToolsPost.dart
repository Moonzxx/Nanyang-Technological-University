// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/screens/loginpage.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';
import '../../../widgets/custom_AlertBox.dart';
import '../../../widgets/custom_snackbar.dart';

class EditToolsPosts extends StatefulWidget {
  final String mainCat;
  final String subCat;
  final String postName;
  final String postContent;
  final String postIosSource;
  final String postAndoridSource;
  EditToolsPosts({this.mainCat, this.subCat, this.postName, this.postContent, this.postIosSource, this.postAndoridSource});

  @override
  _EditToolsPostsState createState() => _EditToolsPostsState();
}


class _EditToolsPostsState extends State<EditToolsPosts> {

  final _editToolsFormKey = GlobalKey<FormState>();
  FirebaseApi databaseMethods = new FirebaseApi();
  TextEditingController EditpostNameController = new TextEditingController();
  TextEditingController EditpostContentController = new TextEditingController();
  // for tips. Need to concat the words
  TextEditingController EditIosSourceController = new TextEditingController();
  TextEditingController EditAndroidSourceController = new TextEditingController();

  String savedPostName;
  String savedPostContent;
  String savedPostIosSource;
  String savedPostAndroidSource;


  @override
  void initState(){
    setState(() {
      EditpostNameController.text = widget.postName;
      EditpostContentController.text = widget.postContent;
      EditIosSourceController.text = widget.postIosSource;
      EditAndroidSourceController.text = widget.postAndoridSource;

    });
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editing " + widget.postName),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _editToolsFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: EditpostNameController,
                decoration: inputDecoration("Post Name:"
                ),
                maxLength: null,
                // accept alphabet, number and spaces
                validator: validateName,
                onSaved: (value){
                  setState(() {
                    savedPostName = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: EditpostContentController,
                decoration: inputDecoration("Post Content:"
                ),
                maxLength: null,
                // accept alphabet, number and spaces
                validator: validateDesc,
                onSaved: (value){
                  setState(() {
                    savedPostContent = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: EditIosSourceController,
                decoration: inputDecoration("Ios Source:"
                ),
                maxLength: null,
                // accept alphabet, number and spaces
                validator: validateSources,
                onSaved: (value){
                  setState(() {
                    savedPostIosSource = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: EditAndroidSourceController,
                decoration: inputDecoration("Android Source:"
                ),
                maxLength: null,
                // accept alphabet, number and spaces
                validator: validateSources,
                onSaved: (value){
                  setState(() {
                    savedPostAndroidSource = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: EdgeInsets.all(10),
                      height: 50.0,
                      child: ElevatedButton(
                          onPressed: (){

                            final valid = _editToolsFormKey.currentState.validate();
                            if(valid){
                              _editToolsFormKey.currentState.save();
                              Map<String, String> appLinks = new Map();
                              appLinks["android"] = savedPostAndroidSource;
                              appLinks["ios"] = savedPostIosSource;
                              // information is a map of items
                              Map<String, dynamic> updatedToolsPostInformation = {

                                "content" : savedPostContent,
                                "name" : savedPostName,
                                "appLinks": appLinks

                              };
                              databaseMethods.updateToolsPostInfo(widget.subCat, widget.postName, updatedToolsPostInformation);
                              //databaseMethods.updateTipsPostInfo(widget.subCat, widget.postName, updatedTipsPostInformation);
                              //databaseMethods.updateSGClinicInfo(widget.sgSelectedRegion, widget.sgClinicName, updatedClinicInformation);
                              Navigator.pop(context);
                              // cusotm or alert
                              CustomSnackBar.buildPositiveSnackbar(context, "Tools Post Editted");


                            }


                          } ,
                          style: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20), primary: Colors.green , elevation: 5, ),
                          child: Text('Update'))
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

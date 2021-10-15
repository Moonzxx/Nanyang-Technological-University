// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../constants.dart';


class CreateForumPost extends StatefulWidget {
  final List<dynamic> forumCategories;
  CreateForumPost({ this.forumCategories});

  @override
  _CreateForumPostState createState() => _CreateForumPostState();
}

class _CreateForumPostState extends State<CreateForumPost> {

  FirebaseApi databaseMethods = new FirebaseApi();
  TextEditingController fTitleController = new TextEditingController();
  TextEditingController fContentController = new TextEditingController();
  String category= "";
  final _forumFormKey = GlobalKey<FormState>();
  List forumPostCategories =[];
  String selectedDropDownMenu = "Finance";
  bool anonymous = false;


  initialiseForumCategories(){
    // assuming there is always more than one category
    forumPostCategories = widget.forumCategories;
    selectedDropDownMenu = forumPostCategories[0];
  }

  @override
  void initState(){
    initialiseForumCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Create new post")
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _forumFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: inputDecoration("Post Title"),
                  controller: fTitleController
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: inputDecoration("Content"),
                  controller: fContentController
                ),
                SizedBox(height: 10),
                Row(
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
                        onChanged: (dynamic newValue){
                          setState(() {
                            selectedDropDownMenu = newValue;
                          });
                        },
                        items:  forumPostCategories
                            .map<DropdownMenuItem<dynamic>>((dynamic value) {
                          return DropdownMenuItem<dynamic>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList()),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Post Anonymously? "),
                    SizedBox(width: 10),
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all(Colors.blue),
                      value: anonymous,
                      onChanged: (bool newValue){
                        setState(() {
                          anonymous = newValue;
                        });
                      },
                    )
                  ],
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

                          // Allowing to set as anonymous
                          String username = "";
                          if(anonymous == false)
                            {
                              username = Constants.myName;
                            }
                          else{
                            username = "Anonymous";
                          }


                          Map<String, dynamic> CreateForumPostInfoMap ={
                            "name" : fTitleController.text,
                            "content" : fContentController.text,
                            "userID": Constants.myUID,
                            "username": username
                          };

                          databaseMethods.setNewForumPost(selectedDropDownMenu, fTitleController.text, CreateForumPostInfoMap);
                          Navigator.pop(context);
                        },
                        child: Text('Create Post'),
                      ),
                    ),
                  ),
                ),
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
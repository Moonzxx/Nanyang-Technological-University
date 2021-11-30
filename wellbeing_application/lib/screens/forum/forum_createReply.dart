// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../constants.dart';
import '../../widgets/custom_snackbar.dart';

class createForumReply extends StatefulWidget {
  final String replyCat;
  final String replyForumTitle;
  createForumReply({this.replyCat, this.replyForumTitle});

  @override
  _createForumReplyState createState() => _createForumReplyState();
}

class _createForumReplyState extends State<createForumReply> {

  FirebaseApi databaseMethods = new FirebaseApi();
  final _createReplyFormKey = GlobalKey<FormState>();
  TextEditingController replyController = new TextEditingController();

  String savedUserReply;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reply Post"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _createReplyFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: replyController,
                decoration: inputDecoration("My Reply"
                ),
                maxLength: 140, // Like twitter
                validator: validateDesc,
                onSaved: (value){
                  setState(() {
                    savedUserReply = value;
                  });
                },
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

                            final valid = _createReplyFormKey.currentState.validate();
                            if(valid){
                              _createReplyFormKey.currentState.save();
                              // information is a map of items
                              Map<String, dynamic> forumReplyInformation = {
                                "username" : Constants.myName,
                                "userID" : Constants.myUID,
                                "content": savedUserReply,
                                "likes": 0
                              };
                              //put to database,pop and snacknar
                              databaseMethods.uploadUserReply(widget.replyCat, widget.replyForumTitle, forumReplyInformation).then((val){
                                Navigator.pop(context);
                                CustomSnackBar.buildPositiveSnackbar(context, "Reply Uploaded");
                              });
                              //CustomAlertBox.createTipPostAlert(context, "Confirm Post Information?", selectedPostCategory, postName, postInformation);
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

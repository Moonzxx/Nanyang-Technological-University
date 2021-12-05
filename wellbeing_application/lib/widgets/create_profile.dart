// @dart=2.10
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wellbeing_application/screens/homepage.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../constants.dart';
import 'package:path/path.dart' as path;
import '../widgets/custom_snackbar.dart';
import '../utils/firebase_api.dart';
import '../utils/helperfunctions.dart';
import '../widgets/navigation_drawer_zoom/navigation_start.dart';


// Creation of user profile with basic user information

class CreateProfile extends StatefulWidget {
  final Uint8List chosenProfilePic;
  final String accountUID;
  final String userEmail;
  //CreateProfile({ this.chosenProfilePic});
  CreateProfile({Key key, this.chosenProfilePic, this.accountUID, this.userEmail}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  FirebaseApi databaseMethods = new FirebaseApi();
  final _formKey2 = GlobalKey<FormState>();
  String id;
  UploadTask _task;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController  = TextEditingController();
  String _firstName = "";
  String _lastName = "";
  String _username = "";

  // Default information to ne initiliased in the databsed once the user is successfully created
  Future<void> initiliaseDefaultDatabase(String id) async{

    Map<String, dynamic> beAwareCatInfo = {
      "name" : "Be Aware",
      "short_desc": "Practice mindfulness",
      "about" : "Finding time in your day, to notice how you are and what is right with yourself and your life, boosts your sense of wellbeing!",
      "colour": 4283215696
    };

    Map<String, dynamic> beActiveCatInfo = {
      "name" : "Be Active",
      "short_desc": "Healthy Lifestyle",
      "about" : "Find an activity you enjoy and make it a part of your life.",
      "colour" : 4280391411
    };

    Map<String, dynamic> connectCatInfo = {
      "name" : "Connect",
      "short_desc": "Develop relationships with those around you.",
      "about" : "desc connect",
      "colour" : 4294918273
    };

    Map<String, dynamic> helpOthersCatInfo = {
      "name" : "Help Others",
      "short_desc": "Be Kind",
      "about" : "Even the smallest act of kindness helps!",
      "colour" : 4286336511
    };

    Map<String, dynamic> KeepLearningCatInfo = {
      "name" : "Keep Learning",
      "short_desc": "Try new things",
      "about" : "Trying new things will make you more confident and give you a snese of achievement!",
      "colour" : 4294961979
    };

    databaseMethods.createDefaultHabitCategories(id, "Be Aware", beAwareCatInfo);
    databaseMethods.createDefaultHabitCategories(id, "Be Active", beActiveCatInfo);
    databaseMethods.createDefaultHabitCategories(id, "Connect", connectCatInfo);
    databaseMethods.createDefaultHabitCategories(id, "Help Others", helpOthersCatInfo);
    databaseMethods.createDefaultHabitCategories(id, "Keep Learning", KeepLearningCatInfo);
  }

  // Updating user details into the database after user has confirmed their information
  Future<void> updateUserDetails() async{
    final uid = widget.accountUID;
    final destination = 'profilepics/userProfilePictures/$uid';

    _task = FirebaseApi.uploadBytes(destination, widget.chosenProfilePic);

    if(_task == null) return;

    final snapshot = await _task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    FirebaseFirestore _db = FirebaseFirestore.instance;
    final userRef = _db.collection("users").doc(uid);
    print("UID pt 4: $uid");
    userRef.get().then((value) async {
    //  Map<String, dynamic> userData = {
      //  "first_name": this._firstName,
     //   "last_name": this._lastName,
     //   "username" : this._username,
    //    "url-avatar": urlDownload
    //  };

      //await userRef.set(userData);
      await userRef.update({
      "first_name": this._firstName,
      "last_name": this._lastName,
      "username" : this._username,
      "url-avatar": urlDownload,
        "colour": 4282435440,
        "mood_colour": 4282435440,
        "profile_creation" :  true,
      });


      // Saving information into HelperFunction to keep tabs on user
      String email = widget.userEmail;
      HelperFunctions.saveUserLoggedInSharedPreference(true);
      HelperFunctions.saveUserUIDSharedPreference(uid);
      HelperFunctions.saveUserAvatarSharedPreference(urlDownload);
      HelperFunctions.saveUserNameSharedPreference(this._username);

      // Please check if this information is still needed!
      var clientinfo = new Map();
      clientinfo['UID'] = uid;
      clientinfo['email'] =  email;
      clientinfo['username']   = this._username;
      clientinfo['avatarURL'] = urlDownload;


      // Once account has been created, set up default stuff
      initiliaseDefaultDatabase(uid);

      CustomSnackBar.buildErrorSnackbar(context, "hi");
      final snackBar = SnackBar(
        content: Text('Profile Created'),
        action: SnackBarAction(
          label: "Cancel",
          textColor: Colors.white,
          onPressed: (){
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },// Try to make this into an Icon
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NavigationHomePage(userUID: widget.accountUID, userDetails: clientinfo)
        ),
      );
    } );
  }

  // Name Validation: Check if name only contains alphabets
  String validateName(String value){

    RegExp nameregex = new RegExp(r'^[a-zA-Z]*$');
    if (!nameregex.hasMatch(value)){
      return 'Name must contain only alphabets';
    }
    else{
      return null;
    }
  }

  // Username Validation: Check if username is only alphanumeric (without any special characters)
  String validateUsername(String value){
    RegExp nameregex = new RegExp(r'[a-zA-z0-9]');
    if (!nameregex.hasMatch(value)){
      return 'Username can only be alphanumeric';
    }
    else{
      return null;
    }
  }


  // TextFormField for First Name input
  Widget buildFirstName() => TextFormField(
    controller: firstNameController,
    decoration: inputDecoration("First Name"
    ),
    maxLength: 20,
    validator: validateName,
    onSaved: (value){
      setState(() {
        _firstName = value;
      });
    },
  );

  // TextFormField for Last Name input
  Widget buildLastName() => TextFormField(
    decoration: inputDecoration("Last Name"),
    /* InputDecoration(
      icon: Icon(Icons.person),
      hintText: 'Your Last Name',
      labelText: 'Last Name *',
      border: OutlineInputBorder(),
    ),*/
    maxLength: 20,
    validator: validateName,
    onSaved: (value ){
      setState(() {
        _lastName = value;
      });
    },
  );

  // TextFormField for Username Input
  Widget buildUserName() => TextFormField(
    decoration: inputDecoration("Usename"),/* nputDecoration(
      icon: Icon(Icons.person),
      hintText: 'It can be anything',
      labelText: 'Username *',
      border: OutlineInputBorder(),
    ), */
    maxLength: 30,
    validator: validateUsername,
    onSaved: (value) {
      setState(() {
        _username = value;
      });
    },
  );


  // Submit button to finalise profile creation
  Widget buildSubmitButton() => ElevatedButton(onPressed: (){
    final isValid = _formKey2.currentState.validate();

    if(isValid){
      _formKey2.currentState.save();
      updateUserDetails();
    }
  },
      style: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20), primary: Colors.green , elevation: 5, ),
      child: Text('Next Step'));


  // Profile Creation Main Page
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kCreateProfileTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(kCreateProfileTitle, style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, fontSize: 25),),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.memory(widget.chosenProfilePic,fit: BoxFit.fill)
                    ),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey2,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          buildFirstName(),
                          const SizedBox(height: 16),
                          buildLastName(),
                          const SizedBox(height: 16),
                          buildUserName(),
                          const SizedBox(height: 16),
                          buildSubmitButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}




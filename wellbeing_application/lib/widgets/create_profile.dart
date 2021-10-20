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

class CreateProfile extends StatefulWidget {
  final Uint8List chosenProfilePic;
  final String accountUID;
  //CreateProfile({ this.chosenProfilePic});
  CreateProfile({Key key, this.chosenProfilePic, this.accountUID}) : super(key: key);

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

  Future<void> initiliaseDefaultDatabase(String id) async{

    Map<String, String> beAwareCatInfo = {
      "name" : "Be Aware",
      "short_description": "short desc aware",
      "description" : "desc aware"
    };

    Map<String, String> beActiveCatInfo = {
      "name" : "Be Active",
      "short_description": "short desc active",
      "description" : "desc active"
    };

    Map<String, String> connectCatInfo = {
      "name" : "Connect",
      "short_description": "short desc connect",
      "description" : "desc connect"
    };

    Map<String, String> helpOthersCatInfo = {
      "name" : "Help Others",
      "short_description": "short desc help",
      "description" : "desc help"
    };

    Map<String, String> KeepLearningCatInfo = {
      "name" : "Keep Learning",
      "short_description": "short desc learning",
      "description" : "desc Learning"
    };

    databaseMethods.createDefaultHabitCategories(id, "Be Aware", beAwareCatInfo);
    databaseMethods.createDefaultHabitCategories(id, "Be Active", beActiveCatInfo);
    databaseMethods.createDefaultHabitCategories(id, "Connect", connectCatInfo);
    databaseMethods.createDefaultHabitCategories(id, "Help Others", helpOthersCatInfo);
    databaseMethods.createDefaultHabitCategories(id, "Keep Learning", KeepLearningCatInfo);

  }


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
      "url-avatar": urlDownload, "profile_creation" :  true
      });
      final email = await HelperFunctions.sharedPreferenceUserEmailKey;
      HelperFunctions.saveUserLoggedInSharedPreference(true);
      HelperFunctions.saveUserUIDSharedPreference(uid);
      HelperFunctions.saveUserAvatarSharedPreference(urlDownload);
      HelperFunctions.saveUserNameSharedPreference(this._username);

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

  String validateName(String value){

    RegExp nameregex = new RegExp(r'^[a-zA-Z]*$');
    if (!nameregex.hasMatch(value)){
      return 'Name must contain only alphabets';
    }
    else{
      return null;
    }
  }

  String validateUsername(String value){
    RegExp nameregex = new RegExp(r'[a-zA-z0-9]');
    if (!nameregex.hasMatch(value)){
      return 'Username can only be alphanumeric';
    }
    else{
      return null;
    }
  }


  Widget buildFirstName() => TextFormField(
    controller: firstNameController,
    decoration: InputDecoration(
      icon: Icon(Icons.person),
      hintText: 'Your First Name',
      labelText: 'First Name *',
      border: OutlineInputBorder(),
    ),
    maxLength: 30,
    validator: (value) {
      validateName(value);
    },
    onSaved: (value){
      setState(() {
        _firstName = value;
      });
    },
  );

  Widget buildLastName() => TextFormField(
    decoration: InputDecoration(
      icon: Icon(Icons.person),
      hintText: 'Your Last Name',
      labelText: 'Last Name *',
      border: OutlineInputBorder(),
    ),
    maxLength: 30,
    validator: (value) {
      validateName(value);
    },
    onSaved: (value ){
      setState(() {
        _lastName = value;
      });
    },
  );

  Widget buildUserName() => TextFormField(
    decoration: InputDecoration(
      icon: Icon(Icons.person),
      hintText: 'It can be anything',
      labelText: 'Username *',
      border: OutlineInputBorder(),
    ),
    maxLength: 30,
    validator: (value) {
      validateUsername(value);
    },
    onSaved: (value) {
      setState(() {
        _username = value;
      });
    },
  );

  Widget buildSubmitButton() => TextButton(
    style: flatButtonStyle,
    onPressed:() {
      final isValid = _formKey2.currentState.validate();

      if(isValid){
        _formKey2.currentState.save();

        updateUserDetails();
        //  Once information is saved, put the information into Users "Firstname", "lastname", "Username"
        // Find collection via UID?
      }
    },
    child: Text('Submit'),
  );

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.lightBlue,
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kCreateProfileTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(kCreateProfileTitle),
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

InputDecoration inputDecoration(String labelText){
  return InputDecoration(
    icon: Icon(Icons.person),
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

//Dont need any confirmation page??? Need to ask
// Reorganise code please
/*
class RegistrationForm extends StatefulWidget {
   String accountID;
  RegistrationForm(String accountUID, {this.accountID});


  @override
  _RegistrationFormState createState() => _RegistrationFormState(this.accountID);
}

class _RegistrationFormState extends State<RegistrationForm> {

  final _formKey = GlobalKey<FormState>();
  String id;
  String _firstName = "";
  String _lastName = "";
  String _username = "";

  _RegistrationFormState(String accountID){
    this.id = accountID;
  }

  Future<void> updateUserDetails() async{
    FirebaseFirestore _db = FirebaseFirestore.instance;
    final userRef = _db.collection("users").doc(this.id);
    userRef.get().then((value) async {
      Map<String, dynamic> userData = {
        "first_name": this._firstName,
        "last_name": this._lastName,
        "username" : this._username
      };



      await userRef.set(userData);
      await userRef.update({
        "profile_creation" :  true
      });
    } );
  }


  Widget buildFirstName() => TextFormField(
    decoration: InputDecoration(
      icon: Icon(Icons.person),
      hintText: 'Your First Name',
      labelText: 'First Name *',
      border: OutlineInputBorder(),
    ),
    maxLength: 30,
    validator: (value) {
      validateName(value);
    },
    onSaved: (value){
      setState(() {
        _firstName = value;
      });
    },
  );

  Widget buildLastName() => TextFormField(
    decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Your Last Name',
        labelText: 'Last Name *',
      border: OutlineInputBorder(),
    ),
    maxLength: 30,
    validator: (value) {
      validateName(value);
    },
    onSaved: (value ){
      setState(() {
        _lastName = value;
      });
    },
  );


  Widget buildUserName() => TextFormField(
    decoration: InputDecoration(
      icon: Icon(Icons.person),
      hintText: 'It can be anything',
      labelText: 'Username *',
      border: OutlineInputBorder(),
    ),
    maxLength: 30,
    validator: (value) {
        validateUsername(value);
    },
    onSaved: (value) {
      setState(() {
        _username = value;
      });
    },
  );

  Widget buildSubmitButton() => TextButton(
    style: flatButtonStyle,
    onPressed:() {
      final isValid = _formKey.currentState.validate();

      if(isValid){
        _formKey.currentState.save();
        updateUserDetails();
        //  Once information is saved, put the information into Users "Firstname", "lastname", "Username"
        // Find collection via UID?
      }
    },
    child: Text('Submit'),
  );

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.lightBlue,
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );



  // Creation
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: EdgeInsets.all(16),
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
    );
  }
}

*/


// Validation



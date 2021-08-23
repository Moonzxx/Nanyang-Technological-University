// @dart=2.10
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../constants.dart';

class CreateProfile extends StatefulWidget {
  final Uint8List chosenProfilePic;
  final String accountUID;
  //CreateProfile({ this.chosenProfilePic});
  CreateProfile({Key key, this.chosenProfilePic, this.accountUID}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kCreateProfileTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(kCreateProfileTitle),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.memory(widget.chosenProfilePic,fit: BoxFit.fill)
              )
            ),
            RegistrationForm(widget.accountUID),
          ],
        )
      ),
    );
  }
}

//Dont need any confirmation page??? Need to ask
// Reorganise code please

class RegistrationForm extends StatefulWidget {
   String accountID;
  RegistrationForm(String accountUID, {this.accountID});


  @override
  _RegistrationFormState createState() => _RegistrationFormState(this.accountID);
}

class _RegistrationFormState extends State<RegistrationForm> {

  final _formKey = GlobalKey<FormState>();
  //final TextEditingController _firstNameController = TextEditingController();
  //final TextEditingController _lastNameController = TextEditingController();
  //final TextEditingController _usernameController = TextEditingController();
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


String validateName(String value){
  RegExp nameregex = new RegExp(r'[a-zA-z]');
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

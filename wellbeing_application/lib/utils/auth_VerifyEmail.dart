// @dart=2.10
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/screens/loginpage.dart';
import '../widgets/choosing_avatar.dart';

// Verify the user to check their authenticity before allow the ser to create their user profile

class VerifyEmail extends StatefulWidget {
  final String uid;
  VerifyEmail({this.uid});

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final auth = FirebaseAuth.instance;
  User user;
  // Ensure email verification does not run forever
  Timer timer;

  @override
  void initState(){
    user = auth.currentUser;
    user.sendEmailVerification();

    // Continuously ping to check if they have verified their email
    Timer.periodic(Duration(seconds: 5), (timer) {
      // check and see if email has been verified
      checkEmailVerified();
    });

    super.initState();
  }

  // To dispose the timer once verification has been completed / timed out
  @override
  void dispose(){
    timer.cancel();
    super.dispose();
  }

  // Verify Email Main Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email Verification"),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30)
          )
        ),
      ),
      body:Center(
        child: Text("An email has been sent to ${user.email}. Please verify the email! After verification, please refresh the app!"),
      )


    );
  }


  // Checking if email has been verified
  Future<void> checkEmailVerified() async{
    user = auth.currentUser;

    await user.reload();
    if(user.emailVerified){
      //re load user from time to time to check
      // navigate to push avaatar


      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChooseAvatar(accountUID: widget.uid)));
      timer.cancel();
    }

  }

}

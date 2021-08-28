// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:wellbeing_application/screens/feed/homepagetester3.dart';
import 'screens/loginpage.dart';
import 'screens/homepage.dart';
import 'screens/homepagetester.dart';
import 'utils/auth_helper.dart';
import 'screens/admins/homepage.dart';
import 'widgets/choosing_avatar.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: "Nunito"
      ),
      // This wi;; apply to the whole application

      home: Scaffold(
        resizeToAvoidBottomInset: false,  // Wont resize the doc if keyboard visible, prevent shrinking
        body: Container(
          child: Center(
            child: LandingPage(),
          ),
        ),
      ),
    );
  }
}

class LandingPage extends StatelessWidget{
  String userUID;
  String UID;
  final Future<FirebaseApp> _initialisation = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // To initialise the application
    // Future is initialisation
    return FutureBuilder(
      future: _initialisation,
      builder: (context, snapshot) {
        //Checking if there is any kind of error
        if(snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        // Once complete, show application
        if(snapshot.connectionState == ConnectionState.done) {
          // Streambuilder can get live state of the user
          //Can check from Firebase if user has logged in or not using Streambuilder
          return StreamBuilder<User>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot)  {
              // Checking if connection state is active
              if( snapshot.connectionState == ConnectionState.active){
                // Get user from firebase package
                if(snapshot.hasData && snapshot.data != null){
                  // saving thr latest data of the user; If user found
                  final user = snapshot.data;
                  UserHelper.saveUser(user);     // This is the user
                  UID = snapshot.data.uid.toString();
                  // phone ifnormation saved, check profile creation, else homepage


                    return StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("users").doc(UID).snapshots() ,
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                        if(snapshot.hasData && snapshot.data != null) {

                          final user = snapshot.data;
                          if(user['profile_creation'] == false){
                            return ChooseAvatar(accountUID: UID);
                          }
                          else{
                            //porfile creation true
                            if(user['role'] == 'admin'){
                              return AdminHomePage();
                            }
                            else{
                              return HomePage();
                            }
                          }

                          return LoginPage();

                          // final user = userDoc.data();

                        }
                        else{
                          // just waiinting
                          return Material(child: Center(child: CircularProgressIndicator(),),);
                        }
                      },
                    );


                  // Now checking of uer status (Student or admin)
                }
                return LoginPage();

                //Checking if input isnull
                /*
                if(user == null) {
                  return LoginPage();
                } else {
                  return HomePage();
                } */
              }
              // If nothinghaoppend
              return Scaffold(
                body: Center(
                  child: Text("Checking Authentication ..."),
                ),
              );

            },
          );
        }

        // Otherwise, show something whilst waiting fo initialistion to compelte
        return Scaffold(
          body: Center(
            child: Text("Connecting to the app..."),
          ),
        );

      },
    );
  }

}





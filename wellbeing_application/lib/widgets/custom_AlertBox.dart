// @dart=2.10
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'custom_snackbar.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../screens/profile/profile.dart';
import '../constants.dart';


// Creating customised alert boxes for different situations

class CustomAlertBox{

  // Confirmation for updating user information without picture
  static updateProfileAlertBox1(BuildContext context, String message, String UID, String username, String userFN, String userLN){
    FirebaseApi databaseMethods = new FirebaseApi();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            child: Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: message
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))
                            ),
                            onPressed: (){
                              // Execution of pressing No
                              Navigator.pop(context);
                            },
                            child: Text("No",style: TextStyle(color: Colors.white),
                            ),

                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              //final urlDownload = await snapshot.ref.getDownloadURL();
                              databaseMethods.saveUserDetails(UID, username, userFN, userLN);
                              Navigator.pop(context);
                              CustomSnackBar.buildPositiveSnackbar(context, "User Profile Updated");
                              // Need to refresh settings page to see chagnes
                              //Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ProfilePage()));
                            },
                            child: Text("Yes",style: TextStyle(color: Colors.white),
                            ),

                          ),

                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        }

    );
  }


  // Confirmation for updating user information and picture
  static updateProfileAlertBox2(BuildContext context, String message, String UID, String username, String userFN, String userLN, Uint8List newDp){
    FirebaseApi databaseMethods = new FirebaseApi();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            child: Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: message
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all( Color(Constants.myThemeColour).withOpacity(1)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))
                            ),
                            onPressed: (){
                              // Execution of pressing No
                              Navigator.pop(context);
                            },
                            child: Text("No",style: TextStyle(color: Colors.white),
                            ),

                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all( Color(Constants.myThemeColour).withOpacity(1)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))
                            ),
                            onPressed: () async {
                              // Execution of pressing yes
                              final destination = 'profilepics/userProfilePictures/$UID';
                              final snapshot = await FirebaseApi.deleteDp(destination).whenComplete(() {});



                              final newSnapshot = await FirebaseApi.uploadBytes(destination, newDp).whenComplete(() {});
                              final urlDownload = await newSnapshot.ref.getDownloadURL();

                              //final urlDownload = await snapshot.ref.getDownloadURL();
                              databaseMethods.saveUserDetails2(UID, username, userFN, userLN, urlDownload);
                              Navigator.pop(context);
                              CustomSnackBar.buildPositiveSnackbar(context, "User Profile Updated");
                            },
                            child: Text("Yes",style: TextStyle(color: Colors.white),
                            ),

                          ),

                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        }



    );
  }


  static createTipPostAlert(BuildContext context, String message, String sub, String title, information){
    FirebaseApi databaseMethods = new FirebaseApi();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            child: Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: message
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))
                            ),
                            onPressed: (){
                              // Execution of pressing No
                              Navigator.pop(context);
                            },
                            child: Text("No",style: TextStyle(color: Colors.white),
                            ),

                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              //final urlDownload = await snapshot.ref.getDownloadURL();
                              databaseMethods.createTipPost( sub, title, information);
                              Navigator.pop(context);
                              CustomSnackBar.buildPositiveSnackbar(context, "Post Successfully Created");

                            },
                            child: Text("Yes",style: TextStyle(color: Colors.white),
                            ),

                          ),

                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        }

    );
  }

  static createToolPostAlert(BuildContext context, String message, String sub, String title, information){
    FirebaseApi databaseMethods = new FirebaseApi();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            child: Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: message
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))
                            ),
                            onPressed: (){
                              // Execution of pressing No
                              Navigator.pop(context);
                            },
                            child: Text("No",style: TextStyle(color: Colors.white),
                            ),

                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              //final urlDownload = await snapshot.ref.getDownloadURL();
                              databaseMethods.createTipPost( sub, title, information);
                              Navigator.pop(context);
                              CustomSnackBar.buildPositiveSnackbar(context, "Post Successfully Created");

                            },
                            child: Text("Yes",style: TextStyle(color: Colors.white),
                            ),

                          ),

                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        }

    );
  }

  static deleteTipsToolsPost(BuildContext context, String message, String mainCat, String subCat, String postTitle){
    FirebaseApi databaseMethods = new FirebaseApi();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            child: Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: message
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))
                            ),
                            onPressed: (){
                              // Execution of pressing No
                              Navigator.pop(context);
                            },
                            child: Text("No",style: TextStyle(color: Colors.white),
                            ),

                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              //final urlDownload = await snapshot.ref.getDownloadURL();
                             // databaseMethods.deleteSGClinicInfo(sgRegion, sgClinicName);
                              databaseMethods.deleteTipToolsPost(mainCat, subCat, postTitle);
                              Navigator.pop(context);
                              CustomSnackBar.buildPositiveSnackbar(context, "Post Successfully Deleted");

                            },
                            child: Text("Yes",style: TextStyle(color: Colors.white),
                            ),

                          ),

                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        }

    );
  }


  static deleteDiaryEntryConfirmation(BuildContext context, String message, String userID, String diaryEntry){
    FirebaseApi databaseMethods = new FirebaseApi();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            child: Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: message
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))
                            ),
                            onPressed: (){
                              // Execution of pressing No
                              Navigator.pop(context);
                            },
                            child: Text("No",style: TextStyle(color: Colors.white),
                            ),

                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              //final urlDownload = await snapshot.ref.getDownloadURL();
                              databaseMethods.deleteUserDiaryEntry(userID, diaryEntry);
                              //Navigator.pop(context); Why delete pop is not wokring?? Maybe try process this first
                              CustomSnackBar.buildPositiveSnackbar(context, "Entry Successfully Deleted");

                            },
                            child: Text("Yes",style: TextStyle(color: Colors.white),
                            ),

                          ),

                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        }

    );
  }

  static deleteSGClinicInfo(BuildContext context, String message, String sgRegion, String sgClinicName){
    FirebaseApi databaseMethods = new FirebaseApi();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            child: Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: message
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))
                            ),
                            onPressed: (){
                              // Execution of pressing No
                              Navigator.pop(context);
                            },
                            child: Text("No",style: TextStyle(color: Colors.white),
                            ),

                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              //final urlDownload = await snapshot.ref.getDownloadURL();
                              databaseMethods.deleteSGClinicInfo(sgRegion, sgClinicName);
                              Navigator.pop(context);
                              CustomSnackBar.buildPositiveSnackbar(context, "Clinic Successfully Deleted");

                            },
                            child: Text("Yes",style: TextStyle(color: Colors.white),
                            ),

                          ),

                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        }

    );
  }

  static addRemarkConfirmation(BuildContext context, String message, String region, String clinic, Map userRemarkInfo){
    FirebaseApi databaseMethods = new FirebaseApi();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            child: Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: message
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))
                            ),
                            onPressed: (){
                              // Execution of pressing No
                              Navigator.pop(context);
                            },
                            child: Text("No",style: TextStyle(color: Colors.white),
                            ),

                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              //final urlDownload = await snapshot.ref.getDownloadURL();
                              // databaseMethods.deleteSGClinicInfo(sgRegion, sgClinicName);
                              //databaseMethods.deleteTipToolsPost(mainCat, subCat, postTitle);
                              databaseMethods.setUserRemark(region, clinic, userRemarkInfo);
                              Navigator.pop(context);
                              CustomSnackBar.buildPositiveSnackbar(context, "Remark Successfully posted");

                            },
                            child: Text("Yes",style: TextStyle(color: Colors.white),
                            ),

                          ),

                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        }

    );
  }



}
// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:wellbeing_application/utils/helperfunctions.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_widget.dart';
import '../settings/settings.dart';
import '../../constants.dart';



/*
This is to display the user's information.

Information to include is:
  - Personal Information (Email, Study Year)
  - Web Information (What forums that they are following)

 */



class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseApi databaseMethods = new FirebaseApi();
  DocumentSnapshot userInformation;
  String userFN = "";
  String userLN = "";
  String username = "";
  String userEmail = "";
  int userColour = 0;

  getUserProfileDetails(String UID){
    databaseMethods.getUserInformation(UID).then((val){
      setState(() {
        userInformation = val;
      });
      userFN = userInformation["first_name"];
      userLN = userInformation["last_name"];
      username = userInformation["username"];
      userColour = userInformation["colour"];
      userEmail = userInformation["email"];
    });

  }

  @override
  void initState(){
    getUserProfileDetails(Constants.myUID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
          leading: NavigationWidget(),
          actions: <Widget>[
            Padding(padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap:() {
                /*showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Testing'),
                    content:  Text('It is working'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed:  () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );*/
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(themeColour: this.userColour)));
                getUserProfileDetails(Constants.myUID);
              },
              child: Icon(
                  Icons.settings,
                  size: 26.0)
            )
            ),
          ],
        ),
         body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  heightFactor: 2.7,
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(Constants.myAvatar), fit: BoxFit.fill),
                      color: Colors.lightBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(Constants.myMoodColour).withOpacity(1), style: BorderStyle.solid, width : 1.0),
                    ),
                  ),
                ),
              ],
            ),
            Text("PROFILE", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height / 8,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color(Constants.myThemeColour).withOpacity(1),
                    width: 0.5,
                    style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [ profileText("Username:"), SizedBox(width: 10), Text(username)],
                    ),
                    Row(
                      children: [ profileText("First Name:"),SizedBox(width: 10), Text(userFN)],
                    ),
                    Row(
                      children: [ profileText("Last Name:"),SizedBox(width: 10), Text(userLN)],
                    ),
                    Row(
                      children: [ profileText("Email:"),SizedBox(width: 10), Text(userEmail)],
                    ),




                  ],
                ),
              )
              ,
            ),

            /* FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () async {
              await FirebaseAuth.instance.signOut();
              },
              child: Text("Log Out")
              ), */
          ],
        )



    );
  }
}




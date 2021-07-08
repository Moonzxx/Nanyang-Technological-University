import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'settings.dart';


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
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          actions: <Widget>[
            Padding(padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap:() {
                showDialog<String>(
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
                );

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
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  heightFactor: 2.7,
                  child: Container(
                    width: 100.0,
                    height:100.0,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, style: BorderStyle.solid, width : 1.0),
                    ),
                    child:
                    Icon(
                        Icons.headphones_battery_rounded ,size: 15.0),

                  ),
                ),
                Positioned(
                  right: 150.0,
                  top: 140.0,
                  child: Container(
                    width: 30.0,
                    height:40.0,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, style: BorderStyle.solid, width : 1.0),
                    ),
                    child:
                    Icon(
                        Icons.add_a_photo ,size: 15.0),

                  )
                )
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height / 10,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                    style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(15.0),
              ),
            ),
              SizedBox(height: 20.0,),

              Container(
                height: MediaQuery.of(context).size.height / 30,
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white,
                  backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    child: Text("Log Out")
                ),
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




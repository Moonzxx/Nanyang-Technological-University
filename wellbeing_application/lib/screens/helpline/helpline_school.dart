import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../constants.dart';
import '../../widgets/custom_snackbar.dart';

class SchoolHelplinePage extends StatefulWidget {
  const SchoolHelplinePage({Key? key}) : super(key: key);

  @override
  _SchoolHelplinePageState createState() => _SchoolHelplinePageState();
}

class _SchoolHelplinePageState extends State<SchoolHelplinePage> {

  FirebaseApi databaseMethods = new FirebaseApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
        title: Text("School Helpline", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height/ 5,
              width: MediaQuery.of(context).size.width/1.1,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.red)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Click on this button if you need \nsomeone to talk to immediately", style: TextStyle(fontSize: 20)),
                  ElevatedButton(
                      onPressed: (){
                        Map<String, dynamic> userAlertInfo = {
                          "userAlert" : Constants.myName,
                          "userID" : Constants.myUID,
                          "userEmail": Constants.myEmail
                        };
                        databaseMethods.setAlert(userAlertInfo);
                        CustomSnackBar.buildPositiveSnackbar(context, "ADMIN HAS BEEN ALERTED!");

                      },
                      child: Text("HELP"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      elevation: 5,
                      textStyle: TextStyle(fontSize: 50)
                    )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

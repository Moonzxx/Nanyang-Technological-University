// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/constants.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_widget.dart';
import '../../widgets/custom_snackbar.dart';

class UserNotifcations extends StatefulWidget {
  const UserNotifcations({Key key}) : super(key: key);

  @override
  _UserNotifcationsState createState() => _UserNotifcationsState();
}

class _UserNotifcationsState extends State<UserNotifcations> {

  FirebaseApi databaseMethods = new FirebaseApi();
  List userNotificationsList = [];


  getUserNotifications() async{
    QuerySnapshot coll = await FirebaseFirestore.instance.collection("users").doc(Constants.myUID).collection("notifications").get();
    List<DocumentSnapshot> collDocs = coll.docs;
    for(var i = 0; i < collDocs.length; i++){
      Map<String, dynamic> notificationInfo = new Map();
      notificationInfo["from"] = collDocs[i]["from"];
      notificationInfo["content"] = collDocs[i]["content"];
      notificationInfo["notifID"] = collDocs[i]["notifID"];
      setState(() {
        userNotificationsList.add(notificationInfo);
      });

    }

  }

  Widget displayUserNotificationList(){
    return (userNotificationsList.length > 0) ? ListView.builder(
      itemCount: userNotificationsList.length,
      itemBuilder: (context, index){
        final item = userNotificationsList[index]["notifID"];
        return Dismissible(
          key: Key(item),

          onDismissed: (direction) {
            setState(() {
              databaseMethods.deleteUserNotification(Constants.myUID, userNotificationsList[index]["notifID"]);
              userNotificationsList.removeAt(index);
              CustomSnackBar.buildPositiveSnackbar(context, "Notification Deleted!");
            });
          },
          background: Container(color: Colors.red),
          child: userNotifTile(
            featureName: userNotificationsList[index]["from"],
            featureMessage: userNotificationsList[index]["content"],
          ),
        );
      },
    ) : Container();
  }

  @override
  void initState(){
    getUserNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: NavigationWidget() ,
          backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
          title: Text("Notifications", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
          centerTitle: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                //top: Radius.circular(30),
                  bottom: Radius.circular(30)
              )
          ),

        ),
        body: displayUserNotificationList()

    );
  }
}



class userNotifTile extends StatelessWidget {
  final String featureName;
  final String featureMessage;
  userNotifTile({this.featureName, this.featureMessage});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine : true,
      title: Text(this.featureName),
      subtitle: Text(this.featureMessage),
      leading: Icon(Icons.notification_important_rounded, color: Colors.blue,),
    );
  }
}

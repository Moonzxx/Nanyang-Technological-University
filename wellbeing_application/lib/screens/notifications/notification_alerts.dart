// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/constants.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_widget.dart';

class UserNotifcations extends StatefulWidget {
  const UserNotifcations({Key key}) : super(key: key);

  @override
  _UserNotifcationsState createState() => _UserNotifcationsState();
}

class _UserNotifcationsState extends State<UserNotifcations> {

  FirebaseApi databaseMethods = new FirebaseApi();
  List userNotifications = [];


  getUserNotifications() async{
    QuerySnapshot coll = await FirebaseFirestore.instance.collection("users").doc(Constants.myUID).collection("notifications").get();
    List<DocumentSnapshot> collDocs = coll.docs;
    for(var i = 0; i < collDocs.length; i++){
      Map<String, String> notifcationInfo = new Map();
      notifcationInfo["name"] = collDocs[i]["name"];
      notifcationInfo["content"] = collDocs[i]["content"];
      notifcationInfo["notifID"] = collDocs[i]["notifID"];
      userNotifications.add(notifcationInfo);
    }
  }
  
  Widget displayUserNotificationList(){
    return (userNotifications.length > 0) ? ListView.builder(
      itemCount: userNotifications.length,
      itemBuilder: (context, index){
        final item = userNotifications[index];
        return Dismissible(
          key: Key(item),

          onDismissed: (direction) {
            setState(() {
              userNotifications.removeAt(index);
              databaseMethods.deleteUserNotification(Constants.myUID, userNotifications[index]["notifID"]);
            });
          },
          background: Container(color: Colors.red),
          child: userNotifTile(
            featureName: userNotifications[index]["name"],
            featureMessage: userNotifications[index]["content"],
          ),
        );
      },
    ) : Container();
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: NavigationWidget() ,
        backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
        title: Text("Notifications", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.delete ))],
      ),

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

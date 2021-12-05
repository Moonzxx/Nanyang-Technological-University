// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:wellbeing_application/widgets/custom_snackbar.dart';
import '../../constants.dart';
import '../chat/chat_conversation_screen.dart';

class AdminAssignment extends StatefulWidget {
  const AdminAssignment({Key key}) : super(key: key);

  @override
  _AdminAssignmentState createState() => _AdminAssignmentState();
}

class _AdminAssignmentState extends State<AdminAssignment> {

  FirebaseApi databaseMethods = new FirebaseApi();
  List userAlertNotificationsList = [];

  getChatRoomID(String a, String b){
    if (a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    }
    else{
      return "$a\_$b";
    }
  }

  getUserAlerts() async{
    QuerySnapshot coll = await FirebaseFirestore.instance.collection("users").doc(Constants.myUID).collection("Alerts").get();
    List<DocumentSnapshot> collDocs = coll.docs;
    for(var i = 0; i < collDocs.length; i++){
      Map<String, dynamic> alertInfo = new Map();
      alertInfo["userAlert"] = collDocs[i]["userAlert"];
      alertInfo["userID"] = collDocs[i]["userID"];
      alertInfo["chatRoomID"] = getChatRoomID(collDocs[i]["userAlert"], Constants.myName);
      setState(() {
        userAlertNotificationsList.add(alertInfo);
      });

    }

  }


  Widget displayUserNotificationList(){
    return (userAlertNotificationsList.length > 0) ? ListView.builder(
      itemCount: userAlertNotificationsList.length,
      itemBuilder: (context, index){
        final item = userAlertNotificationsList[index]["userID"];
        return Dismissible(
          key: Key(item),

          onDismissed: (direction) {
            setState(() {
              databaseMethods.deleteUserNotification(Constants.myUID, userAlertNotificationsList[index]["userID"]);
              userAlertNotificationsList.removeAt(index);
            });
          },
          background: Container(color: Colors.red),
          child: userNotifTile(
            userAlertName: userAlertNotificationsList[index]["userAlert"],
            userAlertUID: userAlertNotificationsList[index]["userID"],
            userPossibleRoomID: userAlertNotificationsList[index]["chatRoomID"],
          ),
        );
      },
    ) : Container();
  }

  @override
  void initState(){
    getUserAlerts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alerts", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
        body: displayUserNotificationList()
     // body: ,
    );
  }
}



class userNotifTile extends StatelessWidget {
  final String userAlertName;
  final String userAlertUID;
  final String userPossibleRoomID;
  userNotifTile({this.userAlertName, this.userAlertUID, this.userPossibleRoomID});

  FirebaseApi databaseMethods = new FirebaseApi();


  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine : false,
      title: Text(this.userAlertName),
      leading: Icon(Icons.notification_important_rounded, color: Colors.blue,),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: (){
            String chatRoomID = this.userPossibleRoomID;

            List<String> users = [this.userAlertName, Constants.myName];
            Map<String, dynamic> chatRoomMap = {
              "users" : users,
              "chatRoomID" : chatRoomID
            };


            FirebaseApi().createChatRoom(chatRoomID, chatRoomMap );
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatConversationScreen(chatRoomID)));

            //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
          }, icon: Icon(Icons.messenger_rounded, color: Colors.red )),
          SizedBox(width: 2),
          IconButton(onPressed: (){
            databaseMethods.deleteUserAlert(Constants.myUID, this.userAlertUID);
            CustomSnackBar.buildPositiveSnackbar(context, "User Alert Deleted");
            //CustomAlertBox.deleteSGClinicInfo(context, "Delete Clinic?", sgRegionSelected, sgRegionClinicName);
            //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
          }, icon: Icon(Icons.delete, color: Colors.red ))

        ],
      ),
    );
  }
}

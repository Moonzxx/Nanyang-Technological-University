// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../constants.dart';
import '../../widgets/custom_snackbar.dart';

class ChatBlocked extends StatefulWidget {
  const ChatBlocked({Key key}) : super(key: key);

  @override
  _ChatBlockedState createState() => _ChatBlockedState();
}

class _ChatBlockedState extends State<ChatBlocked> {

  FirebaseApi databaseMethods = new FirebaseApi();
  DocumentSnapshot userblocks = null;
  List<Map> userBlockList = [];

  @override
  void initState() {
    databaseMethods.getUserBlockList(Constants.myUID).then((val){
      setState(() {
        userblocks = val;
        userblocks["blocked"].forEach((k,v) {
          //print('${k}: ${v}');
          // adding blocked userIDs
          userBlockList.add({k : v});
        });
      });
      //print(userblocks["blocked"]);
      print(userBlockList);

    });
    super.initState();
  }

  Widget UserBlockList(){
    return userBlockList.isNotEmpty ? ListView.builder(
        itemCount: userBlockList.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
         return BlockTile(
           blockedUser: userBlockList[index].keys.toString(),
           blockedUserID: userBlockList[index].values.toString(),
           blockList: userBlockList,
         );

        })
        : Container();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
        title: Text("Blocked", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
      body: UserBlockList(),
    );
  }
}

class BlockTile extends StatelessWidget {
  final String blockedUser;
  final String blockedUserID;
  List<Map> blockList;
  BlockTile({this.blockedUser, this.blockedUserID, this.blockList});

  FirebaseApi databaseMethods = new FirebaseApi();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/9,
      width: MediaQuery.of(context).size.width / 1.2,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(blockedUser),
            Spacer(),
            GestureDetector(
              onTap: (){
                // Function to unblock someone
                //print(blockList[0].values.toString());
                for(var i = 0; i < blockList.length; i++){
                  if(blockList[i].values.toString() == blockedUserID){
                    blockList.removeAt(i);
                  }
                }

                // Out the updated Block List into a map
                Map<String, dynamic> updatedBlockList = new Map();
                for(var i = 0; i < blockList.length; i++){
                  updatedBlockList[blockList[i].keys.toString()] = blockList[i].values.toString();
                }

                //update database using latest map
                databaseMethods.updateUserBlock(Constants.myUID, updatedBlockList);
                CustomSnackBar.buildPositiveSnackbar(context, blockedUser + " unblocked!");




              },
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("Unblock")
              ),
            ),
          ],
        ),
      ),
    );
  }
}



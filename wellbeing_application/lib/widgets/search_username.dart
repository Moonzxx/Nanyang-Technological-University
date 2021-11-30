// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/firebase_api.dart';
import '../constants.dart';
import '../screens/chat/chat_conversation_screen.dart';


// Screen to search for usernames in the database

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

//Icon(Icons.ac_unit), //Chnage to image asset or another icon

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchTextEditingController = new TextEditingController();
  FirebaseApi database = new FirebaseApi();
  QuerySnapshot searchSnapshot = null;
  DocumentSnapshot userblocks = null;
  List<String> userBlockList = [];  // blockedUserId

  // When the screen is initiated, the following will be initiated as well
  initiateSearch(){
    database.getUserbyUsername(searchTextEditingController.text) //searchTextEditingController.text
        .then((val){
          setState(() {
            // Need to set that so that searchList can be updated
            searchSnapshot = val;
          });
          print(searchSnapshot.docs[0]["username"]);
          print(searchSnapshot.docs.map((doc) => doc.data() ));
    });
  }

  // When message button is clicked, it will open a chatscreen
  createChatroomAndStartConversation({String userName}){
    // Other user, us
    // username 2 is us
    print("${userName}");
    print("${Constants.myName}");
    if(userName != Constants.myName){
      String chatRoomID = getChatRoomID(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatRoomID" : chatRoomID
      };


      FirebaseApi().createChatRoom(chatRoomID, chatRoomMap );
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatConversationScreen(chatRoomID)));
    }else{
      print("You cannot send message to yourself");
    }
  }

  // Tile to present other users
  Widget SearchTile({String userName, String avatarURL, String otherUserID}){
    return Column(
      children: <Widget>[
        Container(
            child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 15.0, top: 8.0),
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(avatarURL),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Text(userName),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      // Create a function to create a chatroom
                      createChatroomAndStartConversation(
                        userName: userName
                      );
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text("Message")
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: (){
                      // Function to block someone
                      //use CustomBox
                      Map<String, dynamic> updatedBlockList = new Map();
                      updatedBlockList = userblocks["blocked"];
                      //need to retrieve current block list first
                      updatedBlockList[userName] = otherUserID;    // This is a map on its own
                      print(updatedBlockList);
                      // Check if it works for multiple blocks
                      database.updateUserBlock(Constants.myUID, updatedBlockList);
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                      // snackbar update green success

                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text("Block")
                    ),
                  ),
                ]
            )
        ),
        Divider(
          height: 5,
          thickness: 5,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }


  // If it is null, it will just display a container
  Widget searchList(){

    return searchSnapshot != null ? ListView.builder(
      itemCount: searchSnapshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        // create a for loop to check user
        if(userBlockList.length == 0){
          return SearchTile(userName: searchSnapshot.docs[index]["username"],
              avatarURL: searchSnapshot.docs[index]["url-avatar"],
              otherUserID: searchSnapshot.docs[index]["userID"]);
        }

        for(var i = 0; i < userBlockList.length; i++){
          if(searchSnapshot.docs[index]["userID"] == userBlockList[i]){
            return Container(
                child: Text("Name not found")
            );
          } else{
            return SearchTile(userName: searchSnapshot.docs[index]["username"],
                avatarURL: searchSnapshot.docs[index]["url-avatar"],
                otherUserID: searchSnapshot.docs[index]["userID"]);
          }
        }

      })
        : Container();
  }

  // Calls this whenever the screen restarts
  @override
  void initState(){
    // get block list
    database.getUserBlockList(Constants.myUID).then((val){
      setState(() {
        userblocks = val;
        userblocks["blocked"].forEach((k,v) {
          //print('${k}: ${v}');
          // adding blocked userIDs
          userBlockList.add(v);
        });
      });
      //print(userblocks["blocked"]);

    });
    super.initState();
  }


  // Search Username Main Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search User")),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search Username",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                      height: 40, width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0x36FFFFFF),
                            Color(0x0FFFFFFF)
                          ]
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Icon(Icons.send_rounded, color: Colors.blue),
                      )
                    ),
                  ),
                ],
              ),
            ),
            searchList()
          ]
        ),
      )
    );
  }
}

// Method to generate the chat ID
getChatRoomID(String a, String b){
  if (a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }
  else{
    return "$a\_$b";
  }
}
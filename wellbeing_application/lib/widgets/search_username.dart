// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/firebase_api.dart';
import '../constants.dart';
import '../screens/chat/chat_conversation_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

//Icon(Icons.ac_unit), //Chnage to image asset

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchTextEditingController = new TextEditingController();
  FirebaseApi database = new FirebaseApi();
  QuerySnapshot searchSnapshot = null;

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

  Widget SearchTile({String userName, String avatarURL}){
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
        return SearchTile(userName: searchSnapshot.docs[index]["username"],
             avatarURL: searchSnapshot.docs[index]["url-avatar"]);
      })
        : Container();
  }

  // Calls this whenever the screen restarts
  @override
  void initState(){
    super.initState();
  }


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
                      child: Icon(Icons.ac_unit)
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

// Help to generate chatroomid
getChatRoomID(String a, String b){
  if (a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }
  else{
    return "$a\_$b";
  }
}
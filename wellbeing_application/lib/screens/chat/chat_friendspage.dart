// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/firebase_api.dart';
import '../../widgets/search_username.dart';
import '../../constants.dart';
import '../../utils/helperfunctions.dart';
import 'chat_conversation_screen.dart';


class ChatFriendsPage extends StatefulWidget {
  const ChatFriendsPage({Key key}) : super(key: key);

  @override
  _ChatFriendsPageState createState() => _ChatFriendsPageState();
}

class _ChatFriendsPageState extends State<ChatFriendsPage> {

  FirebaseApi databaseMethods = new FirebaseApi();
  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          itemBuilder: (context, index){
            return ChatRoomTile( userName: (snapshot.data as QuerySnapshot).docs[index]["chatRoomID"]
                .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                chatRoomId: (snapshot.data as QuerySnapshot).docs[index]["chatRoomID"]);
          }) :  Container();
      }
    );
  }

  @override
  void initState(){
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameInSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     body: chatRoomList(),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.search),
       onPressed: (){
         Navigator.push(context, MaterialPageRoute(builder: (context){
           return SearchScreen();
         }));
       },
     ),
    );
  }

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 24, color: Colors.white),
    ),
  );

}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile({this.userName, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatConversationScreen(chatRoomId)));
      },
      child: Container(
        color: Colors.white54,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            // Can chane first container to circle avatar
            Container(
              height:40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}"),
            ),
            SizedBox(width: 8,),
            Text(userName)
          ],
        )
      ),
    );
  }
}







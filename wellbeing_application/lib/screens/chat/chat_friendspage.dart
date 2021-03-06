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
      appBar: AppBar(
        backgroundColor:  Color(Constants.myThemeColour + 25).withOpacity(1),
        title: Text("Chats", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
     body: chatRoomList(),
     floatingActionButton: Padding(
       padding: const EdgeInsets.only( bottom: 50.0),
       child: FloatingActionButton(
         child: Icon(Icons.search),
         backgroundColor: Color(Constants.myThemeColour).withOpacity(1) ,
         onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context){
             return SearchScreen();
           }));
         },
       ),
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

  FirebaseApi databaseMethods = new FirebaseApi();
  QuerySnapshot searchsnap = null;
  int userMood = 0;

  int getUserMoodColour(){
    databaseMethods.getUserMoodColour(this.userName).then((val){
      searchsnap = val;
      return userMood = searchsnap.docs[0]["mood_colour"];
    });

  }

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
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Color(this.userMood).withOpacity(1), width: 2)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}"),
            ),
            SizedBox(width: 10,),
            Text(userName, style: TextStyle(fontSize: 20, fontFamily: systemHeaderFontFamiy),)
          ],
        )
      ),
    );
  }
}







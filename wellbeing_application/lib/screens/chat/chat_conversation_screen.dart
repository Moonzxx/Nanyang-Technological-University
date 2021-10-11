// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/models/chatMessageModel.dart';
import '../../utils/firebase_api.dart';
import '../../constants.dart';

class ChatConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ChatConversationScreen(this.chatRoomId);

  @override
  _ChatConversationScreenState createState() => _ChatConversationScreenState();

}

class _ChatConversationScreenState extends State<ChatConversationScreen> {

  FirebaseApi databaseMethods = new FirebaseApi();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessagesStream;

  Widget ChatMessageList(){
    return Container(
      margin: EdgeInsets.only(bottom: 80.0),
      child: StreamBuilder(
        stream: chatMessagesStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
            reverse: true,
              itemCount: (snapshot.data as QuerySnapshot).docs.length,
            itemBuilder: (context, index){
                return MessageTile( message: (snapshot.data as QuerySnapshot).docs[index]["message"], isSendByMe: (snapshot.data as QuerySnapshot).docs[index]["sendBy"] == Constants.myName);
            }) : Container();
        },
      ),
    );
  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message" :  messageController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.clear();
    }
  }

  @override
  void initState(){
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),  // Can change to person avatar and username  // Try to get notification index as well
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            ChatMessageList(),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 70,
                  color: Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          //initiateSearch();
                          sendMessage();
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
                            child: Icon(Icons.ac_unit)      // change to a send image
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile({ this.message, this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0: 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ] : [
              const Color(0xFFFFFFFF),
              const Color(0xFFFFFFFF)
              ]
          ),
        borderRadius: isSendByMe ?
            BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)
            )
        ),
        child: Text(message,
        style: TextStyle(
          color: Colors.black, fontSize: 17
        ),),
      ),
    );
  }
}


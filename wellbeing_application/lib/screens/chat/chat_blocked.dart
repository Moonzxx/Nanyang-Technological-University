import 'package:flutter/material.dart';

class ChatBlocked extends StatefulWidget {
  const ChatBlocked({Key? key}) : super(key: key);

  @override
  _ChatBlockedState createState() => _ChatBlockedState();
}

class _ChatBlockedState extends State<ChatBlocked> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text("Blocked", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
    );
  }
}

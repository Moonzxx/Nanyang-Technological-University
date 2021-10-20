import 'package:flutter/material.dart';

class UserForumPosts extends StatefulWidget {
  const UserForumPosts({Key? key}) : super(key: key);

  @override
  _UserForumPostsState createState() => _UserForumPostsState();
}

class _UserForumPostsState extends State<UserForumPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text("My Post", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
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

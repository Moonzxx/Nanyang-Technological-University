// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';

class ViewForumPost extends StatefulWidget {
  final String fTitle;
  final String fDescription;
  final String fUser;
  final String fCategory;
  ViewForumPost({ this.fTitle,  this.fDescription,  this.fUser,  this.fCategory});


  @override
  _ViewForumPostState createState() => _ViewForumPostState();
}

class _ViewForumPostState extends State<ViewForumPost> {
  FirebaseApi databaseMethods = new FirebaseApi();
  Stream replyPosts;


  @override
  void initState(){
    getRepliesPost();
    super.initState();
  }

  getRepliesPost(){
    databaseMethods.getRepliesPost(widget.fCategory, widget.fTitle).then((value){
      setState(() {
        replyPosts = value;
      });
    });
  }
  
  displayReplyPosts(){
    return StreamBuilder(
      stream: replyPosts,
      builder: (context, snapshot){
        return ReplyPosts();
        /* return snapshot.hasData ? Expanded(
          child: SizedBox(
            child: ListView.builder(
              itemCount: (snapshot.data as QuerySnapshot).docs.length,
              itemBuilder: (context, index){
                print((snapshot.data as QuerySnapshot).docs[index]['reply']);
                return DisplayForumPost(userName: (snapshot.data as QuerySnapshot).docs[index]['username'],
                    userContent: (snapshot.data as QuerySnapshot).docs[index]['reply'],
                fTitle: widget.fTitle,);
              },
            ),
          ),
        ): Container();

         */
      },
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dicussion Post"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Forum title here"),
            SizedBox(height: 10,),
            DisplayForumPost(userName: widget.fUser, userContent: widget.fDescription),
            SizedBox(height: 30),
            displayReplyPosts(),

          ],
        )
      ),
    );
  }
}

class DisplayForumPost extends StatelessWidget {
  final String userName;
  final String userContent;
  final String fTitle;
  DisplayForumPost({ this.userName,  this.userContent, this.fTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/ 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(this.userName),
          ),
          SizedBox(height:10),
          Container(
            width: MediaQuery.of(context).size.width/3,
            height: MediaQuery.of(context).size.height/4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Text(this.userContent),
          ),
        ],
      )
    );
  }
}

class ReplyPosts extends StatelessWidget {
  const ReplyPosts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Column(
        children: [
          Text("here sis")
        ],
      ),
    );
  }
}

// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants.dart';
import 'forum_viewForumPost.dart';

class UserBookmarked extends StatefulWidget {
  const UserBookmarked({Key key}) : super(key: key);

  @override
  _UserBookmarkedState createState() => _UserBookmarkedState();
}

class _UserBookmarkedState extends State<UserBookmarked> {

  FirebaseApi databaseMethods = new FirebaseApi();
  List userBookmarkedPost = [];

  @override
  void initState(){
    getUserBookmarkedPosts();
    super.initState();
  }

  getUserBookmarkedPosts() async{
    String postCategory;
    List userBookmarked = [];

    QuerySnapshot coll = await FirebaseFirestore.instance.collection("forums").get();
    List<DocumentSnapshot> collDocs = coll.docs;
    for(var i = 0; i < collDocs.length; i++){
      postCategory = collDocs[i]["name"];
      QuerySnapshot postColl = await FirebaseFirestore.instance.collection("forums").doc(collDocs[i]["name"]).collection("posts").get();
      List<DocumentSnapshot> postDocs = postColl.docs;
      print(postDocs.length);
      // Traverse through post
      for(var a = 0; a < postDocs.length; a++){
        userBookmarked = postDocs[a]['bookmarkedBy'];
        for(var b = 0; b < userBookmarked.length; b++){
          if(userBookmarked[b] == Constants.myUID){
            var bookmarkMap = new Map();
            bookmarkMap['postName'] = postDocs[a]['name'];
            bookmarkMap['category'] = postCategory;
            bookmarkMap['content'] = postDocs[a]['content'];
            bookmarkMap['user'] = postDocs[a]['username'];
            bookmarkMap['bookmarked'] = postDocs[a]['bookmarkedBy'];

            setState(() {
              userBookmarkedPost.add(bookmarkMap);
            });

          }

         }
      }
    }
  }


  Widget userBookmarkedPostList(){
    return ListView.builder(
        itemCount: userBookmarkedPost.length,
        itemBuilder: (context, index){
          return userBookmarkedTile(postCategory: userBookmarkedPost[index]["category"],
              postName: userBookmarkedPost[index]["postName"],
            postUser: userBookmarkedPost[index]["user"],
            postDescription: userBookmarkedPost[index]["content"],
          postBookmarked: userBookmarkedPost[index]["bookmarked"],

          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
        title: Text("Bookmarked", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
      body: userBookmarkedPostList()
    );
  }
}


class userBookmarkedTile extends StatelessWidget {
  final String postName;
  final String postCategory;
  final String postDescription;
  final String postUser;
  final List postBookmarked;
  userBookmarkedTile({this.postName, this.postCategory, this.postDescription, this.postBookmarked, this.postUser});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewForumPost(
          fTitle: this.postName , fDescription: this.postDescription , fUser: this.postUser, fCategory: this.postCategory , fBookmarked: this.postBookmarked ,
        )));
      },
      child: Container(

        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(width: 2, color: Color(Constants.myThemeColour + 25).withOpacity(1),)
            ),
            title: Text(this.postName),
            trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.blue),

          ),
        ),
      ),
    );
  }
}
// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants.dart';

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
              postName: userBookmarkedPost[index]["postName"]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text("Bookmarked", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
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
  userBookmarkedTile({this.postName, this.postCategory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => ));
      },
      child: Container(
        height: MediaQuery.of(context).size.height/10,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Card(
          elevation: 5,
          child: ListTile(
            title: Text(this.postName),
            trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.blue),

          ),
        ),
      ),
    );
  }
}
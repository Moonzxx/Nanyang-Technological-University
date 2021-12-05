// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants.dart';
import 'forum_viewForumPost.dart';
import '../../widgets/custom_AlertBox.dart';

class UserForumPosts extends StatefulWidget {
  const UserForumPosts({Key key}) : super(key: key);

  @override
  _UserForumPostsState createState() => _UserForumPostsState();
}

class _UserForumPostsState extends State<UserForumPosts> {

  FirebaseApi databaseMethods = new FirebaseApi();
  List userPost = [];

  @override
  void initState(){
    getUserPosts();
    super.initState();
  }

  getUserPosts() async{
    String postCategory;

    QuerySnapshot coll = await FirebaseFirestore.instance.collection("forums").get();
    List<DocumentSnapshot> collDocs = coll.docs;
    for(var i = 0; i < collDocs.length; i++){
      postCategory = collDocs[i]["name"];
      QuerySnapshot postColl = await FirebaseFirestore.instance.collection("forums").doc(collDocs[i]["name"]).collection("posts").get();
      List<DocumentSnapshot> postDocs = postColl.docs;
      // Traverse through post
      for(var a = 0; a < postDocs.length; a++){
        if(postDocs[a]['userID'] == Constants.myUID){
          var userPostMap = new Map();
          userPostMap['postName'] = postDocs[a]['name'];
          userPostMap['category'] = postCategory;
          userPostMap['content'] = postDocs[a]['content'];
          userPostMap['user'] = postDocs[a]['username'];
          userPostMap['bookmarked'] = postDocs[a]['bookmarkedBy'];
          setState(() {
            userPost.add(userPostMap);
          });

        }
        //userBookmarked = postDocs[a]['bookmarkedBy'];
        //for(var b = 0; b < userBookmarked.length; b++){
          //var bookmarkMap = new Map();
          //bookmarkMap['postName'] = postDocs[a]['name'];
          //bookmarkMap['category'] = postCategory;
       // }
      }
    }
  }


  Widget userPostList(){
    return ListView.builder(
        itemCount: userPost.length,
        itemBuilder: (context, index){
          return userPostTile(postCategory: userPost[index]["category"],
              postName: userPost[index]["postName"],
          postUser: userPost[index]["user"],
          postContent: userPost[index]["content"],
          postBookmarked: userPost[index]["bookmarked"]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
        title: Text("My Post", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
      body: userPostList()
    );
  }
}

class userPostTile extends StatelessWidget {
  final String postName;
  final String postCategory;
  final String postContent;
  final String postUser;
  final List postBookmarked;
  userPostTile({this.postName, this.postCategory, this.postBookmarked, this.postUser, this.postContent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            ViewForumPost(fTitle: this.postName , fDescription: this.postContent , fUser: this.postUser , fCategory: this.postCategory , fBookmarked: this.postBookmarked )));
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: (){
                  CustomAlertBox.deleteForumPostConfirmation(context, "Delete Post?", this.postCategory, this.postName);
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
                }, icon: Icon(Icons.delete, color: Colors.red )),
                SizedBox(width: 2),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.blue)

              ],
            ),

          ),
        ),
      ),
    );
  }
}
// icon delete
// Icon(Icons.arrow_forward_ios_rounded, color: Colors.blue)

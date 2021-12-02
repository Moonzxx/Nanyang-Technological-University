// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wellbeing_application/constants.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'forum_viewForumPost.dart';

class ForumCategoryPostList extends StatefulWidget {
  final String selectedCategory;
  ForumCategoryPostList({  this.selectedCategory});

  @override
  _ForumCategoryPostListState createState() => _ForumCategoryPostListState();
}

class _ForumCategoryPostListState extends State<ForumCategoryPostList> {

  FirebaseApi databaseMethods = new FirebaseApi();
  Stream ForumCatList;

  @override
  void initState(){
    getCategoryPostList(widget.selectedCategory);
    super.initState();
  }

  getCategoryPostList(String forumCategory){
      databaseMethods.getCategoryForumPosts(widget.selectedCategory).then((val){
        setState(() {
          ForumCatList = val;
        });
      });
  }

  Widget ForumCategoryList(){
    return StreamBuilder(
      stream: ForumCatList,
        builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
            itemBuilder: (context, index){
                return ForumTile(forumTitle: (snapshot.data as QuerySnapshot).docs[index]["name"],
                forumDescription: (snapshot.data as QuerySnapshot).docs[index]["content"],
                forumUser: (snapshot.data as QuerySnapshot).docs[index]["username"],
                fCategory: widget.selectedCategory,
                bookmarked: (snapshot.data as QuerySnapshot).docs[index]["bookmarkedBy"],);
            }) :  Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
          title: Text(widget.selectedCategory),
        ),
      body: ForumCategoryList()
    );
  }
}


class ForumTile extends StatelessWidget {
  final String forumTitle;
  final String forumDescription;
  final String forumUser;
  final String fCategory;
  final List bookmarked;
  ForumTile({ this.forumTitle, this.forumDescription, this.forumUser, this.fCategory, this.bookmarked});

  
  // Create your own customised tile
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewForumPost(fTitle: this.forumTitle, fDescription: this.forumDescription, fUser: this.forumUser , fCategory: this.fCategory , fBookmarked: this.bookmarked,)));
      },
       child:  Container(
         height: MediaQuery.of(context).size.height/11,
         width: MediaQuery.of(context).size.width,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(20),
         ),
         child: Card(
           elevation: 5,
           child: ListTile(
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(15.0),
                 side: BorderSide(width: 2, color: Color(Constants.myThemeColour + 25).withOpacity(1),)
             ),
             title: Text(this.forumTitle),
             subtitle: Text(this.forumDescription),
             trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.blue),

           ),
         ),
       ),
    );
  }
}


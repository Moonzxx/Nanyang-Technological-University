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
                forumDescription: (snapshot.data as QuerySnapshot).docs[index]["description"],
                forumUser: (snapshot.data as QuerySnapshot).docs[index]["username"],
                fCategory: widget.selectedCategory);
            }) :  Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedCategory)
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
  ForumTile({ this.forumTitle, this.forumDescription, this.forumUser, this.fCategory});

  
  // Create your own customised tile
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewForumPost(fTitle: this.forumTitle, fDescription: this.forumDescription, fUser: this.forumUser , fCategory: this.fCategory ,)));
      },
      child: Card(
        shadowColor: Colors.black,
        elevation: 5.0,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(this.forumTitle, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("some small desciption", textAlign: TextAlign.left,),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.star_border_rounded), color: Colors.yellowAccent,),
                      Text("23")
                    ],
                  ),
                  SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.reply_rounded), color: Colors.blue),
                      Text("2")
                    ],
                  ),
                ],
              ),
            ),
          ],
        )

      ),
    );
  }
}


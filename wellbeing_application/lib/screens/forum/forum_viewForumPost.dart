// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'forum_createReply.dart';
import '../../constants.dart';
import '../../widgets/custom_snackbar.dart';


class ViewForumPost extends StatefulWidget {
  final String fTitle;
  final String fDescription;
  final String fUser;
  final String fCategory;
  final List fBookmarked;
  ViewForumPost({ this.fTitle,  this.fDescription,  this.fUser,  this.fCategory, this.fBookmarked});


  @override
  _ViewForumPostState createState() => _ViewForumPostState();
}

class _ViewForumPostState extends State<ViewForumPost> {
  FirebaseApi databaseMethods = new FirebaseApi();
  Stream replyPosts;
  bool marked = false;


  @override
  void initState(){
    for(var a = 0; a < widget.fBookmarked.length; a++){
      if(widget.fBookmarked[a] == Constants.myUID){
        setState(() {
          marked = true;
        });
      }
    }
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
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return ReplyPosts(
              replyUserName: (snapshot.data as QuerySnapshot).docs[index]['username'],
              replyUserContent: (snapshot.data as QuerySnapshot).docs[index]['content'],
              forumUser: widget.fUser,
            );
          },
        ) : Container();
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
          backgroundColor: Constants.secondaryColour,
          title: Text(widget.fTitle, style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
          centerTitle: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                //top: Radius.circular(30),
                  bottom: Radius.circular(30)
              )
          ),
          actions: [IconButton(onPressed: (){
            setState(() {
              marked = !marked;
              // Both update and remove bookmarks are working
              if(marked == true){
                //add user to post bookmark list
                databaseMethods.updateAddForumPostBookmarkInfo(widget.fCategory, widget.fTitle, Constants.myUID).then((var num){
                  CustomSnackBar.buildPositiveSnackbar(context, "Post Bookmarked!");
                });
              }
              else{
                databaseMethods.updateRemoveForumPostBookmarkInfo(widget.fCategory, widget.fTitle, Constants.myUID).then((var num){
                  CustomSnackBar.buildPositiveSnackbar(context, "Post Unbookmarked!");
                });
                // remove user from post bookmarklist
              }
            });

          }, icon: Icon(Icons.bookmark, color: (marked) ? Colors.black : Colors.white))],
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    height: MediaQuery.of(context).size.height/3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      border: Border.all(
                        color: Colors.black // see how is fits
                      )
                    ),
                    child: Padding(
                      // can refer to show tips view
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.fUser, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: systemHeaderFontFamiy, fontSize: 25, decoration: TextDecoration.underline)),
                          SizedBox(height: 10),
                          Text(widget.fDescription, style: TextStyle(fontFamily: systemHeaderFontFamiy))
                        ],
                      ),
                    ),
                  ),
                ),

            SizedBox(height: 30),
            Text("Replies", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: systemHeaderFontFamiy, fontSize: 30, decoration: TextDecoration.underline)),
              SizedBox(height: 10),
              displayReplyPosts()
              //getRepliesPost(),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.secondaryColour,
          child: Icon(Icons.reply_rounded),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => createForumReply(
              replyCat: widget.fCategory,
              replyForumTitle: widget.fTitle,
            ) ));

          },
        ),

     /* body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(

            ),
            /* Text("Forum title here"),
            SizedBox(height: 10,),
            DisplayForumPost(userName: widget.fUser, userContent: widget.fDescription),
            SizedBox(height: 30),
            displayReplyPosts(),*/

          ],
        )
      ),*/
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
                border: Border.all(
                    color: Constants.secondaryColour
                )
            ),
            child: Text(this.userContent),
          ),
        ],
      )
    );
  }
}

class ReplyPosts extends StatelessWidget {
  final String replyUserName;
  final String replyUserContent;
  final String forumUser;
  ReplyPosts({this.replyUserName, this.replyUserContent, this.forumUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: MediaQuery.of(context).size.height/9,
        width: MediaQuery.of(context).size.width/ 1.4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border: Border.all(
                color: Constants.secondaryColour,
                    width: 2
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // reply to be red if it is the users own post
              // if users's comment, if anonymous true, name will be anonymous
              // can reply anonymously??
              Text(replyUserName, style: TextStyle(fontFamily: systemHeaderFontFamiy, fontSize: 18.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline,
              color: (replyUserName == Constants.myName && forumUser != "Anonymous") ? Colors.red: Colors.black)),
              SizedBox(height: 10),
              Text(replyUserContent, style: TextStyle(fontFamily: systemHeaderFontFamiy, fontSize: 14))
            ],
          ),
        ),
      ),
    );
  }
}

// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'tips_TTViewPost.dart';
import '../../constants.dart';

class PostLists extends StatefulWidget {
  //which cat
  final String mCategory;
  final String sCategory;
  PostLists({ this.mCategory,  this.sCategory});

  @override
  _PostListsState createState() => _PostListsState();
}

class _PostListsState extends State<PostLists> {
  FirebaseApi databaseMethods = new FirebaseApi();
  Stream ttPostStream;

  @override
  void initState(){
    print(widget.mCategory);
    print(widget.sCategory);
    databaseMethods.getTTCatPosts(widget.mCategory, widget.sCategory).then((val){
      setState(() {
        ttPostStream = val;
      });

    });
    super.initState();
  }

  Widget TTPostList(){
    return StreamBuilder(
      stream: ttPostStream,
      builder: (context, snapshot){
        return ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          itemBuilder: (context, index){
            return PostTiles(mCat: widget.mCategory,
                sCat: widget.sCategory,
                postTitle: (snapshot.data as QuerySnapshot).docs[index]["name"]);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
        title: Text(widget.sCategory),
      ),
      body: TTPostList(),
    );
  }
}

class PostTiles extends StatelessWidget {
  final String mCat;
  final String sCat;
  final String postTitle;
  PostTiles({ this.mCat, this.sCat, this.postTitle});

  // Should short description be added??

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => TTViewPost(mainCat: this.mCat,
            subCat: this.sCat,
            postTitleName: this.postTitle)));
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
              title: Text(this.postTitle),
            trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.blue),

          ),
        ),
      ),
    );
  }
}


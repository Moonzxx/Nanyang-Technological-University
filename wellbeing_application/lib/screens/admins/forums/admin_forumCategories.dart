// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_searchpost.dart';


class SearchForumCategoriesPost extends StatefulWidget {
  const SearchForumCategoriesPost({Key key}) : super(key: key);

  @override
  _SearchForumCategoriesPostState createState() => _SearchForumCategoriesPostState();
}

class _SearchForumCategoriesPostState extends State<SearchForumCategoriesPost> {

  FirebaseApi databaseMethods = new FirebaseApi();
  Stream ForumCategoryPosts;

  String selectedForumCategories;
  List<String> forumCategories = [];


  getForumCategories() async{
    QuerySnapshot coll = await FirebaseFirestore.instance.collection("forums").get();
    List<DocumentSnapshot> collDocs = coll.docs;
    for(var i = 0; i < collDocs.length; i++){
      setState(() {
        forumCategories.add(collDocs[i]["name"]);
      });
    }
    setState(() {
      selectedForumCategories = forumCategories[0];
    });
  }

  @override
  void initState(){
    getForumCategories();
    super.initState();
  }

  Widget DisplayForumCategoriesList(){
    return ListView.builder(
            itemCount: forumCategories.length,
            itemBuilder: (context, index){
              // it does returns back the correct information
              return ForumCatTiles(
                catName: forumCategories[index],
              );
            },


          );

        }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text("Search Forums", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
        actions: [IconButton(onPressed: (){
          //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
        }, icon: Icon(Icons.search_rounded, color: Colors.white ))],
      ),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width:MediaQuery.of(context).size.width,
            child: DisplayForumCategoriesList())
      )
    );
  }
}

class ForumCatTiles extends StatelessWidget {
  final String catName;
  ForumCatTiles({this.catName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchForumPost(catName: this.catName)));
      },
      child: Container(
        height: MediaQuery.of(context).size.height/8,
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 5,
          child: ListTile(
            leading: Icon(Icons.play_arrow_rounded),
            title: Text(this.catName),

          ),
        ),
      ),
    );
  }
}

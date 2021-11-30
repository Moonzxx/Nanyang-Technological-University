// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'forum_viewForumPost.dart';


// Searching forum post according to category
class SearchForumPost extends StatefulWidget {
  const SearchForumPost({Key key}) : super(key: key);

  @override
  _SearchForumPostState createState() => _SearchForumPostState();
}

class _SearchForumPostState extends State<SearchForumPost> {

  FirebaseApi databaseMethods = new FirebaseApi();
  Stream forumCategoryPosts;
  List<String> forumCategoriesNames = [];

  String selectedForumCategory;

  useSearch(String forumCategory){
    databaseMethods.getCategoryForumPosts(forumCategory).then((val){
      setState(() {
        forumCategoryPosts = val;
      });
    });
  }

  getForumCategories() async{
    QuerySnapshot forumColl = await FirebaseFirestore.instance.collection("forums").get();
    List<DocumentSnapshot>  forumDocs = forumColl.docs;
    for(var i = 0; i < forumDocs.length; i++){
      setState(() {
        forumCategoriesNames.add(forumDocs[i]["name"]);
      });
    }
    setState(() {
      selectedForumCategory = forumCategoriesNames[0];
    });
  }

  Widget forumCategoryPostSearchList(){
    return StreamBuilder(
      stream: forumCategoryPosts,
      builder: (context, snapshot){
        return (snapshot.hasData) ? ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return forumCategoryPostTile(
                forumTitle: (snapshot.data as QuerySnapshot).docs[index]["name"],
                forumDescription: (snapshot.data as QuerySnapshot).docs[index]["content"],
                forumUser: (snapshot.data as QuerySnapshot).docs[index]["username"],
                fCategory: selectedForumCategory,
                bookmarked: (snapshot.data as QuerySnapshot).docs[index]["bookmarkedBy"]
            );
          },
        ) : 
        Container();
      }
    );
  }

  @override
  void initState(){
    getForumCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text("Search Posts", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
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
      body: Column(
        children: [
          DropdownButton(
              value: selectedForumCategory,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 20,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                  height: 2,
                  color: Colors.black),
              onChanged: (String newValue){
                setState(() {
                  selectedForumCategory = newValue;
                  useSearch(selectedForumCategory);
                });
              },
              items:  forumCategoriesNames
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList()
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: forumCategoryPostSearchList(),
            ),
          ),
        ],
      ),
    );
  }
}

class forumCategoryPostTile extends StatelessWidget {
  final String forumTitle;
  final String forumDescription;
  final String forumUser;
  final String fCategory;
  final List bookmarked;
  forumCategoryPostTile({ this.forumTitle, this.forumDescription, this.forumUser, this.fCategory, this.bookmarked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewForumPost(fTitle: this.forumTitle, fDescription: this.forumDescription, fUser: this.forumUser , fCategory: this.fCategory , fBookmarked: this.bookmarked,)));
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


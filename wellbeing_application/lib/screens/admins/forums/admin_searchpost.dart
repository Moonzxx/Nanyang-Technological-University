// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:wellbeing_application/constants.dart';



// Searching forum post according to category
class SearchForumPost extends StatefulWidget {
  final String catName;
  SearchForumPost({this.catName});

  @override
  _SearchForumPostState createState() => _SearchForumPostState();
}

class _SearchForumPostState extends State<SearchForumPost> {

  TextEditingController searchPostEditingController = new TextEditingController();
  FirebaseApi databaseMethods = new FirebaseApi();
  Stream forumCategoryPosts;
  List<String> forumCategoriesNames = [];
  bool search = false;
  String searchpostName;

  String selectedForumCategory;

  useSearch(){
    databaseMethods.getCategoryForumPosts(widget.catName).then((val){
      setState(() {
        forumCategoryPosts = val;
      });
    });
  }

    Widget searchPostNameList(String postName){
    return StreamBuilder(
        stream: forumCategoryPosts,
        builder: (context, snapshot){
          return (snapshot.hasData) ? ListView.builder(
            itemCount: (snapshot.data as QuerySnapshot).docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index){
              if((snapshot.data as QuerySnapshot).docs[index]["name"] == postName){
                return forumCategoryPostTile(
                    forumTitle: (snapshot.data as QuerySnapshot).docs[index]["name"],
                    forumDescription: (snapshot.data as QuerySnapshot).docs[index]["content"],
                    forumUser: (snapshot.data as QuerySnapshot).docs[index]["username"],
                    fCategory: selectedForumCategory,
                    bookmarked: (snapshot.data as QuerySnapshot).docs[index]["bookmarkedBy"]
                );
              }

            },
          ) :
          Container();
        }
    );
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
    useSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Search User")),
        body: Container(
          child: Column(
              children: <Widget>[
                Container(
                  color: Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: searchPostEditingController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Search post Name",
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            search = true;
                          });
                          searchpostName = searchPostEditingController.text;
                        },
                        child: Container(
                            height: 40, width: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0x36FFFFFF),
                                    Color(0x0FFFFFFF)
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Icon(Icons.send_rounded, color: Colors.blue),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                (search) ? searchPostNameList(searchpostName) : forumCategoryPostSearchList()
              ]
          ),
        )
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
    return Container(
      height: MediaQuery.of(context).size.height/10,
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
          trailing: IconButton(onPressed: (){

            //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
          }, icon: Icon(Icons.delete, color: Colors.blueGrey )),

        ),
      ),
    );
  }
}


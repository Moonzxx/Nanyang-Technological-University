// @dart=2.10
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'dart:convert';
import 'forum_postList.dart';
import 'forum_createpost.dart';
import '../../constants.dart';





class ForumHomePage extends StatefulWidget {

  @override
  _ForumHomePageState createState() => _ForumHomePageState();
}

class _ForumHomePageState extends State<ForumHomePage> {

  List ForumCategoriesNum;

  @override
  void initState(){
    //ForumCategoriesNum = getForumListLength();
    getForumInfo();
    /*
    Database capture:-
      - Length of category list
      - All the names in the category
      - Titles of the post from Forums
     */
    super.initState();
  }

  // Initialise this whenever the page is loaded
  // To limit memory reading from database to app, unless refresh button is pressed on
  // Getting Forum Categories, forum post and descriptions
  void getForumInfo() async {

    String catsName;
    Map categoryMap = Map<String, List>();
    List ola =[];

    QuerySnapshot coll = await FirebaseFirestore.instance.collection("forums").get();
    List<DocumentSnapshot> collDocs = coll.docs;
    print(collDocs.length);

    for(var i = 0; i < collDocs.length; i++){
      ola.add(collDocs[i]["name"]);
    }

    setState(() {
      ForumCategoriesNum = ola;
    });

  }

  // Return top 3 liked post
  Widget top3post(){

  }


  // Return top 3 bookmarked posts

  // Creation of Forum Categories Section (Top)
  Widget ForumCategories() {
    return GridView.builder(
      itemCount: ForumCategoriesNum.length, //ForumCategoriesNum[0],
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              /*showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Testing'),
                  content:  Text('It is working'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed:  () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );

               */
              Navigator.push(context, MaterialPageRoute(builder: (context) => ForumCategoryPostList(selectedCategory: ForumCategoriesNum[index])));
            },
            // Pass list of cats too
            child: CategoryIcon(
                Icons.star_rounded, ForumCategoriesNum[index], true) //ForumCategoryBoard(index+1), //ForumCategoryMap[ForumCategoriesNum[index]][0]
          //child:,
        );
      },
    );
  }


// Got the correct results back


  // Ret

  // Maybe should implement refersh button


  /*
  What the different way prints stuff:
  print("Sets" + docSnapshot.data()['categories'].toString());    :Prints the set in String type
  print(docSnapshot.data()['categories'].length);                   :Prints the no. of elements in the sets
 print(docSnapshot.data()['categories'][0]);                          : Print the first element in the array
 for( var i = 0 ; i < docSnapshot.data()['categories'].length ; i++ ) {
       cats.add(docSnapshot.data()['categories'][i].toString());
       }                                                                      : Prints all the elements in the array one by one


   */


  // Eerytime the page has been selected


  // Create the overall UI
  // Using Column
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
        title: Text(kTipsCategoriesTitle, style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateForumPost(forumCategories: ForumCategoriesNum)));
              },      // Create a function for this
            ),
          )
        ],
      ),

      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 16.0),
            // Like an empty box
            //Container(
            Container(
              height: MediaQuery.of(context).size.height /4,
              width: MediaQuery.of(context).size.width * 0.95,
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(
                    40.0
                  ),
                ),
                child: Center(
                  child: ForumCategories(),
                ),
              ),
            ),
             // child: ForumCategories()
            //),
            //ElevatedButton(onPressed: getForumInfo, child: Text("Testing")),
            SizedBox(height: 15),
            //Text("Latest Post"), // This will be from all posts
            //ForumCategories()

          ],
        ),
      ),
    );
  }
}


class CategoryIcon extends StatefulWidget {
  final String iconText;
  final IconData icon;
  final bool selected;

  CategoryIcon(this.icon, this.iconText, this.selected);

  @override
  _CategoryIconState createState() => _CategoryIconState();
}

class _CategoryIconState extends State<CategoryIcon> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(widget.icon),
            //onPressed here
            color: widget.selected == true
                ? Colors.lightGreen
                : Colors.black,
          ),
          Text(widget.iconText, style: TextStyle(color: Colors.black),)
        ],
      ),

    );
  }
}


// Create a class that iterates all the stuff and into the category Icon

class ForumCategoryBoard extends StatefulWidget {
  int _index;

  ForumCategoryBoard(int index){
    this._index = index;
  }


  @override
  _ForumCategoryBoardState createState() => _ForumCategoryBoardState();
}

class _ForumCategoryBoardState extends State<ForumCategoryBoard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



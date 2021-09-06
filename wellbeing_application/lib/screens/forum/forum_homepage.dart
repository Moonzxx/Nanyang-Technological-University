// @dart=2.10
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'dart:convert';



// Need to try if this is working

class ForumPage extends StatefulWidget {
  const ForumPage({Key key}) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kTipsCategoriesTitle),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
             // onPressed: _onSearchPressed,      // Create a function for this
          )
        ],
      ),
      body: ForumHomePage(),
    );
  }
}




class ForumHomePage extends StatefulWidget {


  @override
  _ForumHomePageState createState() => _ForumHomePageState();
}

class _ForumHomePageState extends State<ForumHomePage> {

  List ForumCategoriesNum;

  @override
  void initState(){
    //ForumCategoriesNum = getForumListLength();
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

    FirebaseFirestore.instance.collection('forums').doc('categories')
        .get().then((docSnapshot) {
      print(docSnapshot.data()['categories'].length);

      for( var i = 0 ; i < docSnapshot.data()['categories'].length ; i++ ) {
        List catsInfo = <String>[];
        catsName = docSnapshot.data()['categories'][i]['category'].toString();
        catsInfo.add(docSnapshot.data()['categories'][i]['icon'].toString());
        categoryMap[catsName] = catsInfo;
        //print(docSnapshot.data()['categories'][i]['icon'].toString());
      }

      print(categoryMap);

      /* print("Sets" + docSnapshot.data()['categories'].toString());
         print(docSnapshot.data()['categories'].length);
         print(docSnapshot.data()['categories'][0]);
   for( var i = 0 ; i < docSnapshot.data()['categories'].length ; i++ ) {
       cats.add(docSnapshot.data()['categories'][i].toString());
       }
       print(cats); */
    });
  }

  // Getting the Forum Categories Icon
  Widget ForumCategories() => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadiusDirectional.circular(16.0),
      color: Colors.blueGrey,
    ),
    child: GridView.builder(
      itemCount: 6,//ForumCategoriesNum[0],
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: (){},
          // Pass list of cats too
          child: ForumCategoryBoard(index+1),
          //child:,
        );
      },
    ),
  );


// Got the correct results back


  // Return the no. of Forum Categories
  List getForumListLength(){
    List categoriesInfo;
    FirebaseFirestore.instance.collection('forums').doc('categories')
        .get().then((docSnapshot) {
            categoriesInfo.add(docSnapshot.data()['categories'].length);
            for( var i = 0 ; i < docSnapshot.data()['categories'].length ; i++ ) {
              categoriesInfo.add(docSnapshot.data()['categories'][i].toString());
            }
        });
    return categoriesInfo;
  }

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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(height: 16.0),           // Like an empty box
          ElevatedButton(onPressed: getForumInfo, child: Text("Testing")),
          //ForumCategories()
        ],
      ),
    );
  }
}

// Creation of Category icon
class CategoryIcon extends StatelessWidget {
  final String iconText;
  final IconData icon;
  final bool selected;

  CategoryIcon(this.icon, this.iconText, this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(icon),
            //onPressed here
            color: selected == true
              ? Colors.lightGreen
                : Colors.black,
          ),
          Text(iconText),
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



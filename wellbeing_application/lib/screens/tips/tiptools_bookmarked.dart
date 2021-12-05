// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants.dart';
import 'tips_TTViewPost.dart';

class TTBookmarked extends StatefulWidget {
  const TTBookmarked({Key key}) : super(key: key);

  @override
  _TTBookmarkedState createState() => _TTBookmarkedState();
}

class _TTBookmarkedState extends State<TTBookmarked> {
  FirebaseApi databaseMethods = new FirebaseApi();
  Stream tipsBookmarked;
  Stream toolsBookmarked;
  List Heree = [];

  List TipsBookmarkedByUser = [];
  List ToolsBookmarkedByUser = [];


  @override
  void initState(){
    getBookmarkedByUser("Tips");
    getBookmarkedByUser("Tools");
    super.initState();
  }

  // return posts that were bookedmarked by the user
  getBookmarkedByUser(String mainCat) async{      // This is working
    List<dynamic> TipsBk;

    QuerySnapshot coll = await FirebaseFirestore.instance.collection("tips").doc(mainCat).collection("categories").get();
    List<DocumentSnapshot> collDocs = coll.docs;
    print(collDocs.length); // returns 3 =, theno. of categories
    for(var i = 0; i < collDocs.length; i++){
      print(collDocs[i]['name']);
      // returns the name of the categories
      QuerySnapshot postColl = await FirebaseFirestore.instance.collection("tips").doc(mainCat).collection("categories").doc(collDocs[i]['name']).collection("posts").get();
      List<DocumentSnapshot> postDocs = postColl.docs;
      // this is sub cat
      print(postDocs.length);
      for(var a = 0; a < postDocs.length; a++){
        TipsBk = postDocs[a]['bookmarkedBy'];
        for(var b = 0; b < TipsBk.length; b++){
          if(TipsBk[b] == Constants.myUID){
            var maptester = new Map();
            maptester['postname'] = postDocs[a]['name'];
            maptester['subCat'] = collDocs[i]['name'];
            maptester['mainCat'] = mainCat;
            print(postDocs[a]['name']);
            setState(() {
              if(mainCat == "Tips"){
                TipsBookmarkedByUser.add(maptester);
              }
              else{
                ToolsBookmarkedByUser.add(maptester);
              }
            });

          }
        }
      }
    }

    // Getting into map in list
    //print(Heree[0]['postname']);

  }
  

  // Need to check that this is working
  // Returns a widget that list bookmarked posts by user
  Widget TipsBookmarkedList(){
    return ListView.builder(
      itemCount: TipsBookmarkedByUser.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return PostTiles(mCat: TipsBookmarkedByUser[index]["mainCat"],
              sCat: TipsBookmarkedByUser[index]["subCat"],
              postTitle: TipsBookmarkedByUser[index]["postname"]);
        });
  }

  Widget ToolsBookmarkedList(){
    return ListView.builder(
        itemCount: ToolsBookmarkedByUser.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return PostTiles(mCat: ToolsBookmarkedByUser[index]["mainCat"],
              sCat: ToolsBookmarkedByUser[index]["subCat"],
              postTitle: ToolsBookmarkedByUser[index]["postname"]);
        });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
          title: Text("Bookmarked", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
          centerTitle: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                //top: Radius.circular(30),
                  bottom: Radius.circular(30)
              )
          ),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:20),
            Container(
              child: Text("Tips",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, fontFamily: systemHeaderFontFamiy, decoration: TextDecoration.underline)),
            ),
            SizedBox(height: 10),
            Container(
                height: MediaQuery.of(context).size.height/5,
                child: TipsBookmarkedList()),
            Container(
              child: Text("Tools", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, fontFamily: systemHeaderFontFamiy, decoration: TextDecoration.underline)),
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height/5,
                child: ToolsBookmarkedList())
          ],
        ),
      )
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
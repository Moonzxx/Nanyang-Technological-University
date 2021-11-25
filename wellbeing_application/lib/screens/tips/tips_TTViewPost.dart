// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants.dart';
import '../../widgets/custom_snackbar.dart';

// Can be applied to tools as well
// When displaying post, can bookmarked it
class TTViewPost extends StatefulWidget {
  final String mainCat;
  final String subCat;
  final String postTitleName;
  TTViewPost({ this.mainCat,  this.subCat,  this.postTitleName});

  @override
  _TTViewPostState createState() => _TTViewPostState();
}

// Viewing of tips and tools
// Maybe can return different scafoold based on boolean to determine if it is under Tips / Tools
class _TTViewPostState extends State<TTViewPost> {

  FirebaseApi databaseMethods = new FirebaseApi();
  bool marked = false;
  QuerySnapshot searchSnapshot = null;
  bool cat = null;
  List sources = null;
  List<Widget> textWidgetList = List<Widget>();
  String android = null;
  String ios = null;

  getPostInformation(){
    databaseMethods.getTipPostInformation(widget.mainCat, widget.subCat, widget.postTitleName).then((val){
      setState(() {
        searchSnapshot = val;
      });
      // manages t
      print(searchSnapshot.docs[0]["name"]);
      print(searchSnapshot.docs[0]["bookmarkedBy"][0]);
      print(searchSnapshot.docs[0]["description"]);
      if(cat){
        // if tips
        sources = searchSnapshot.docs[0]["sourcesFrom"];
        for(var i = 0; i < sources.length; i++){
          textWidgetList.add(
            Text(sources[i])
          );
        }
        //print(sources);
      }
      else{
        android = searchSnapshot.docs[0]["appLinks"]["android"];
        ios = searchSnapshot.docs[0]["appLinks"]["ios"];
      }

    });
  }

  @override
  void initState(){
    if (widget.mainCat == "Tips"){
      setState(() {
        cat = true;
      });
    }
    else{
      setState(() {
        cat = false;
      });
    }
    getPostInformation();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Returning Tips Post View
      appBar: AppBar(
          backgroundColor: Colors.blue[700],
          title: Text(widget.postTitleName, style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
          centerTitle: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                //top: Radius.circular(30),
                  bottom: Radius.circular(30)
              )
          ),
          actions: [
            IconButton(
                onPressed: (){
                  setState(() {
                    marked = !marked;
                    // Both update and remove bookmarks are working
                    if(marked == true){
                      //add user to post bookmark list
                      databaseMethods.updateAddPostBookmarkInfo(widget.mainCat, widget.subCat, widget.postTitleName, Constants.myUID).then((var num){
                        CustomSnackBar.buildPositiveSnackbar(context, "Post Bookmarked!");
                      });
                    }
                    else{
                      // remove user from post bookmarklist
                      databaseMethods.updateRemovePostBookmarkInfo(widget.mainCat, widget.subCat, widget.postTitleName, Constants.myUID).then((var num){
                        CustomSnackBar.buildPositiveSnackbar(context, "Post Unbookmarked!");

                      });
                    }
                  });
                },
                icon: Icon(Icons.bookmark, color: (marked) ? Colors.black : Colors.white))],
          bottom: (cat) ? PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Container(
              margin: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height/10,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.red
                  )
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Sources"),
                    Column(
                      children: textWidgetList,
                    ),
                  ],
                ),
              ),
              ),
            ),
          ) : PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Container(
              margin: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height/10,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.red
                  )
              ),

              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("IOS: "),
                          SizedBox(width: 15),
                          Text(ios)
                        ],
                      ),
                      Row(
                        children: [
                          Text("Android: "),
                          SizedBox(width: 15),
                          Text(android)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )

      ),
      // Try to scroll the content and see if it works
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height/1.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.red
                )
            )
        ),
      ),
    );

  }
}


/*

if(marked == true){
                //add user to post bookmark list
                databaseMethods.updateAddPostBookmarkInfo(widget.mainCat, widget.subCat, widget.postTitleName, Constants.myUID).then((){
                  // Positive feedback
                  CustomSnackBar.buildPositiveSnackbar(context, "Post Bookmarked!");
                });
              }
              else{
                // remove user from post bookmarklist
                databaseMethods.updateRemovePostBookmarkInfo(widget.mainCat, widget.subCat, widget.postTitleName, Constants.myUID).then((){
                  CustomSnackBar.buildPositiveSnackbar(context, "Post Unbookmarked!");
                  // please check that this does work
                });
              }
 */
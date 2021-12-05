// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'tips_postlists.dart';
import '../../constants.dart';

class TipsHomePage extends StatefulWidget {
  const TipsHomePage({Key key}) : super(key: key);

  @override
  _TipsHomePageState createState() => _TipsHomePageState();
}


// ORDER the category list in alphabaetial order
// filter search according to post type

class _TipsHomePageState extends State<TipsHomePage> {
  FirebaseApi databaseMethods = new FirebaseApi();
  Stream tipsCategories;
  String mainCategory = "Tips";

  @override
  void initState(){
    databaseMethods.getTipsCategories().then((val){
      setState(() {
        tipsCategories = val;
      });
    });
      super.initState();
  }

  // Retrieves and display the list of tips
  Widget TipsCatist(){
    return StreamBuilder(
      stream: tipsCategories,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          itemBuilder: (context, index){
            return TipsTiles(mainCategory: mainCategory, subCateogry: (snapshot.data as QuerySnapshot).docs[index]["name"]);
          },
        ) : Container();
      },
    );

  }

  // Tips Main Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
          title: Text("Tips", style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
          centerTitle: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                //top: Radius.circular(30),
                  bottom: Radius.circular(30)
              )
          ),
          actions: [IconButton(onPressed: (){}, icon: Icon(Icons.search_rounded, ))],
        ),
      body: TipsCatist()
    );
  }
}


// Design tiles for Tips
class TipsTiles extends StatelessWidget {
  final String subCateogry;
  final String mainCategory;
  TipsTiles({ this.mainCategory, this.subCateogry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => PostLists(mCategory: this.mainCategory, sCategory: this.subCateogry,)));
          },
          child: Container(
            height: MediaQuery.of(context).size.height/8,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black,
                width: 2
              )
            ),
              child:  Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/8,
                    //color: Colors.red,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                        bottomLeft:  Radius.circular(18)),
                      color: Colors.blue
                    ),
                    child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(this.subCateogry, style: TextStyle(fontSize: 50), overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
              //child: ListTile(
              //  title: Text(this.subCateogry, style: TextStyle(fontSize: 30))
             // ),

          ),
        ),
      ],
    );
  }
}


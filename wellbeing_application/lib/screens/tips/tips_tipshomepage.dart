// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'tips_postlists.dart';

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
  String mainCategory = "Tip";

  @override
  void initState(){
    databaseMethods.getTipsCategories().then((val){
      setState(() {
        tipsCategories = val;
      });
    });
      super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tips"),
        centerTitle: true,
      ),
      body: TipsCatist()
    );
  }
}



class TipsTiles extends StatelessWidget {
  final String subCateogry;
  final String mainCategory;
  TipsTiles({ this.mainCategory, this.subCateogry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PostLists(mCategory: this.mainCategory, sCategory: this.subCateogry,)));
      },
      child: Container(
        height: MediaQuery.of(context).size.height/8,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Card(
          elevation: 5,
          child: ListTile(
            title: Text(this.subCateogry)
          ),
        ),
      ),
    );
  }
}


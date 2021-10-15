// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';

class ToolsHomePage extends StatefulWidget {
  const ToolsHomePage({Key key}) : super(key: key);

  @override
  _ToolsHomePageState createState() => _ToolsHomePageState();
}


class _ToolsHomePageState extends State<ToolsHomePage> {
  FirebaseApi databaseMethods = new FirebaseApi();
  Stream toolsCategories;

  @override
  void initState(){
    databaseMethods.getToolsCategories().then((val){
      setState(() {
        toolsCategories = val;
      });
    });
    super.initState();
  }

  Widget ToolsCatList(){
    return StreamBuilder(
      stream: toolsCategories,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          itemBuilder: (context, index){
            return ToolTiles(title: (snapshot.data as QuerySnapshot).docs[index]["name"]);
          },
        ) : Container();
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Tools"),
        centerTitle: true,
      ),
      body: ToolsCatList()
    );
  }
}


class ToolTiles extends StatelessWidget {
  final String title;
  ToolTiles({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/8,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        elevation: 5,
        child: ListTile(
            title: Text(this.title)
        ),
      ),
    );
  }
}

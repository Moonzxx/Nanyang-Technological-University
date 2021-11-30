// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../constants.dart';
import 'helpline_clinicsInfo.dart';

class ExternalHelplinePage extends StatefulWidget {
  const ExternalHelplinePage({Key key}) : super(key: key);

  @override
  _ExternalHelplinePageState createState() => _ExternalHelplinePageState();
}

class _ExternalHelplinePageState extends State<ExternalHelplinePage> {
  FirebaseApi databaseMethods = new FirebaseApi();
  Stream cAroundSG;


  @override
  void initState(){
    databaseMethods.getAroundSG().then((val){
      setState(() {
        cAroundSG = val;
        print(Colors.blue[700].value);
      });
    });
    super.initState();
  }

  Widget getCounsellorsAroundSg(){
    return StreamBuilder(
      stream: cAroundSG,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          itemBuilder: (context, index){
            return AroundSGTiles(areaTitle: (snapshot.data as QuerySnapshot).docs[index]["name"],
                colour: (snapshot.data as QuerySnapshot).docs[index]["colour"]);
          },
        ) : Container();
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
          title: Text("Around SG", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
          centerTitle: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                //top: Radius.circular(30),
                  bottom: Radius.circular(30)
              )
          ),
        ),
      body: getCounsellorsAroundSg()
    );
  }
}


class AroundSGTiles extends StatelessWidget {
  final String areaTitle;
  final int colour;
  AroundSGTiles({ this.areaTitle,  this.colour});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ClinicsInfo(sgContinent: areaTitle,)));
      },
      child: Container(
        child: Card(
          elevation: 5,
          color: Color(this.colour).withOpacity(1),
          child: ListTile(
            title: Text(this.areaTitle),

          ),
        ),
      ),
    );
  }
}

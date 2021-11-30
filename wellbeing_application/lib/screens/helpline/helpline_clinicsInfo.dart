// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../constants.dart';
import 'helpline_viewClinicInfo.dart';

class ClinicsInfo extends StatefulWidget {
  final String sgContinent;
  ClinicsInfo({this.sgContinent});

  @override
  _ClinicsInfoState createState() => _ClinicsInfoState();
}

// Display Clinic Information on the page
class _ClinicsInfoState extends State<ClinicsInfo> {

  FirebaseApi databaseMethods = new FirebaseApi();
  Stream SGContinentClinicList;

  @override
  void initState(){
    getSGContinentClinics();
    super.initState();
  }

  getSGContinentClinics(){
    databaseMethods.getSGClinicLines(widget.sgContinent).then((val){
      setState(() {
        SGContinentClinicList = val;
      });
    });
  }

  Widget SGContinentClinicsList(){
    return StreamBuilder(
      stream: SGContinentClinicList,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          itemBuilder: (context, index){
            return ClinicTile(
              clinicName: (snapshot.data as QuerySnapshot).docs[index]["clinicName"],
                clinicAddr: (snapshot.data as QuerySnapshot).docs[index]["address"],
                clinicFee: (snapshot.data as QuerySnapshot).docs[index]["fee"],
                clinicTel: (snapshot.data as QuerySnapshot).docs[index]["tel"]);
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
        title: Text( widget.sgContinent, style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
      body: SGContinentClinicsList()
    );
  }
}


class ClinicTile extends StatelessWidget {
  final String clinicName;
  final String clinicAddr;
  final int clinicTel;
  final int clinicFee;
  ClinicTile({this.clinicName, this.clinicAddr, this.clinicTel, this.clinicFee});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            ViewClinicInfo(viewClinicName: clinicName , viewClinicAddr: clinicAddr , viewClinicTel: clinicTel , viewClinicFee: clinicFee,)));
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
                  color: Colors.red
              ),
              child: Icon(Icons.cake_rounded, color: Colors.white,),  // change to clinic logo
            ),
            SizedBox(width: 30),
            Column(
              children: [
                Text(clinicName),
                Text(clinicAddr),
                Text(clinicTel.toString()),
                Text(clinicFee.toString())
              ],
            ),

          ],
        ),

      ),
    );
  }
}


/*
Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(this.subCateogry, style: TextStyle(fontSize: 50), overflow: TextOverflow.ellipsis),
              ),
            ),
 */
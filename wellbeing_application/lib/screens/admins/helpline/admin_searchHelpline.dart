// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';
import 'admin_editHelpline.dart';
import '../../../widgets/custom_AlertBox.dart';

class searchSGClinic extends StatefulWidget {
  const searchSGClinic({Key key}) : super(key: key);

  @override
  _searchSGClinicState createState() => _searchSGClinicState();
}

class _searchSGClinicState extends State<searchSGClinic> {

  FirebaseApi databaseMethods = new FirebaseApi();
  Stream sgRegionClinics;

  String selectedRegionDropDownMenu = "Central";
  List<String> sgRegions = ["Central", "East", "North", "North-East", "West"];

  @override
  void initState(){
    useSearch(selectedRegionDropDownMenu);
    super.initState();
  }

  useSearch(String sgRegion){
    databaseMethods.getSGClinicLines(sgRegion).then((val){
      setState(() {
        sgRegionClinics = val;
      });
    });

  }

  Widget SGRegionClinicList(){
    return StreamBuilder(
      stream : sgRegionClinics,
      builder: (context, snapshot){
        return (snapshot.hasData) ? ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return SgClinicNameTiles(
              sgRegionClinicName: (snapshot.data as QuerySnapshot).docs[index]["clinicName"],
              sgRegionClinicAddr: (snapshot.data as QuerySnapshot).docs[index]["address"],
              sgRegionClinicTel: (snapshot.data as QuerySnapshot).docs[index]["tel"],
              sgRegionClinicFee: (snapshot.data as QuerySnapshot).docs[index]["fee"],
              sgRegionSelected: selectedRegionDropDownMenu,
            );
          },

        ) : Container();
      }
    );
  }

  //searchSnapshot.docs[index]["username"]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text("Search Clinics", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
        actions: [IconButton(onPressed: (){
          //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
        }, icon: Icon(Icons.search_rounded, color: Colors.white ))],
      ),
      body: Column(
        children: [
          DropdownButton(
              value: selectedRegionDropDownMenu,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 20,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                  height: 2,
                  color: Colors.black),
              onChanged: (String newValue){
                setState(() {
                  selectedRegionDropDownMenu = newValue;
                  useSearch(selectedRegionDropDownMenu);
                });
              },
              items:  sgRegions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList()
          ),
        SizedBox(height: 20),
          //Expanded(
          //  child: SingleChildScrollView(
            //  child: SGRegionClinicList(),
           // ),
         // ),
          Expanded(child: SGRegionClinicList()),
        ],
      )
    );
  }
}

class SgClinicNameTiles extends StatelessWidget {
  final String sgRegionClinicName;
  final String sgRegionClinicAddr;
  final int sgRegionClinicTel;
  final int sgRegionClinicFee;
  final String sgRegionSelected;
  SgClinicNameTiles({this.sgRegionClinicName, this.sgRegionClinicAddr, this.sgRegionClinicFee, this.sgRegionClinicTel, this.sgRegionSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.play_arrow_rounded),
      title: Text(sgRegionClinicName),
      trailing: Row(
        children: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
            EditSgClinicInfo(
              sgClinicName: sgRegionClinicName,
              sgClinicAddr: sgRegionClinicAddr,
              sgClinicTel: sgRegionClinicTel,
              sgClinicFee: sgRegionClinicFee,
              sgSelectedRegion: sgRegionSelected,
            )));
            //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
          }, icon: Icon(Icons.edit, color: Colors.white )),
          SizedBox(width: 10),
          IconButton(onPressed: (){
              CustomAlertBox.deleteSGClinicInfo(context, "Delete Clinic?", sgRegionSelected, sgRegionClinicName);
            //Navigator.push(context, MaterialPageRoute(builder: (context) => EditDiaryEntry(diaryEntryName: widget.diaryName, editDiaryContent: widget.diaryContent, editDiaryMood:  widget.diaryMood)));
          }, icon: Icon(Icons.delete, color: Colors.white ))

        ],
      ),
    );
  }
}


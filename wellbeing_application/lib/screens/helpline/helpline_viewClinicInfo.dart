// @dart=2.10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../constants.dart';
import 'helpline_addRemarks.dart';

class ViewClinicInfo extends StatefulWidget {
  final String viewClinicName;
  final String viewClinicAddr;
  final int viewClinicTel;
  final int viewClinicFee;
  final String viewClinicRegion;
  ViewClinicInfo({ this.viewClinicName, this.viewClinicAddr, this.viewClinicTel, this.viewClinicFee, this.viewClinicRegion});

  @override
  _ViewClinicInfoState createState() => _ViewClinicInfoState();
}


class _ViewClinicInfoState extends State<ViewClinicInfo> {

  FirebaseApi databaseMethods = new FirebaseApi();
  Stream clinicUserRemarks;
  int starRating = 0;

  @override
  void initState(){
    calculateAverageRate(widget.viewClinicRegion, widget.viewClinicName);
    getClinicRemarks(widget.viewClinicRegion, widget.viewClinicName);
    super.initState();
  }

  calculateAverageRate(String region, String clinic) async{
    QuerySnapshot coll = await FirebaseFirestore.instance.collection("helplines").doc("external").collection("aroundSG").doc(region).collection("clinics").doc(clinic).collection("remarks").get();
    List<DocumentSnapshot> collDocs = coll.docs;

    List<int> ratings = [0,1,2,3,4,5];
    List<int> allRatings = [];
    int averageRating = 0;
    for(var i = 0; i < collDocs.length; i++){
      allRatings.add(collDocs[i]["rate"]);
    }

    int mostPopular = 0;
    for(var a = 0; a < ratings.length; a++){
      int checker = 0;
      for(var b = 0; b < allRatings.length; b++){
        if(ratings[a] == allRatings[b]){
          checker++;
        }
        if(checker >= mostPopular){
          mostPopular = checker;
        }
      }
    }

    setState(() {
      starRating = mostPopular;
    });
  }

  getClinicRemarks( String region, String clinic){
    databaseMethods.getClinicRemarks( region, clinic).then((val){
      setState(() {
        clinicUserRemarks = val;
      });
    });
  }

  Widget displayClinicRemarsList(){
    return StreamBuilder(
      stream: clinicUserRemarks,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          itemBuilder: (context, index){
            return userRemarkInfoTile(
              user: (snapshot.data as QuerySnapshot).docs[index]["user"],
              comment: (snapshot.data as QuerySnapshot).docs[index]["comment"],
              rate: (snapshot.data as QuerySnapshot).docs[index]["rate"],
                );
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
        title: Text( widget.viewClinicName, style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
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
            Container(
              height: MediaQuery.of(context).size.height /9,
              width: MediaQuery.of(context).size.width,
              color: Colors.indigo, // replace with image
            ),
            SizedBox(height: 10),
            Text(widget.viewClinicName),
            Text(widget.viewClinicAddr),
            Text(widget.viewClinicTel.toString()),
            Text(widget.viewClinicFee.toString()),
            SizedBox(height: 20),
            Text("Reviews"),
            Text(this.starRating.toString())
            // Display Lis tof reviews
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddHelplineRemark(
              sgRegion: widget.viewClinicRegion,
              clinicName: widget.viewClinicName,
            )));
          }, //make sure of bool to make it null,
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}


class userRemarkInfoTile extends StatelessWidget {
  final String user;
  final String comment;
  final int rate;
  userRemarkInfoTile({this.user, this.comment, this.rate});

  @override
  Widget build(BuildContext context) {
    Container(
      height: MediaQuery.of(context).size.height/8,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.black,
              width: 2
          )
      ),
      child:  Column(
        children: [
          Row(
            children: [
              Text(this.user),
              Spacer(),
              Text(this.rate.toString() + " / 5")
            ],
          ),
          SizedBox(height: 10),
          Text(this.comment)
        ],
      ),

    );
  }
}

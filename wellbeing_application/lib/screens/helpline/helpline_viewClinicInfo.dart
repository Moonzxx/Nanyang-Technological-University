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
  final String viewClinicDesc;
  ViewClinicInfo({ this.viewClinicName, this.viewClinicAddr, this.viewClinicTel, this.viewClinicFee, this.viewClinicRegion, this.viewClinicDesc});

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
          mostPopular = ratings[a];
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

  Widget displayClinicRemarksList(){
    return StreamBuilder(
      stream: clinicUserRemarks,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          shrinkWrap: true,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width/1.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                        color: Constants.secondaryColour,
                        width: 2
                    )
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, fontFamily: systemHeaderFontFamiy, decoration: TextDecoration.underline)),
                    Text(":")
                  ],
                ),

              ),
              SizedBox(height: 5),
              Text(widget.viewClinicDesc, style: TextStyle()),
              SizedBox(height: 10),
              //Text(widget.viewClinicName),
              Container(
                width: MediaQuery.of(context).size.width/1.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                        color: Constants.secondaryColour,
                        width: 2
                    )
                ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, fontFamily: systemHeaderFontFamiy, decoration: TextDecoration.underline)),
                      Text(":")
                    ],
                  ),

              ),
              SizedBox(height: 5),
              Text(widget.viewClinicAddr, style: TextStyle()),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width/1.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                        color: Constants.secondaryColour,
                        width: 2
                    )
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Telephone", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, fontFamily: systemHeaderFontFamiy, decoration: TextDecoration.underline)),
                    Text(":")
                  ],
                ),

              ),
              SizedBox(height: 5),
              Text(widget.viewClinicTel.toString()),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width/1.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                        color: Constants.secondaryColour,
                        width: 2
                    )
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Fee", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, fontFamily: systemHeaderFontFamiy, decoration: TextDecoration.underline)),
                    Text(":")
                  ],
                ),

              ),
              Text("\$ " + widget.viewClinicFee.toString()),
              SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                  children: [
                    Text("Reviews", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, fontFamily: systemHeaderFontFamiy, decoration: TextDecoration.underline)),
                    Text(": "),
                    Text(this.starRating.toString(), style: TextStyle(fontSize: 25, fontFamily: systemHeaderFontFamiy,)),
                    Text(" / 5")
                  ],
                ),],
              ),
              SizedBox(height: 10),

              displayClinicRemarksList()
              // Display Lis tof reviews
            ],
          ),
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: MediaQuery.of(context).size.height/9,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: Constants.secondaryColour,
                width: 2
            )
        ),
        child:  Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(this.user, style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, fontSize: 20),),
                  Spacer(),
                  Row(
                    children: [
                      Text(this.rate.toString(), style: TextStyle(fontFamily: systemHeaderFontFamiy, fontWeight: FontWeight.bold, fontSize: 20)),
                      Text( " / 5")
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
              Text(this.comment)
            ],
          ),
        ),

      ),
    );
  }
}

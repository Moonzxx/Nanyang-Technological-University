// @dart=2.10
import 'package:flutter/material.dart';
import '../../constants.dart';

class ViewClinicInfo extends StatefulWidget {
  final String viewClinicName;
  final String viewClinicAddr;
  final int viewClinicTel;
  final int viewClinicFee;
  ViewClinicInfo({ this.viewClinicName, this.viewClinicAddr, this.viewClinicTel, this.viewClinicFee});

  @override
  _ViewClinicInfoState createState() => _ViewClinicInfoState();
}

class _ViewClinicInfoState extends State<ViewClinicInfo> {
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
            // Display Lis tof reviews
          ],
        ),
      )
    );
  }
}

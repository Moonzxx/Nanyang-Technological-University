// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';
import '../../../widgets/custom_AlertBox.dart';
import '../../../widgets/custom_snackbar.dart';

class EditSgClinicInfo extends StatefulWidget {
  final String sgClinicName;
  final String sgClinicAddr;
  final int sgClinicTel;
  final int sgClinicFee;
  final String sgSelectedRegion;
  EditSgClinicInfo({this.sgClinicName, this.sgClinicAddr, this.sgClinicTel, this.sgClinicFee, this.sgSelectedRegion});

  @override
  _EditSgClinicInfoState createState() => _EditSgClinicInfoState();
}

class _EditSgClinicInfoState extends State<EditSgClinicInfo> {

  final _editHelplineFormKey = GlobalKey<FormState>();
  FirebaseApi databaseMethods = new FirebaseApi();

  TextEditingController EditSGClinicName = new TextEditingController();
  TextEditingController EditSGClinicAddr = new TextEditingController();
  TextEditingController EditSGClinicTel = new TextEditingController();
  TextEditingController EditSGClinicFee = new TextEditingController();

  String savedSGClinicName;
  String savedSClinicAddr;
  int savedSGClinicTel;
  int savedSGClinicFee;

  String validateClinicName(String value){

    RegExp clinicName = new RegExp(r'^[a-zA-Z0-9 ]*$');
    if (!clinicName.hasMatch(value)){
      return 'Name must contain only alphabets and/or numbers';
    }
    else{
      return null;
    }
  }


  //^[a-zA-Z0-9 #-_()]*$
  String validateClinicAddr(String value){

    RegExp clinicAddr = new RegExp(r'^[a-zA-Z0-9 #-_()]*$');
    if (!clinicAddr.hasMatch(value)){
      return 'Name must contain only alphabets and/or numbers';
    }
    else{
      return null;
    }
  }

  String validateClinicTel(String value){

    RegExp clinicTel = new RegExp(r'^[0-9+]*$');
    if (!clinicTel.hasMatch(value)){
      return 'Tel must contain only numbers';
    }
    else{
      return null;
    }
  }

  String validateClinicFee(String value){

    RegExp clinicFee = new RegExp(r'^[0-9]*$');
    if (!clinicFee.hasMatch(value)){
      return 'Fee must contain only numbers';
    }
    else{
      return null;
    }
  }

  @override
  void initState(){
    setState(() {
      EditSGClinicName.text = widget.sgClinicName;
      EditSGClinicAddr.text = widget.sgClinicAddr;
      EditSGClinicTel.text = widget.sgClinicTel.toString();
      EditSGClinicFee.text = widget.sgClinicFee.toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editing " + widget.sgClinicName),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _editHelplineFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: EditSGClinicName,
                decoration: inputDecoration("Clinic Name:"
                ),
                maxLength: 50,
                // accept alphabet, number and spaces
                validator: validateClinicName,
                onSaved: (value){
                  setState(() {
                    savedSGClinicName = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: EditSGClinicAddr,
                decoration: inputDecoration("Clinic Addr:"
                ),
                maxLength: 150,
                // accept alphabet, number and spaces
                validator: validateClinicAddr,
                onSaved: (value){
                  setState(() {
                    savedSClinicAddr = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: EditSGClinicTel,
                decoration: inputDecoration("Clinic Tel:"
                ),
                maxLength: 20,
                // accept alphabet, number and spaces
                validator: validateClinicTel,
                onSaved: (value){
                  setState(() {
                    savedSGClinicTel = int.parse(value);
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: EditSGClinicFee,
                decoration: inputDecoration("Clinic Fee:"
                ),
                maxLength: 4,
                // accept alphabet, number and spaces
                validator: validateClinicFee,
                onSaved: (value){
                  setState(() {
                    savedSGClinicFee = int.parse(value);
                  });
                },
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: EdgeInsets.all(10),
                      height: 50.0,
                      child: ElevatedButton(
                          onPressed: (){

                            final valid = _editHelplineFormKey.currentState.validate();
                            if(valid){
                              _editHelplineFormKey.currentState.save();
                              // information is a map of items
                              Map<String, dynamic> updatedClinicInformation = {
                                "clinicName" : savedSGClinicName,
                                "address": savedSClinicAddr,
                                "tel": savedSGClinicTel,
                                "fee": savedSGClinicFee
                              };

                              databaseMethods.updateSGClinicInfo(widget.sgSelectedRegion, widget.sgClinicName, updatedClinicInformation);
                              Navigator.pop(context);
                              // cusotm or alert
                              CustomSnackBar.buildPositiveSnackbar(context, "SG Clinic Created");


                            }


                          } ,
                          style: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20), primary: Colors.green , elevation: 5, ),
                          child: Text('Create'))
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

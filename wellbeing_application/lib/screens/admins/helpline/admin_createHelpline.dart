// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../../constants.dart';
import '../../../widgets/custom_snackbar.dart';

class createaHelplineInfo extends StatefulWidget {
  const createaHelplineInfo({Key key}) : super(key: key);

  @override
  _createaHelplineInfoState createState() => _createaHelplineInfoState();
}

class _createaHelplineInfoState extends State<createaHelplineInfo> {

  final _createHelplineFormKey = GlobalKey<FormState>();
  FirebaseApi databaseMethods = new FirebaseApi();
  TextEditingController clinicNameController = new TextEditingController();
  TextEditingController clinicAddressController = new TextEditingController();
  TextEditingController clinicTelController = new TextEditingController();
  TextEditingController clinicFeeController = new TextEditingController();

  String savedClinicName;
  String savedClinicAddr;
  int savedClinicTel;
  int savedClinicFee;

  String selectedRegionDropDownMenu = "Central";
  List<String> sgRegions = ["Central", "East", "North", "North-East", "West"];

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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Adding new Diary Entry"),
        ),
      body: SingleChildScrollView(
        child: Form(
          key: _createHelplineFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Region:'),
                  SizedBox(width: 15,),
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
                        });
                      },
                      items:  sgRegions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList()),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: clinicNameController,
                decoration: inputDecoration("Clinic Name:"
                ),
                maxLength: 50,
                // accept alphabet, number and spaces
                validator: validateClinicName,
                onSaved: (value){
                  setState(() {
                    savedClinicName = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: clinicAddressController,
                decoration: inputDecoration("Clinic Address:"
                ),
                maxLength: 150,
                // Accept int, spaces,letters, hashtag, and dashes
                validator: validateClinicAddr,
                onSaved: (value){
                  setState(() {
                    savedClinicAddr = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: clinicTelController,
                decoration: inputDecoration("Clinic Tel:"
                ),
                maxLength: 20,
                // only accept int
                validator: validateClinicTel,
                onSaved: (value){
                  setState(() {
                    savedClinicTel = int.parse(value);
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: clinicFeeController,
                decoration: inputDecoration("Clinic Fee \$(SGD):"
                ),
                maxLength: 4,
                // only accept int
                validator: validateClinicFee,
                onSaved: (value){
                  setState(() {
                    savedClinicFee = int.parse(value);
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: EdgeInsets.all(10),
                      height: 50.0,
                      child: ElevatedButton(
                          onPressed: (){

                            final valid = _createHelplineFormKey.currentState.validate();
                            if(valid){
                              _createHelplineFormKey.currentState.save();
                              // information is a map of items
                              Map<String, dynamic> clinicInformation = {
                                "clinicName" : savedClinicName,
                                "address": savedClinicAddr,
                                "tel": savedClinicTel,
                                "fee": savedClinicFee
                              };

                              databaseMethods.createSGClinic(selectedRegionDropDownMenu, savedClinicName , clinicInformation);
                              Navigator.pop(context);
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

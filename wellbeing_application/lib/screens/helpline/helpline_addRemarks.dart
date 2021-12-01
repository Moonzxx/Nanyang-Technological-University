// @dart=2.10
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:wellbeing_application/widgets/custom_AlertBox.dart';
import '../../constants.dart';

class AddHelplineRemark extends StatefulWidget {
  final String sgRegion;
  final String clinicName;
  AddHelplineRemark({this.sgRegion, this.clinicName});

  @override
  _AddHelplineRemarkState createState() => _AddHelplineRemarkState();
}

class _AddHelplineRemarkState extends State<AddHelplineRemark> {

  final _addRemarksFormKey = GlobalKey<FormState>();
  FirebaseApi databaseMethods = new FirebaseApi();
  TextEditingController remarkUserController = new TextEditingController();

  String selectedRating = "0";
  List<String> ratingOptions = ["0", "1", "2", "3", "4", "5"];

  String savedUserComment;
  int savedUserRate;

  @override
  void initState(){
    super.initState();
  }

  String validateDesc(String value){

    RegExp nameDesc = new RegExp(r'^[a-zA-Z0-9 ]*$');
    if (!nameDesc.hasMatch(value)){
      return 'Name must contain only alphabets';
    }
    else{
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adding remark"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addRemarksFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: remarkUserController,
                decoration: inputDecoration("Comment:"
                ),
                maxLength: 50,
                // accept alphabet, number and spaces
                validator: validateDesc,
                onSaved: (value){
                  setState(() {
                    savedUserComment = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Rating:'),
                  SizedBox(width: 15,),
                  DropdownButton(
                      value: selectedRating,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 20,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                          height: 2,
                          color: Colors.black),
                      onChanged: (String newValue){
                        setState(() {
                          selectedRating = newValue;
                          savedUserRate = int.parse(selectedRating);
                        });
                      },
                      items:  ratingOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList()),
                  Text(" / 5")
                ],

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

                            final valid = _addRemarksFormKey.currentState.validate();
                            if(valid){
                              _addRemarksFormKey.currentState.save();
                              // information is a map of items
                              Map<String, dynamic> userRemarkInfo = {
                                "user" : Constants.myName,
                                "userID": Constants.myUID,
                                "comment": savedUserComment,
                                "rate": savedUserRate,
                              };

                              CustomAlertBox.addRemarkConfirmation(context, "Post Remark?", widget.sgRegion, widget.clinicName, userRemarkInfo);
                              //databaseMethods.createSGClinic(selectedRegionDropDownMenu, savedClinicName , clinicInformation);
                              Navigator.pop(context);
                             // CustomSnackBar.buildPositiveSnackbar(context, "SG Clinic Created");


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

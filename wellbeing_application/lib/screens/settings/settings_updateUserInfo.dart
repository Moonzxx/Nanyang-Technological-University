// @dart=2.10



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import '../../constants.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '../../widgets/custom_AlertBox.dart';
import '../../widgets/custom_snackbar.dart';

/*

      Update User Information:
      - Cannot edit email: Email is like an UID

 */

class UpdateUserDetails extends StatefulWidget {
  const UpdateUserDetails({Key key}) : super(key: key);

  @override
  _UpdateUserDetailsState createState() => _UpdateUserDetailsState();
}

class _UpdateUserDetailsState extends State<UpdateUserDetails> {
  final _changeFormKey = GlobalKey<FormState>();
  FirebaseApi databaseMethods = new FirebaseApi();
  TextEditingController editUserName = new TextEditingController();
  TextEditingController editFirstName = new TextEditingController();
  TextEditingController editLastName = new TextEditingController();
  DocumentSnapshot UserInformation;

  getUserProfileDetails(String UID){
    databaseMethods.getUserInformation(UID).then((val){
      setState(() {
        UserInformation = val;
      });
      editFirstName.text = UserInformation["first_name"];
      editLastName.text = UserInformation["last_name"];
      editUserName.text = UserInformation["username"];

 });

  }

  @override
  void initState(){
    getUserProfileDetails(Constants.myUID);
    super.initState();
  }

  String userFirstName = "";
  String userLastName = "";
  String userName = "";
  bool dpChanged = false;

  Uint8List bytes;
  File _image;
  String chosenImageName;

  Future selectFile() async {
    // Only allow to select one file
    final result = await FilePicker.platform.pickFiles(allowMultiple:  false);

    if(result == null) return;
    final path = result.files.single.path;

    setState(() async {
      _image = File(path);
      chosenImageName = basename(_image.path);
      await _image.readAsBytes().then((value) {
        // bytes = Uint8List.fromList(value);
        setState(() {
          bytes = Uint8List.fromList(value);
          dpChanged = true;
        });


        print('Reading of bytes ic completed');
      }).catchError((onError){
        print('Exception Error while reading audio from path: ' + onError.toString());
      });
    });
  }

  String validateName(String value){

    RegExp nameregex = new RegExp(r'^[a-zA-Z]*$');
    if (!nameregex.hasMatch(value)){
      return 'Name must contain only alphabets';
    }
    else{
      return null;
    }
  }

  String validateUsername(String value){
    RegExp nameregex = new RegExp(r'[a-zA-z0-9]');
    if (!nameregex.hasMatch(value)){
      return 'Username can only be alphanumeric';
    }
    else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Update User Information:"),
              backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _changeFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: (){
                  selectFile();
                },
                child: Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: (bytes != null) ? Image.memory(bytes,fit: BoxFit.fill).image : NetworkImage(Constants.myAvatar), fit: BoxFit.fill),
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, style: BorderStyle.solid, width : 1.0),
                  ),

                ),
              ),
            SizedBox(height: 15),
              TextFormField(
                  controller: editFirstName,
                  decoration: inputDecoration("First Name"
                  ),
                  maxLength: 20,
                  validator: validateName,
                  onSaved: (value){
                    setState(() {
                      userFirstName = value;
                    });
                  },
                ),
              TextFormField(
                controller: editLastName,
                decoration: inputDecoration("Last Name"
                ),
                maxLength: 20,
                validator: validateName,
                onSaved: (value){
                  setState(() {
                    userLastName = value;
                  });
                },
              ),
              TextFormField(
                controller: editUserName,
                decoration: inputDecoration("Username"
                ),
                maxLength: 20,
                validator: validateUsername,
                onSaved: (value){
                  setState(() {
                    userName = value;
                  });
                },
              ),
          ElevatedButton(onPressed: (){
            final isValid = _changeFormKey.currentState.validate();

            if(isValid){
              _changeFormKey.currentState.save();
             // updateUserDetails();

              // How to check if picture is stil the same, bytes could be empty
              if(dpChanged == false){
                print("it reaches here");
                //CustomAlertBox.updateProfileAlertBox1(context, "Confirm save changes?", Constants.myUID, userName, userFirstName, userLastName);

                databaseMethods.saveUserDetails(Constants.myUID, this.userName, userFirstName, userLastName);
                Navigator.pop(context);
                CustomSnackBar.buildPositiveSnackbar(context, "User Profile Updated");//Navigator.pop(context);
                //CustomAlertBox.updateProfileAlertBox2(context, "Confirm save changes?", Constants.myUID, userName, userFirstName, userLastName, bytes);
               // Navigator.pop(context);
                //databaseMethods.saveUserDetails(Constants.myUID, userName, userFirstName, userLastName);
              //  Navigator.pop(context);
               // CustomSnackBar.buildPositiveSnackbar(context, "User Profile Updated");
              }
              else{
                // it ecesutwe ehre
                //databaseMethods.saveUserDetails(Constants.myUID, userName, userFirstName, userLastName);
                CustomAlertBox.updateProfileAlertBox2(context, "Confirm save changes?", Constants.myUID, userName, userFirstName, userLastName, bytes);
                Navigator.pop(context);
                //CustomSnackBar.buildPositiveSnackbar(context, "User Profile Updated");
                //
              }


            }
          },
              style: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20), primary: Colors.green , elevation: 5, ),
              child: Text('Save Changes'))
            ],
          ),
        ),
      )
    );
  }
}

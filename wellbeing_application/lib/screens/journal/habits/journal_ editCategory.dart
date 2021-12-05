// @dart=2.10
import 'package:flutter/material.dart';
import 'package:wellbeing_application/utils/firebase_api.dart';
import 'package:wellbeing_application/constants.dart';
import '../../../widgets/custom_snackbar.dart';

class EditCategory extends StatefulWidget {
  final String selectedCat;
  EditCategory({this.selectedCat});

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {

  @override
  void initState(){
    setState(() {
      editCategoryContent.text = widget.selectedCat;
    });
    super.initState();
  }


  // If main category cannot edit

  String validateDesc(String value){

    RegExp nameDesc = new RegExp(r'^[a-zA-Z0-9 ]*$');
    if (!nameDesc.hasMatch(value)){
      return 'Name must contain only alphabets';
    }
    else{
      return null;
    }
  }

  FirebaseApi databaseMethods = new FirebaseApi();
  final _editCategoryFormKey = GlobalKey<FormState>();
  String savedCategoryContent;
  TextEditingController editCategoryContent = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Category",  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: systemHeaderFontFamiy)),
        backgroundColor: Constants.secondaryColour,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _editCategoryFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                  controller: editCategoryContent,
                  decoration: inputDecoration("Category Content"
                  ),
                  maxLength: null, // Like twitter
                  validator: validateDesc,
                  onSaved: (value){
                    setState(() {
                      savedCategoryContent = value;
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

                              final valid = _editCategoryFormKey.currentState.validate();
                              if(valid){
                                _editCategoryFormKey.currentState.save();
                                // information is a map of items
                                //put to database,pop and snacknar
                                databaseMethods.updateJournalCategory(Constants.myUID, widget.selectedCat, savedCategoryContent).then((val){
                                  Navigator.pop(context);
                                  CustomSnackBar.buildPositiveSnackbar(context, "Description Updated!");
                                });
                                //CustomAlertBox.createTipPostAlert(context, "Confirm Post Information?", selectedPostCategory, postName, postInformation);
                              }

                            } ,
                            style: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20), primary: Colors.green , elevation: 5, ),
                            child: Text('Update'))
                    ),
                  ),
                )
              ],

            ),
          ),
        ),
      ),
    );
  }
}

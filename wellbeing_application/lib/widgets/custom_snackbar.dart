// @dart=2.10
import 'package:flutter/material.dart';


// A customised snackbar to ensure re-usability


class CustomSnackBar{

  // Feedback for errors
  static buildErrorSnackbar(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: "Cancel",
            textColor: Colors.white,
            onPressed: (){
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },// Try to make this into an Icon
          ),
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.red,
        ),
    );
  }


  // Feedback for successful attempts
  static buildPositiveSnackbar(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontSize: 10, color: Colors.black),),
        action: SnackBarAction(
          label: "Close",
          textColor: Colors.red,
          onPressed: (){
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },// Try to make this into an Icon
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }




}
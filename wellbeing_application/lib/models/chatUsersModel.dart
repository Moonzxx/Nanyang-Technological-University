// @dart=2.10
import 'package:flutter/material.dart';


// Object will house the user's name, text message, imageURL, and time
class ChatUsers{
  String name;
  String messageText;
  String imageUrl;
  String time;
  ChatUsers({@required this.name, @required this.messageText, @required this.imageUrl, @required this.time});
}
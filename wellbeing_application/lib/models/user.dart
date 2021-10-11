import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'package:meta/meta.dart';


class UserAccnt{
  String UID;
  String firstName;
  String lastName;
  String email;
  String username;
  String avatarURL;
  UserAccnt({required this.UID,required this.firstName,required this.lastName, required this.email, required this.username, required this.avatarURL });


}

class ChatUsers{
  String username;
  String email;
  String avatarURL;
  ChatUsers({required this.username, required this.email, required this.avatarURL});

}


import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/utils.dart';
import '../models/user.dart';

class FirebaseApi{
  static UploadTask? uploadFile(String destination, File file){
    try{
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e){
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data){
    try{
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putData(data);
    } on FirebaseException catch (e){
      return null;
    }
  }

  // Add for deleting images as well


  /*

                            CHAT SYSTEM FUNCTIONS

   */

  // field of the collection from any document
  getUserbyUsername(String username) async{
    return await FirebaseFirestore.instance.collection('users').where("username", isEqualTo: username).get();
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
  }

  getConversationMessages(String chatRoomId) async{
    return await FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).collection("chats").orderBy("time", descending: true).snapshots();
    // Will provide stream of queries
  }


  // returns a list of documents that contain username
  getChatRooms(String userName) async{
    return await FirebaseFirestore.instance.collection("chatrooms").where("users", arrayContains: userName).snapshots();
  }



  /*

                           JOURNAL SYSTEM FUNCTIONS


            When profile creation, create the default habit category for them first.

   */

  // Testing with prof 6 (new profile)
  createDefaultHabitCategories(String userID, String cat, categoryInfoMap){
    FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(cat).set(categoryInfoMap).catchError((e){print(e.toString());});
  }

  getUsersHabitCategories(String userID) async {
    return await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").snapshots();
  }

  setUsersHabitsfromCategory(String userID, String cat, String habit, habitInfoMap){
    FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(cat).collection("routines").doc(habit).set(habitInfoMap).catchError((e){print(e.toString());});
  }

  getUsersHabitsfromCategory(String userID, String category) async{
    return await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category).collection("routines").snapshots();
  }

  // returns all activated routines from user
  getUsersHabitRoutinefromCategory(String userID, String category, String day) async{
    return await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category).collection("routines")
        .where("days", arrayContains: day)
        .where("activated", isEqualTo: true).snapshots();
  }


}
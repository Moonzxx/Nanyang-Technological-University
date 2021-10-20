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

  getUserbyUID(String UID) async{
    return await FirebaseFirestore.instance.collection("users").doc(UID).snapshots();
  }

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

  getUsersNumCategories(String userID) async{
    return await FirebaseFirestore.instance.collection("habits").where("uid", isEqualTo: userID).get();
  }

  getUsersHabitsfromCategory(String userID, String category) async{
    return await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category).collection("routines").snapshots();
  }

  // returns all activated routines from user
  getUsersHabitRoutinefromCategory(String userID, String category, String day) async{
    return await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc("Connect").collection("routines")
        .where("days", arrayContains: "Tue").where("activated", isEqualTo: true).get();
  }

  getUserRoutineInformation(String userID, String category, String day) async{
    return await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category).collection("routines")
        .where("days", arrayContains: day).where("activated", isEqualTo: true).get();
  }

  getUserRoutineCompletionTileCheck(String userID, String category, String rName, String currentDate) async{
    return await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category).collection("routines")
        .where("name", isEqualTo: rName).where("completed", arrayContains: currentDate).get();
  }

  UpdateUserRoutineCompletionTileChecked(String userID, String category, String subCat,  updatedDate) async{
    await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category)
        .collection("routines").doc(subCat).update({"completed" : FieldValue.arrayUnion([updatedDate])});
    await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category)
        .collection("routines").doc(subCat).update({"notCompleted" : FieldValue.arrayRemove([updatedDate])});
  }

  UpdateUserRoutineCompletionTileUnchecked(String userID, String category, String subCat,  updatedDate) async{
    await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category)
        .collection("routines").doc(subCat).update({"completed" : FieldValue.arrayRemove([updatedDate])});
    await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category)
        .collection("routines").doc(subCat).update({"notCompleted" : FieldValue.arrayUnion([updatedDate])});
  }


  /*

          FORUM SYSTEM MANAGEMENT

   */

  setNewForumPost(String category, String docName, newPostMap){
    FirebaseFirestore.instance.collection("forums").doc("categories").collection(category).doc(docName).set(newPostMap).catchError((e){print(e.toString());});
  }

  getCategoryForumPosts(String category) async{
    return await FirebaseFirestore.instance.collection("forums").doc("categories").collection(category).snapshots();
  }

  getDiscussionPost(String category, String postTitle) async{
    return await FirebaseFirestore.instance.collection("forums").doc("categories").collection(category).where("name", isEqualTo: postTitle).snapshots();
  }

  getRepliesPost(String category, String title) async{
    return await FirebaseFirestore.instance.collection("forums").doc("categories").collection("Finance").doc("saving money").collection("replies").snapshots();
  }


  /*

        TIPS SYSTEM MANAGEMENT


   */
  // can check with user habit routine

  getTipsCategories() async{
    return await FirebaseFirestore.instance.collection("tips").doc("Tips").collection("categories").snapshots();
  }

  getToolsCategories() async{
    return await FirebaseFirestore.instance.collection("tips").doc("Tools").collection("categories").snapshots();
  }

  // Imrpoved version
  getTTCategories(String cat) async{
    return await FirebaseFirestore.instance.collection("tips").doc(cat).collection("categories").snapshots();
  }
  
  getTTCatPosts(String mainCat, String subCat) async{
    return await FirebaseFirestore.instance.collection("tips").doc(mainCat).collection("categories").doc(subCat).collection("posts").snapshots();
  }
  



  /*
        HELPLINE SYSYEM MANAGEMENT
  */


  getCounsellorList() async{
    return await FirebaseFirestore.instance.collection("helplines").doc("school").collection("counsellors").snapshots();
  }

  getAroundSG() async{
    return await FirebaseFirestore.instance.collection("helplines").doc("external").collection("aroundSG").snapshots();
  }




  /*

      DIARY ENTRY MANAGEMENT

   */

  getUserDiaryEntries(String userID) async{
    return await FirebaseFirestore.instance.collection("diary").doc(userID).collection("diaryEntries").snapshots();
  }



  /*

        Admin Function Management


   */

    createUser(String userID){
      // FOr this, try creating an account and see what the account has to know what needs to be initiliased and set
    }




}

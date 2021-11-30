import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/utils.dart';
import '../models/user.dart';

/*
  Connects the application to Firebase Database.
  The application is able to CRUD information in the database.
 */


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

  static deleteDp(String destination){
    try{
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.delete();
    } on FirebaseException catch (e){
      return null;
    }
  }

  // Add for deleting images as well





  /*

        SETTINGS SYSTEM MANAGEMENT

   */

  // Setting the app theme colour
  setAppThemeColour(String UID, int colourNum) async {
    final db = FirebaseFirestore.instance.collection("users").doc(UID);
    db.get().then((val) async {
      await db.update({"colour" : colourNum});
    });
  }

  // Saving the user details without the avatar
  saveUserDetails(String UID, String uname, String ufirstname, String ulastname){
    final db = FirebaseFirestore.instance.collection("users").doc(UID);
    db.get().then((val) async {
      await db.update({
        "username" : uname,
        "first_name" : ufirstname,
        "last_name" : ulastname,
      });
    });
  }

  // Saving user details and the avatar
  saveUserDetails2(String UID, String uname, String ufirstname, String ulastname, String urlAvatar){
    final db = FirebaseFirestore.instance.collection("users").doc(UID);
    db.get().then((val) async {
      await db.update({
        "username" : uname,
        "first_name" : ufirstname,
        "last_name" : ulastname,
        "url-avatar" : urlAvatar
      });
    });
  }


  /*

          FEED SYSTEM MANAGEMENT


  */

  // Setting the mood colout of the user
  setUserMoodColour(String UID, int colourNum) async {
    final db = FirebaseFirestore.instance.collection("users").doc(UID);
    db.get().then((val) async {
      await db.update({"mood_colour" : colourNum});
    });
  }


  updateUserCurrentDayWellbeing( String userID, String currentDate, currentDateInformation) async{
    await FirebaseFirestore.instance.collection("users").doc(userID).collection("wellbeing").doc(currentDate).set(currentDateInformation).catchError((e){print(e.toString());});
  }

  //await FirebaseFirestore.instance.collection("users").doc(userID).update({"blocked" : blockedUserInformation});



  /*

                            CHAT SYSTEM FUNCTIONS

   */

  // Getting specific user information
  getUserInformation(String UID) async{
    return await FirebaseFirestore.instance.collection("users").doc(UID).get();
  }

  // Getting all the users information from the database
  getUserbyUID(String UID) async{
    return await FirebaseFirestore.instance.collection("users").doc(UID).snapshots();
  }

  // field of the collection from any document
  getUserbyUsername(String username) async{
    return await FirebaseFirestore.instance.collection('users').where("username", isEqualTo: username).get();
  }

  // Creating a chatroom databse for the conversation
  createChatRoom(String chatRoomId, chatRoomMap){
    FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  // Adding conversation messages to the chatroom databse
  addConversationMessages(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
  }

  // Retriving all the conversation messages from the chatroom database
  getConversationMessages(String chatRoomId) async{
    return await FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).collection("chats").orderBy("time", descending: true).snapshots();
    // Will provide stream of queries
  }


  // Rertieves all conversations started by the user
  getChatRooms(String userName) async{
    return await FirebaseFirestore.instance.collection("chatrooms").where("users", arrayContains: userName).snapshots();
  }

  getUserBlockList( String userID) async{
    return await FirebaseFirestore.instance.collection("users").doc(userID).get();
  }

  updateUserBlock(String userID, blockedUserInformation) async{
    await FirebaseFirestore.instance.collection("users").doc(userID).update({"blocked" : blockedUserInformation});
  }

  

  /*

                           JOURNAL SYSTEM FUNCTIONS


            When profile creation, create the default habit category for them first.

   */

  // Testing with prof 6 (new profile)
  createDefaultHabitCategories(String userID, String cat, categoryInfoMap){
    FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(cat).set(categoryInfoMap).catchError((e){print(e.toString());});
  }

  // Getting the user Habit Categories
  getUsersHabitCategories(String userID) async {
    return await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").snapshots();
  }

  // Setting the user Habit Categories and Routines
  setUsersHabitsfromCategory(String userID, String cat, String habit, habitInfoMap){
    FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(cat).collection("routines").doc(habit).set(habitInfoMap).catchError((e){print(e.toString());});
  }

  // Getting the number of habits from the user
  getUsersNumCategories(String userID) async{
    return await FirebaseFirestore.instance.collection("habits").where("uid", isEqualTo: userID).get();
  }

  getUserCategories(String userID) async{
    return await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").get();
  }

  getUsersHabitsfromCategory(String userID, String category) async{
    return await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category).collection("routines").snapshots();
  }

  // Getting all activated routines from the user
  getUsersHabitRoutinefromCategory(String userID, String category, String day) async{
    return await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc("Connect").collection("routines")
        .where("days", arrayContains: "Tue").where("activated", isEqualTo: true).get();
  }

  // Getting user routine information from that category
  getUserRoutineInformation(String userID, String category, String day) async{
    return await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category).collection("routines")
        .where("days", arrayContains: day).where("activated", isEqualTo: true).get();
  }

  // Check if routine is completed
  getUserRoutineCompletionTileCheck(String userID, String category, String rName, String currentDate) async{
    return await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category).collection("routines")
        .where("name", isEqualTo: rName).where("completed", arrayContains: currentDate).get();
  }

  // Keeps the database updated
  UpdateUserRoutineCompletionTileChecked(String userID, String category, String subCat,  updatedDate) async{
    await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category)
        .collection("routines").doc(subCat).update({"completed" : FieldValue.arrayUnion([updatedDate])});
    await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category)
        .collection("routines").doc(subCat).update({"notCompleted" : FieldValue.arrayRemove([updatedDate])});
  }

  // Keeps the database updated
  UpdateUserRoutineCompletionTileUnchecked(String userID, String category, String subCat,  updatedDate) async{
    await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category)
        .collection("routines").doc(subCat).update({"completed" : FieldValue.arrayRemove([updatedDate])});
    await FirebaseFirestore.instance.collection("habits").doc(userID).collection("categories").doc(category)
        .collection("routines").doc(subCat).update({"notCompleted" : FieldValue.arrayUnion([updatedDate])});
  }


  /*

          FORUM SYSTEM MANAGEMENT

   */

  // Creates a new forum post
  setNewForumPost(String category, String docName, newPostMap){
    FirebaseFirestore.instance.collection("forums").doc(category).collection("posts").doc(docName).set(newPostMap).catchError((e){print(e.toString());});
  }

  // Get Forum Categories
  getCategoryForumPosts(String category) async{
    return await FirebaseFirestore.instance.collection("forums").doc(category).collection("posts").snapshots();
  }


  // Get forum post replies
  // need to make changes here
  getRepliesPost(String category, String title) async{
    return await FirebaseFirestore.instance.collection("forums").doc(category).collection("posts").doc(title).collection("replies").snapshots();
  }

  uploadUserReply(String category, String title, replyInformation) async{
    await FirebaseFirestore.instance.collection("forums").doc(category).collection("posts").doc(title).collection("replies").add(replyInformation).catchError((e){print(e.toString());});
  }

  // Update bookmark information (Add User)
  // check if working
  updateAddForumPostBookmarkInfo(String mainCat, String postTitle, String userID) async{
    await FirebaseFirestore.instance.collection("forums").doc(mainCat).collection("posts").doc(postTitle)
        .update({"bookmarkedBy" : FieldValue.arrayUnion([userID])});
  }

  // Update bookmark information (Remove User)
  // Check if working
  updateRemoveForumPostBookmarkInfo(String mainCat,  String postTitle, String userID) async{
    await FirebaseFirestore.instance.collection("forums").doc(mainCat).collection("posts").doc(postTitle)
        .update({"bookmarkedBy" : FieldValue.arrayRemove([userID])});
  }



  // Get bookmarked Forum by user


  //return top 3 bookmarked post
  //getTop3BookmarkedPosts() async{
  //  return await FirebaseFirestore.instance.collection("forums").doc("categories").collection(category).doc()
 // }

  /*

        TIPS SYSTEM MANAGEMENT


   */
  // can check with user habit routine

  // Getting Tips Categories
  getTipsCategories() async{
    return await FirebaseFirestore.instance.collection("tips").doc("Tips").collection("categories").snapshots();
  }

  // Getting Tools Categories
  getToolsCategories() async{
    return await FirebaseFirestore.instance.collection("tips").doc("Tools").collection("categories").snapshots();
  }

  // Imrpoved version
  getTTCategories(String cat) async{
    return await FirebaseFirestore.instance.collection("tips").doc(cat).collection("categories").snapshots();
  }

  // Check if this is in use. If not delete.
  getTTCatPosts(String mainCat, String subCat) async{
    return await FirebaseFirestore.instance.collection("tips").doc(mainCat).collection("categories").doc(subCat).collection("posts").snapshots();
  }

  // Get Tips/Tools Post information
  getTipPostInformation(String mainCat, String subCat, String postTitle) async{
    return await FirebaseFirestore.instance.collection("tips").doc(mainCat).collection("categories").doc(subCat).collection("posts").where("name", isEqualTo: postTitle).get();
  }


  // Update bookmark information (Add User)
  updateAddPostBookmarkInfo(String mainCat, String subCat, String postTitle, String userID) async{
    await FirebaseFirestore.instance.collection("tips").doc(mainCat).collection("categories").doc(subCat).collection("posts").doc(postTitle)
        .update({"bookmarkedBy" : FieldValue.arrayUnion([userID])});
  }

  // Update bookmark information (Remove User)
  updateRemovePostBookmarkInfo(String mainCat, String subCat, String postTitle, String userID) async{
    await FirebaseFirestore.instance.collection("tips").doc(mainCat).collection("categories").doc(subCat).collection("posts").doc(postTitle)
        .update({"bookmarkedBy" : FieldValue.arrayRemove([userID])});
  }

  // Display Bookmarked Tip/Tool Posts by user
  getBookmarkedTipsToolsbyUser(String mainCat) async{
      // Go through each tips post
    // Find user id in bookmarked
    // add inot a list for tips
  }

  createTipPost( String subCat, String postTitle, tipPostInfo){
    FirebaseFirestore.instance.collection("tips").doc("Tips").collection("categories").doc(subCat).collection("posts").doc(postTitle).set(tipPostInfo).catchError((e){print(e.toString());});
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

  getSGClinicLines(String sgLine) async{
    return await FirebaseFirestore.instance.collection("helplines").doc("external").collection("aroundSG").doc(sgLine).collection("clinics").snapshots();
  }

  createSGClinic(String sgLine, String clinicName, sgClinicInfo) async{
    FirebaseFirestore.instance.collection("helplines").doc("external").collection("aroundSG").doc(sgLine).collection("clinics").doc(clinicName).set(sgClinicInfo).catchError((e){print(e.toString());});
  }

  updateSGClinicInfo(String sgLine, String clinicName ,updatedSGClinicInfo) async{
    return await FirebaseFirestore.instance.collection("helplines").doc("external").collection("aroundSG").doc(sgLine).collection("clinics").doc(clinicName).update(updatedSGClinicInfo);
  }

  deleteSGClinicInfo( String sgLine, String clinicName) async{
    FirebaseFirestore.instance.collection("helplines").doc("external").collection("aroundSG").doc(sgLine).collection("clinics").doc(clinicName).delete();
  }








  /*

      DIARY ENTRY MANAGEMENT

   */

  // Getting user Diary entries
  getUserDiaryEntries(String userID) async{
    return await FirebaseFirestore.instance.collection("diary").doc(userID).collection("diaryEntries").snapshots();
  }

  // Update Diary Entry
  //check if this is working
  updateDiaryEntry(String userID, date) async{
    return await FirebaseFirestore.instance.collection("diary").doc(userID).collection("diaryEntries").where("date", isEqualTo: date);
  }


  // Check if this is working
  createUserDiaryEntry(String userID, String currDate, diaryInfo) async{
    FirebaseFirestore.instance.collection("diary").doc(userID).collection("diaryEntries").doc(currDate).set(diaryInfo).catchError((e){print(e.toString());});
  }

  updateUserDiaryEntry(String userID, String diaryPost, String mood, String content) async{
    return await FirebaseFirestore.instance.collection("diary").doc(userID).collection("diaryEntries").doc(diaryPost).update({"mood": mood, "content": content});
  }


  deleteUserDiaryEntry(String userID, String diaryEntry) async{
    FirebaseFirestore.instance.collection("diary").doc(userID).collection("diaryEntries").doc(diaryEntry).delete();
  }


}

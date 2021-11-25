
import 'package:shared_preferences/shared_preferences.dart';


// Helps to keep track of the user information in the app

class HelperFunctions{
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";   // Check is user is logged in
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";      // Currently logged in username
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";    // Currently logged in user email
  static String sharedPreferenceUserAvatar = "USERAVATARKEY";
  static String sharedPreferenceUserUID = "USERUIDKEY";
  static String sharedPreferenceUserVerified = "USERVERIFIEDKEY";


  // Saving data to SharedPreference

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(
      String userName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPreference(
      String userEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> saveUserAvatarSharedPreference(
      String urlAvatar) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserAvatar, urlAvatar);
  }

  static Future<bool> saveUserUIDSharedPreference(
      String userUID) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserUID, userUID);
  }


  // Getting data from SharedPreferences

  static Future<bool> getUserLoggedInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserNameInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String> getUserAvatarInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserAvatar);
  }

  static Future<String> getUserUIDInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserUID);
  }



}
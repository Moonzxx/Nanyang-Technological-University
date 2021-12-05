import 'package:flutter/material.dart';
import 'package:wellbeing_application/widgets/navigation_drawer_zoom/navigation_widget.dart';


/*
Best to use constants to be consistent in the application's pages.
 */



// The following are the names of pages
const kCreateProfileTitle = "Setting up Profile";
const kChoosingAvatarTitle = "Choose your Avatar";
const kHomepageTitle = "Feed";
const kChatTitle = "Chat";
const kForumTitle = "Title";
const kLoginPageTitle = "Login";
const kTipsCategoriesTitle = "Categories";
const kForumsTitle = "Forum";
const kJournalMain = "Journal";
const kNotificationTitle = "Notifications";

const systemFontFamily = "StudentsTeacher";
const systemHeaderFontFamiy = "Nunito";




// Application colour in general
const kbackgroundColor = Color(0xFF202020);
const kPrimaryColor = Color(0xFFFFBD73);

class Constants{
  static String myName = "";
  static String myUID = "";
  static String myAvatar = "";
  static String myRole = "";
  static String myEmail = "";
  static int myThemeColour = 0;
  static int myMoodColour = 0;
  static Color secondaryColour = Color(Constants.myThemeColour + 25).withOpacity(1);
  static Color primaryColour = Color(Constants.myThemeColour).withOpacity(1);
}

// Main page AppBar
AppBar mainAppBar(String title){
  return AppBar(
    backgroundColor: Color(Constants.myThemeColour).withOpacity(1),
    title: Text(title),
    leading: NavigationWidget(),
  );
}

// Sub Page AppBar
AppBar subAppBar(String title){
  return AppBar(
    backgroundColor: Color(Constants.myThemeColour + 25).withOpacity(1),
    title: Text(title),
    leading: NavigationWidget(),
  );
}

// TextForm Style for inputs
InputDecoration inputDecoration(String labelText){
  return InputDecoration(
    focusColor: Colors.black,
    labelStyle: TextStyle(color: Colors.black, ),
    labelText: labelText,
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.black),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
    ),
  );
}

// TextForm Style for inputs with icon
InputDecoration inputDecorationWithIcon(String labelText, Icon icon){
  return InputDecoration(
    icon: icon,
    focusColor: Colors.black,
    labelStyle: TextStyle(color: Colors.black, ),
    labelText: labelText,
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.black),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
    ),
  );
}

// Text style for User Profile Information Display
Text profileText(String info){
  return Text(info, style: TextStyle(fontFamily: "StudentsTeacher", fontWeight: FontWeight.bold,fontSize: 15), );
}


// Forms




// Descriptions





/*
Colors for the application:

Main Colour: Colors.lightBlue  or RoyalBlue
Secondary Colour: Red/ White/peach/ pink/



Complementary colour: Sandy Beige, Brigh Orange, Aplpe green, Orchid,
Coral, Natural wood tones, cherry red, neutrals, White

Best for healthcare appL Light Blue, Light red and light green.

Gradient colour:


Colour for forum:
Teal, azure, aquamarine, Antique hwite. alice blue,

 */
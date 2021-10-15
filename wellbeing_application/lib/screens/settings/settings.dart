import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Settings")
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10.0)),
                Text("User Information"),
                settingsButton(btnName: "Update Details"),
                Text("Theme"),
                Text("Notifications"),
                // can add in for random notification pushes
                Text("About the app"),
                settingsButton(btnName: "About the app")
              ],
            ),
          ),
        )
    );;
  }
}



// Help to create multiple buttons

class settingsButton extends StatefulWidget {
  final String btnName;
  settingsButton({required this.btnName});

  @override
  _settingsButtonState createState() => _settingsButtonState();
}

class _settingsButtonState extends State<settingsButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: ElevatedButton(onPressed: (){},
          child: Text(widget.btnName),
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width/1.5, MediaQuery.of(context).size.width/9),
          primary: Colors.blue[500]
        ),
      ),
    );
  }
}



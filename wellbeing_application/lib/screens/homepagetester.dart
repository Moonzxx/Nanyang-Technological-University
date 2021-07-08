import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile.dart';

/*
This is for the homepage.

Homepage Information:
  - Feed (Such as small summary of wellbeing)
  - (summary analysis of wellbeing)
  - How are you feeling

 */


class HomePageTester extends StatefulWidget {

  @override
  _HomePageTesterState createState() => _HomePageTesterState();


}

class _HomePageTesterState extends State<HomePageTester> {
  Widget build(BuildContext context) {

    //Creation of the Bottom Menu
    var feed = new bottomTabButton(height:MediaQuery.of(context).size.height / 20, width:MediaQuery.of(context).size.width * 0.25, tool: Icons.email );
    var forum = new bottomTabButton(height:MediaQuery.of(context).size.height / 20, width:MediaQuery.of(context).size.width * 0.25, tool: Icons.headphones );
    var tips = new bottomTabButton(height:MediaQuery.of(context).size.height / 20, width:MediaQuery.of(context).size.width * 0.25, tool: Icons.privacy_tip );
    var profile = new bottomTabButton(height:MediaQuery.of(context).size.height / 20, width:MediaQuery.of(context).size.width * 0.25, tool: Icons.account_circle );

    // Creation of the tabs (For the current bottom tab)
    var here = new stateTabButton(tabName: "Here");
    var there = new stateTabButton(tabName: "There");


    return Scaffold(
        body: Stack(
          children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center ,
                    children: <Widget>[
                      feed,
                      forum,
                      tips,
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage()),);
                        },
                        child:profile,
                      ),
                ],
              ),
            ], // Children for Col
          ),
            Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 11.75,
              child: TextButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(70.0,70.0)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  )),
                  backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                ),
                onPressed: () {},
                child: Icon(
                    Icons.headphones_battery_rounded ,size: 15.0),

              ),/*Container(
                  width: 70.0,
                  height:70.0,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, style: BorderStyle.solid, width : 1.0),
                  ),
                child: Icon(
                    Icons.headphones_battery_rounded ,size: 15.0),

                ),*/
            ),
            Container(
              height: MediaQuery.of(context).size.height / 10,
              width: MediaQuery.of(context).size.width,
              color: Colors.lightBlue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end ,
                children: <Widget>[
                  here,
                  there,

                ],
              ),
            ),
            /* Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center ,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                            color: Colors.lightBlue,
                            height: MediaQuery.of(context).size.height / 15,
                            width: MediaQuery.of(context).size.width,

                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end ,
                          children: <Widget>[
                            Text("Here", style: TextStyle(fontSize: 15.0)),
                            Text("This", style: TextStyle(fontSize: 15.0)),

                          ],
                        ),


                      ],
                    ),


                  ],
                ),

              ],
            ), */
        ],
        ),
    );
  }
}



// For the bottom menu buttons

class bottomTabButton extends StatefulWidget {
  late double width;
  late double height;
  late IconData tool;
  bottomTabButton({required this.width, required this.height, required this.tool});

  @override
  _bottomTabButtonState createState() => _bottomTabButtonState();
}

class _bottomTabButtonState extends State<bottomTabButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0, style: BorderStyle.solid),
      ),
      child:
      Icon(
          widget.tool,size: 15.0),
    );
  }
}



// Help to create tab buttons

class stateTabButton extends StatefulWidget {
  late String tabName;
  stateTabButton({required this.tabName});

  @override
  _stateTabButtonState createState() => _stateTabButtonState();
}

class _stateTabButtonState extends State<stateTabButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height /30,
      //width: MediaQuery.of(context).size.width * 0.25,
      padding: EdgeInsets.all(5.0),
      child: TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white,
            onSurface: Colors.black,
          ),
          onPressed: ()  {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Testing'),
                content:  Text('This works'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed:  () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: Text(widget.tabName,
          style: TextStyle(fontSize: 15.0),)
      ),
    );
  }
}

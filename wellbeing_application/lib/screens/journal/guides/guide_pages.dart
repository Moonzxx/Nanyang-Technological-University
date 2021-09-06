import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/Helpers/Helpers.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class Pages extends StatefulWidget {
  const Pages({Key? key}) : super(key: key);

  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {

  final pages = [
    Container(
      color: Colors.lightBlueAccent,
      child: Column(
        children: <Widget>[
          SizedBox(height: 10,),

          Text("Title"), // Change the TextStyle
          SizedBox(height: 10,),
          Text("Page One"),

        ],
      ),
    ),
    Container(
      color: Colors.lightGreenAccent,
      child: Column(
        children: <Widget>[
          SizedBox(height:10,),

          Image.asset("assets/images/delivery_man.png"),
          SizedBox(height: 30,),
          Text("Order Success",
          style: TextStyle(
            fontSize: 22.0, color: Colors.black, fontWeight: FontWeight.bold,
          ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          Text("Now, you are connect direcly\nwith yur order, Lets check the details\n Just wait fr you service here", style:
            TextStyle(fontSize: 16.0, color: Colors.white),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,)
        ],
      ),
    ),
    Container(
      color: Colors.lightGreenAccent,
      child: Column(
        children: <Widget>[
          SizedBox(height:10,),

          Image.asset("assets/images/delivery_man.png"),
          SizedBox(height: 30,),
          Text("Order Success",
            style: TextStyle(
              fontSize: 22.0, color: Colors.black, fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          Text("Now, you are connect direcly\nwith yur order, Lets check the details\n Just wait fr you service here", style:
          TextStyle(fontSize: 16.0, color: Colors.white),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,),
          ElevatedButton(
            // Should go tp the Journal Main Homepage
              onPressed: (){},
              child: Text('Start Journaling'))
        ],
      ),
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: LiquidSwipe(
            pages: pages,
            enableLoop: true,
            fullTransitionValue: 300,
            enableSlideIcon: true,
            waveType: WaveType.liquidReveal,
            positionSlideIcon: 0.5,
          ),
        )
      ),
    );
  }
}

/*

Set Mood Page
- User can choose colour to display their mood
- Colour display around user's DP

*/

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({Key? key}) : super(key: key);

  @override
  _MoodPageState createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  Color color = Colors.greenAccent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text("Select Mood", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 30),),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              //top: Radius.circular(30),
                bottom: Radius.circular(30)
            )
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                width: 150,
                  height: 150,
              ),
              SizedBox(height:15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24,)
                ),
                child: Text(
                  "Pick Color",
                  style: TextStyle(fontSize:24)
                ),
                onPressed: () => showDialog(context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("dfsdf"),
                        content: Text("adsads"),
                      );
                    })

                /* showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Container(
                        height: 200,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'What do you want to remember'
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.red)
                                      ),
                                      onPressed: (){},
                                      child: Text("Delelt",style: TextStyle(color: Colors.white),
                                      ),

                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: (){},
                                      child: Text("Okayy",style: TextStyle(color: Colors.white),
                                      ),

                                    ),

                                  )
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ) */ //pickColor(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Can be changed into a block picker as well
  Widget buildColorPicker() => ColorPicker(
    pickerColor: color,
    enableAlpha: false, // Hides the advance option to not change the colour's opacity
    showLabel: false, // Hiding the Hex value
    onColorChanged: (color) => setState(() => this.color = color),
  );

  void pickColor(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.all(10),
      title: Text('Pick your colour'),
      content: Column(
        children: <Widget>[
          buildColorPicker(),
          TextButton(
            child: Text(
              "SELECT",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );



}

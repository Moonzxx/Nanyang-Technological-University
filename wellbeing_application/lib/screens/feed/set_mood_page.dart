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
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Mood Colour"),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              width: 120,
                height: 120,
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
              onPressed: () => pickColor(context),
            ),
          ],
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

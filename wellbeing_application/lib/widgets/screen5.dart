import 'package:flutter/material.dart';

class Screen5 extends StatelessWidget {
  const Screen5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Screen 5",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
        )
      ),
    );
  }
}

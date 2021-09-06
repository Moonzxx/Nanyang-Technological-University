import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Screen 1",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
        )
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Screen4 extends StatelessWidget {
  const Screen4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Screen 4",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
        )
      ),
    );
  }
}

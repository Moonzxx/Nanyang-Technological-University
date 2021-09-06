import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Screen 2",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
        )
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Screen3 extends StatelessWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Screen 3",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
        )
      ),
    );
  }
}

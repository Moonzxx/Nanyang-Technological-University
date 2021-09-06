import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:liquid_swipe/Helpers/Helpers.dart';
import 'guide_pages.dart';

class JournalGuide extends StatelessWidget {
  const JournalGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Pages(),
    );
  }
}

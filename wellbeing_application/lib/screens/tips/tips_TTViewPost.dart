import 'package:flutter/material.dart';

// When displaying post, can bookmarked it
class TTViewPost extends StatefulWidget {
  final String mainCat;
  final String subCat;
  final String postTitleName;
  TTViewPost({required this.mainCat, required this.subCat, required this.postTitleName});

  @override
  _TTViewPostState createState() => _TTViewPostState();
}

class _TTViewPostState extends State<TTViewPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postTitleName),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height/3,
          width: MediaQuery.of(context).size.width
        ),
      )
    );
  }
}


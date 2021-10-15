import 'package:flutter/material.dart';

class AddDiaryEntry extends StatefulWidget {
  const AddDiaryEntry({Key? key}) : super(key: key);

  @override
  _AddDiaryEntryState createState() => _AddDiaryEntryState();
}



class _AddDiaryEntryState extends State<AddDiaryEntry> {

  final _addDiaryFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adding new diary Entry"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addDiaryFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              TextFormField()
            ],
          ),

        ),
      )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'journal_habits_model.dart';

class Habits extends StatelessWidget {
  const Habits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habits'),
      ),
      body: ListView.builder(
        itemCount: habitList.length,
        itemBuilder: (context, index){
          Habit habit = habitList[index];
          return Card(
            child: ListTile(
              title: Text(habit.title),
              subtitle: Text(habit.description),
                trailing: Icon(Icons.arrow_forward_rounded)
            )
          );
        },
      )
    );
  }
}

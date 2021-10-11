import 'package:flutter/material.dart';

class Habit{
  String title;
  String description;

  Habit({
    required this.title,
    required this.description
});
}

List<Habit> habitList = [
  Habit(
    title: 'Be Aware',
    description: 'asd'
  ),
  Habit(
      title: 'Be Active',
      description: 'asd'
  ),
  Habit(
      title: 'Connect',
      description: 'asd'
  ),
  Habit(
      title: 'Help Others',
      description: 'asd'
  ),
  Habit(
      title: 'Keep Learning',
      description: 'asd'
  )
];


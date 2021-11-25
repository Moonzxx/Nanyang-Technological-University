// @dart=2.10
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

// Utilities that will be used here (Just in case)

class Utils{
  static StreamTransformer transformer<T>(
      T Function(Map<String, dynamic> json) fromJson) =>
      StreamTransformer<QuerySnapshot,List<T>>.fromHandlers(
        handleData: (QuerySnapshot data, EventSink<List<T>> sink){
          final snaps = data.docs.map((doc) => doc.data()).toList();
          final users = snaps.map((json) => fromJson(json)).toList();

          sink.add(users);
      },
      );

  static DateTime toDateTime(Timestamp value){
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimetoJson(DateTime date){
    if (date == null) return null;

    return date.toUtc();
  }


}
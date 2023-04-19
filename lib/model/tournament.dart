import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Tournament {
  final String name;
  final bool isDone;
  final String Admin;
  final int icon;
  bool favorite = false;
  final String Id;
  bool isStarted;

  Tournament(
      {required this.name,
      required this.isDone,
      required this.Admin,
      required this.icon,
      required this.Id,
      required this.isStarted});

  void SetFavorite(bool b) {
    favorite = b;
  }

  void ChangeIsStarted() {
    isStarted = !isStarted;
  }

  void add(Tournament tournament) {}
}

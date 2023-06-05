import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Tournament {
  String name;
  final bool isDone;
  final String Admin;
  int icon;
  bool favorite = false;
  final String Id;
  bool isSearchingWinner;
  String tournamentType;

  Tournament(
      {required this.name,
      required this.isDone,
      required this.Admin,
      required this.icon,
      required this.Id,
      required this.isSearchingWinner,
      required this.tournamentType});

  void SetFavorite(bool b) {
    favorite = b;
  }

  void add(Tournament tournament) {}
}

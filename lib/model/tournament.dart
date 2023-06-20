import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Tournament {
  String name;
  final bool isDone;
  final String admin;
  int icon;
  bool favorite = false;
  final String Id;
  bool isSearchingWinner;
  String tournamentType;

  //input: name, isDone, admin, icon, Id, isSearchingWinner, tournamentType
  //output: new Tournament
  Tournament(
      {required this.name,
      required this.isDone,
      required this.admin,
      required this.icon,
      required this.Id,
      required this.isSearchingWinner,
      required this.tournamentType});

  void SetFavorite(bool b) {
    favorite = b;
  }

  void add(Tournament tournament) {}
}

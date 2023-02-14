import 'package:flutter/cupertino.dart';

class Tournament {
  final String name;
  final String color;
  final bool isDone;
  final String Admin;

  Tournament(
      {required this.name,
      required this.color,
      required this.isDone,
      required this.Admin});
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Tournament {
  final String name;
  final bool isDone;
  final String Admin;
  final int icon;

  Tournament(
      {required this.name,
      required this.isDone,
      required this.Admin,
      required this.icon});

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
        name: json['name'],
        isDone: json['isDone'],
        Admin: json['Admin'],
        icon: json['icon']);
  }
  factory Tournament.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return Tournament(
        name: document.id,
        isDone: data!['isDone'],
        Admin: data!['Admin'],
        icon: data!['icon']);
  }
}

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/tournament.dart';

class TournamentProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool saving = false;
  final List<Tournament> tournaments = <Tournament>[];

  List<Tournament> get Tournaments {
    return [...tournaments];
  }

  Future<void> fetchTournamentData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("tournaments").get();
      snapshot.docs.forEach((element) {
        tournaments
            .add(snapshot.docs.map((e) => Tournament.fromSnapshot(e)).single);
      });
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  void addTournamentToFirebase(TextEditingController listNameController,
      bool IsDone, BuildContext context) async {
    User? authResult = _auth.currentUser;
    saving = true;
    bool isExist = false;

    QuerySnapshot query =
        await FirebaseFirestore.instance.collection(authResult!.uid).get();

    query.docs.forEach((doc) {
      if (listNameController.text.toString() == doc.id) {
        isExist = true;
      }
    });

    if (isExist == false && listNameController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("tournaments")
          .doc(listNameController.text.toString())
          .set({
        "IsDone": IsDone,
        "admin": authResult.uid,
        "date": DateTime.now().millisecondsSinceEpoch
      });

      tournaments.add(Tournament(
          name: listNameController.text.toString(),
          isDone: IsDone,
          Admin: authResult.uid));

      Navigator.of(context).pop();
    }
    if (isExist == true) {
      showInSnackBar("This list already exists", context,
          Theme.of(context).scaffoldBackgroundColor);
      saving = false;
    }
    if (listNameController.text.isEmpty) {
      showInSnackBar("Please enter a name", context,
          Theme.of(context).scaffoldBackgroundColor);
      saving = false;
    }
    listNameController.clear();
    notifyListeners();
  }

  void showInSnackBar(String value, BuildContext context, Color color) {
    ScaffoldMessenger.of(context)?.removeCurrentSnackBar();

    ScaffoldMessenger.of(context)?.showSnackBar(new SnackBar(
      content: new Text(value, textAlign: TextAlign.center),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/model/team.dart';
import 'package:flutter_complete_guide/model/tournament.dart';

import '../model/team.dart';

class TeamProvider extends ChangeNotifier {
  List<Team> _teams = [];
  final _auth = FirebaseAuth.instance;
  bool saving = false;

  List<Team> get Teams {
    return [..._teams];
  }

  Future<void> fetchTeamData(context) async {
    try {
      await FirebaseFirestore.instance.collection('tournaments').get().then(
        (QuerySnapshot value) {
          value.docs.forEach(
            (result) {
              Team newT = Team(
                  name: result["name"],
                  tId: result["tournamentId"],
                  userId: result["userId"],
                  id: result.id,
                  gamePlayed: result["gamePlayed"]);
              _teams.add(newT);
            },
          );
        },
      );
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> addTeamToFireBase(BuildContext context, TextEditingController listNameController, String tId) async {
    saving = true;
    QuerySnapshot query = await FirebaseFirestore.instance.collection("Teams").get();

    String Id = "";
    await FirebaseFirestore.instance
        .collection("Teams")
        .add({"tournamentId": tId, "name": listNameController.text, "userId": _auth.currentUser!.uid}).then(
            (value) => Id = value.id);

    _teams.add(Team(tId: tId, id: Id, userId: _auth.currentUser!.uid, name: listNameController.text, gamePlayed: 0));

    //Navigator.of(context).pop();
    notifyListeners();
  }

  Future<void> updateTeamNameFromFireBase(BuildContext context, String name, Team team) async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection("Teams").get();

    String Id = team.id;
    await FirebaseFirestore.instance.collection("Teams").doc(Id).update({
      "name": name,
    });

    Team t = findTeam(team.id);
    t.name = name;

    notifyListeners();
  }

  Team findTeam(String? id) {
    return _teams.firstWhere((element) => element.id == id);
  }

  Future<void> updateTeamGameCountFromFireBase(BuildContext context, String team) async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection("Teams").get();
    Team t = _teams.firstWhere((element) => element.id == team);
    String Id = team;
    await FirebaseFirestore.instance.collection("Teams").doc(Id).update({
      "gamePlayed": t.gamePlayed,
    });
    t.gamePlayed++;

    notifyListeners();
  }
}

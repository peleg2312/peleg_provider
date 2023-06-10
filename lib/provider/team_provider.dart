import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/model/team.dart';

class TeamProvider extends ChangeNotifier {
  List<Team> _teams = [];
  final _auth = FirebaseAuth.instance;
  bool saving = false;

  //output: copy of _teams
  List<Team> get Teams {
    return [..._teams];
  }

  //output: getting data from firebase and putting it inside _teams List
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

  //input: context, listNameController, tId
  //output: adding new Team to _teams and Firebase
  Future<void> addTeamToFireBase(BuildContext context, TextEditingController listNameController, String tId) async {
    saving = true;
    QuerySnapshot query = await FirebaseFirestore.instance.collection("Teams").get();

    String Id = "";
    await FirebaseFirestore.instance
        .collection("Teams")
        .add({"tournamentId": tId, "name": listNameController.text, "userId": _auth.currentUser!.uid}).then(
            (value) => Id = value.id);

    _teams.add(Team(tId: tId, id: Id, userId: _auth.currentUser!.uid, name: listNameController.text, gamePlayed: 0));
    notifyListeners();
  }

  //input: context, name, team
  //output: update the name of the team in the local List and in the Firebase
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

  //input: id
  //output: Team from _teams that have the same id as inputted
  Team findTeam(String? id) {
    return _teams.firstWhere((element) => element.id == id);
  }

  //input: context, team
  //output: update the team gamePlayed count in Firebase and in the local list
  Future<void> updateTeamGamePlayedFromFireBase(BuildContext context, String team) async {
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

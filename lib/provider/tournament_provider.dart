import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/tournament.dart';

class TournamentProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool saving = false;
  final List<Tournament> tournaments = <Tournament>[];

  //output: copy of tournaments
  List<Tournament> get Tournaments {
    return [...tournaments];
  }

  //input: tournament Id
  //output: Tournament with the tId as Id
  Tournament findTournament(String tId) {
    return tournaments.firstWhere((element) => element.Id == tId);
  }

  //input: tournament Id
  //output: delete the tournament with the tId as his Id
  void deleteTournament(String tId) {
    FirebaseFirestore.instance.collection("tournaments").doc(tId).delete();
    tournaments.remove(findTournament(tId));
    notifyListeners();
  }

  //output: getting data from firebase and putting it inside tournaments list
  Future<void> fetchTournamentData(context) async {
    try {
      await FirebaseFirestore.instance.collection('tournaments').get().then(
        (QuerySnapshot value) {
          value.docs.forEach(
            (result) {
              Tournament newT = Tournament(
                  name: result["name"],
                  isDone: result["IsDone"],
                  admin: result["admin"],
                  icon: result["icon"],
                  Id: result.id,
                  isSearchingWinner: result["isSearchingWinner"],
                  tournamentType: result.data().toString().contains("tournamentType") ? result["tournamentType"] : "");

              tournaments.add(newT);
            },
          );
        },
      );
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  //input: listNameController, context, iconSelected
  //output: add new Tournament to Firebase and the local list
  Future<String> addTournamentToFirebase(
      TextEditingController listNameController, BuildContext context, int iconSelected) async {
    User? authResult = _auth.currentUser;
    saving = true;
    bool isExist = false;

    QuerySnapshot query = await FirebaseFirestore.instance.collection("tournaments").get();

    query.docs.forEach((doc) {
      if (listNameController.text.toString() == doc.id) {
        isExist = true;
      }
    });

    String Id = "";
    if (isExist == false && listNameController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection("tournaments").add({
        "name": listNameController.text.toString(),
        "IsDone": false,
        "admin": authResult?.uid,
        "date": DateTime.now().millisecondsSinceEpoch,
        "icon": iconSelected,
        "isSearchingWinner": false
      }).then((value) => Id = value.id);

      tournaments.add(Tournament(
          name: listNameController.text.toString(),
          isDone: false,
          admin: authResult!.uid,
          icon: iconSelected,
          Id: Id,
          isSearchingWinner: false,
          tournamentType: ""));
    }
    if (isExist == true) {
      showInSnackBar("This list already exists", context, Theme.of(context).scaffoldBackgroundColor);
      saving = false;
    }
    if (listNameController.text.isEmpty) {
      showInSnackBar("Please enter a name", context, Theme.of(context).scaffoldBackgroundColor);
      saving = false;
    }
    listNameController.clear();
    notifyListeners();
    return Id;
  }

  //intput: tournamentType, tId
  //output: update the tournamentType of the tournament in Firebase and the local list
  Future<void> updateTornamentType(String tournamentType, String tId) async {
    await FirebaseFirestore.instance.collection("tournaments").doc(tId).update({"tournamentType": tournamentType});

    Tournament t = tournaments.firstWhere((element) => element.Id == tId);
    t.tournamentType = tournamentType;
  }

  //intput: tid, s
  //output: update the isSearchingWinner of the tournament in Firebase and the local list
  Future<void> updateTornamentWinnerSearching(String tId, bool s) async {
    await FirebaseFirestore.instance.collection("tournaments").doc(tId).update({"isSearchingWinner": s});

    Tournament t = tournaments.firstWhere((element) => element.Id == tId);
    t.isSearchingWinner = s;
  }

  //intput: listNameController, context, iconSelected, tournament
  //output: update the name and icon of the tournament in Firebase and the local list
  void updateTournamentToFirebase(
    TextEditingController listNameController,
    BuildContext context,
    int iconSelected,
    Tournament tournament,
  ) async {
    saving = true;

    await FirebaseFirestore.instance.collection("tournaments").doc(tournament.Id).update({
      "name": listNameController.text.toString(),
      "icon": iconSelected,
    });

    Tournament t = tournaments.firstWhere((element) => element.Id == tournament.Id);
    t.name = listNameController.text;
    t.icon = iconSelected;

    FirebaseFirestore.instance.collection('userFavorite').get().then(((QuerySnapshot value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('userFavorite')
            .doc(element.id)
            .collection('tournament')
            .get()
            .then((QuerySnapshot value) {
          value.docs.forEach((result) {
            if (result.id == tournament.Id) {
              FirebaseFirestore.instance
                  .collection("userFavorite")
                  .doc(element.id)
                  .collection("tournament")
                  .doc(result.id)
                  .update({"name": listNameController.text.toString(), "icon": iconSelected});
            }
          });
        });
      });
    }));

    Navigator.of(context).pop();

    listNameController.clear();
    notifyListeners();
  }

  //intput: value, context, color
  //output: make visual SnackBar with error message
  void showInSnackBar(String value, BuildContext context, Color color) {
    ScaffoldMessenger.of(context)?.removeCurrentSnackBar();

    ScaffoldMessenger.of(context)?.showSnackBar(new SnackBar(
      content: new Text(value, textAlign: TextAlign.center),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }
}

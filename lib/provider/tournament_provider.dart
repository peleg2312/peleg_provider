import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:flutter_complete_guide/provider/favorite_tournament_provider.dart';
import 'package:provider/provider.dart';

class TournamentProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool saving = false;
  final List<Tournament> tournaments = <Tournament>[];

  List<Tournament> get Tournaments {
    return [...tournaments];
  }

  Future<void> fetchTournamentData(context) async {
    //List<Tournament> Ftournaments =
    //    Provider.of<FavoriteTournamentProvider>(context).FavoriteTournaments;
    try {
      await FirebaseFirestore.instance.collection('tournaments').get().then(
        (QuerySnapshot value) {
          value.docs.forEach(
            (result) {
              Tournament newT = Tournament(
                  name: result["name"],
                  isDone: result["IsDone"],
                  Admin: result["admin"],
                  icon: result["icon"],
                  Id: result.id,
                  isSearchingWinner: result["isSearchingWinner"],
                  tournamentType: result["tournamentType"]);

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
          Admin: authResult!.uid,
          icon: iconSelected,
          Id: Id,
          isSearchingWinner: false,
          tournamentType: ""));

      //Navigator.of(context).pop();
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

  Future<void> updateTornamentType(String tournamentType, String tId) async {
    await FirebaseFirestore.instance.collection("tournaments").doc(tId).update({"tournamentType": tournamentType});

    Tournament t = tournaments.firstWhere((element) => element.Id == tId);
    t.tournamentType = tournamentType;
  }

  Future<void> updateTornamentWinnerSearching(String tId, bool s) async {
    await FirebaseFirestore.instance.collection("tournaments").doc(tId).update({"isSearchingWinner": s});

    Tournament t = tournaments.firstWhere((element) => element.Id == tId);
    t.isSearchingWinner = s;
  }

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

    // FirebaseFirestore.instance.collection('userFavorite').get().then(((QuerySnapshot value) {
    //   value.docs.forEach((element) {
    //     FirebaseFirestore.instance
    //         .collection('userFavorite')
    //         .doc(element.id)
    //         .collection('tournament')
    //         .get()
    //         .then((QuerySnapshot value) {
    //       value.docs.forEach((result) {
    //         if (result.id == tournament.name) {
    //           FirebaseFirestore.instance
    //               .collection("userFavorite")
    //               .doc(element.id)
    //               .collection("tournament")
    //               .doc(result.id)
    //               .update({"icon": iconSelected});
    //         }
    //       });
    //     });
    //   });
    // }));

    Navigator.of(context).pop();

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

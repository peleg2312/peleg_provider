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
                  isStarted: result["isStarted"]);

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

  void addTournamentToFirebase(TextEditingController listNameController,
      bool IsDone, BuildContext context, int iconSelected) async {
    User? authResult = _auth.currentUser;
    saving = true;
    bool isExist = false;

    QuerySnapshot query =
        await FirebaseFirestore.instance.collection("tournaments").get();

    query.docs.forEach((doc) {
      if (listNameController.text.toString() == doc.id) {
        isExist = true;
      }
    });

    String Id = "";
    if (isExist == false && listNameController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection("tournaments").add({
        "name": listNameController.text.toString(),
        "IsDone": IsDone,
        "admin": authResult?.uid,
        "date": DateTime.now().millisecondsSinceEpoch,
        "icon": iconSelected,
        "isStarted": false
      }).then((value) => Id = value.id);

      tournaments.add(Tournament(
          name: listNameController.text.toString(),
          isDone: IsDone,
          Admin: authResult!.uid,
          icon: iconSelected,
          Id: Id,
          isStarted: false));

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

  void updateTournamentToFirebase(
      TextEditingController listNameController,
      bool IsDone,
      BuildContext context,
      int iconSelected,
      Tournament tournament,
      bool isStarted) async {
    User? authResult = _auth.currentUser;
    saving = true;
    bool isExist = false;
    String Id = tournament.Id;

    await FirebaseFirestore.instance
        .collection("tournaments")
        .doc(tournament.Id)
        .set({
      "name": listNameController.text.toString(),
      "IsDone": IsDone,
      "admin": tournament.Admin,
      "date": DateTime.now().millisecondsSinceEpoch,
      "icon": iconSelected,
      "isStarted": isStarted
    });

    tournaments.removeWhere((element) => element == tournament);

    tournaments.add(Tournament(
        name: listNameController.text.toString(),
        isDone: IsDone,
        Admin: authResult!.uid,
        icon: iconSelected,
        Id: Id,
        isStarted: isStarted));

    FirebaseFirestore.instance
        .collection('userFavorite')
        .get()
        .then(((QuerySnapshot value) {
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
                  .set({
                "name": listNameController.text.toString(),
                "IsDone": IsDone,
                "admin": tournament.Admin,
                "date": DateTime.now().millisecondsSinceEpoch,
                "icon": iconSelected
              });
            }
          });
        });
      });
    }));

    FirebaseFirestore.instance
        .collection('userFavorite')
        .get()
        .then(((QuerySnapshot value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('userFavorite')
            .doc(element.id)
            .collection('tournament')
            .get()
            .then((QuerySnapshot value) {
          value.docs.forEach((result) {
            if (result.id == tournament.name) {
              FirebaseFirestore.instance
                  .collection("userFavorite")
                  .doc(element.id)
                  .collection("tournament")
                  .doc(result.id)
                  .set({
                "IsDone": IsDone,
                "admin": tournament.Admin,
                "date": DateTime.now().millisecondsSinceEpoch,
                "icon": iconSelected
              });
            }
          });
        });
      });
    }));

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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/tournament.dart';

class FavoriteTournamentProvider extends ChangeNotifier {
  User? authResult = FirebaseAuth.instance.currentUser;
  final List<String> favoriteTournaments = <String>[];

  //output: copy of favoriteTournaments
  List<String> get FavoriteTournaments {
    return [...favoriteTournaments];
  }

  //output: getting data from firebase and putting it inside _match list
  Future<void> fetchFavoriteTournamentData() async {
    try {
      await FirebaseFirestore.instance
          .collection('userFavorite')
          .doc(authResult!.uid)
          .collection("tournament")
          .get()
          .then(
        (QuerySnapshot value) {
          value.docs.forEach(
            (result) {
              favoriteTournaments.add(result.id);
            },
          );
        },
      );
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  //intput: tournament
  //output: setting tournament favorite in the Firebase and in the local list
  void FavoriteTournament(Tournament tournament) async {
    bool isExist = false;

    QuerySnapshot query =
        await FirebaseFirestore.instance.collection("userFavorite").doc(authResult!.uid).collection("tournament").get();

    query.docs.forEach((doc) {
      if (tournament.Id == doc.id) {
        isExist = true;
      }
    });

    if (isExist == false) {
      tournament.SetFavorite(true);
      FirebaseFirestore.instance
          .collection("userFavorite")
          .doc(authResult!.uid)
          .collection("tournament")
          .doc(tournament.Id)
          .set({"name": tournament.name});
      FirebaseFirestore.instance
          .collection("userFavorite")
          .doc(authResult!.uid)
          .set({"userName": authResult?.displayName});
      favoriteTournaments.add(tournament.Id);
    } else {
      tournament.SetFavorite(false);
      FirebaseFirestore.instance
          .collection("userFavorite")
          .doc(authResult!.uid)
          .collection("tournament")
          .doc(tournament.Id)
          .delete();
      favoriteTournaments.remove(tournament.Id);
    }

    notifyListeners();
  }
}

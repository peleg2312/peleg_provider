import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/tournament.dart';

class FavoriteTournamentProvider extends ChangeNotifier {
  User? authResult = FirebaseAuth.instance.currentUser;
  final List<String> favoriteTournaments = <String>[];

  List<String> get FavoriteTournaments {
    return [...favoriteTournaments];
  }

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

  void FavoriteTournament(Tournament tournament) async {
    bool isExist = false;

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("userFavorite")
        .doc(authResult!.uid)
        .collection("tournament")
        .get();

    query.docs.forEach((doc) {
      if (tournament.Id == doc.id) {
        isExist = true;
      }
    });

    if (isExist == false) {
      await FirebaseFirestore.instance
          .collection("userFavorite")
          .doc(authResult!.uid)
          .collection("tournament")
          .doc(tournament.Id)
          .set({"name": tournament.name});
      await FirebaseFirestore.instance
          .collection("userFavorite")
          .doc(authResult!.uid)
          .set({"userName": authResult?.displayName});
      tournament.SetFavorite(true);
      favoriteTournaments.add(tournament.Id);
    } else {
      await FirebaseFirestore.instance
          .collection("userFavorite")
          .doc(authResult!.uid)
          .collection("tournament")
          .doc(tournament.Id)
          .delete();
      tournament.SetFavorite(false);
      favoriteTournaments.remove(tournament.Id);
    }
  }
}

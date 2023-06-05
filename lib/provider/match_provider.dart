import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/model/match.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:flutter_complete_guide/provider/team_provider.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:provider/provider.dart';

import '../model/team.dart';

class MatchProvider extends ChangeNotifier {
  List<GameMatch> _matches = [];
  final _auth = FirebaseAuth.instance;
  bool saving = false;

  List<GameMatch> getMatchForTournment(tourId) {
    return _matches.where((element) => element.tId == tourId).toList();
  }

  Future<void> fetchMatchData(context) async {
    try {
      await FirebaseFirestore.instance.collection('matches').get().then(
        (QuerySnapshot value) {
          value.docs.forEach(
            (result) {
              GameMatch newM = GameMatch(
                  winnerId: result["winnerId"],
                  tId: result["tournamentId"],
                  awayTeamId: result["awayTeamId"],
                  homeTeamId: result["homeTeamId"],
                  id: result.id);
              _matches.add(newM);
            },
          );
        },
      );
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> addMatchToFireBase(String homeTeam, String awayTeam, String tId) async {
    saving = true;

    String Id = "";
    await FirebaseFirestore.instance
        .collection("matches")
        .add({"tournamentId": tId, "homeTeam": homeTeam, "awayTeam": awayTeam, "winner": null}).then(
            (value) => Id = value.id);

    _matches.add(GameMatch(tId: tId, awayTeamId: awayTeam, homeTeamId: homeTeam, id: Id));

    notifyListeners();
  }

  Future<void> updateMatchFromFireBase(String winnerId, GameMatch match, BuildContext ctx) async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection("matches").get();

    String Id = match.id;
    await FirebaseFirestore.instance.collection("matches").doc(Id).update({
      "winner": winnerId,
    });

    GameMatch m = _matches.firstWhere((element) => element.id == match.id);
    m.winnerId = winnerId;

    Provider.of<TeamProvider>(ctx, listen: false).updateTeamGameCountFromFireBase(ctx, winnerId);
  }

  void createKnockOutSchedule(String tId, BuildContext ctx) {
    List<Team> teams =
        Provider.of<TeamProvider>(ctx, listen: false).Teams.where((element) => element.tId == tId).toList();
    int numTeams = teams.length;

    if (numTeams % 2 != 0) {
      teams.add(Team(
          name: "Bye", id: "id", tId: "tId", userId: "userId", gamePlayed: 0)); // Add a placeholder for the last team
      numTeams++;
    }

    int numMatches = (numTeams - 1);
    int baseMatches = (numTeams / 2).round();

    for (int i = 0; i < baseMatches; i++) {
      int homeIndex = i * 2;
      int awayIndex = i * 2 + 1;

      addMatchToFireBase(teams[homeIndex].id, teams[awayIndex].id, tId);
    }
  }

  void matchWin(String winnerId, GameMatch match, BuildContext ctx, String tId, String tournamentType) async {
    Tournament tournament =
        Provider.of<TournamentProvider>(ctx, listen: false).Tournaments.firstWhere((element) => element.Id == tId);
    bool isWinner = tournament.isSearchingWinner;
    Team t = Provider.of<TeamProvider>(ctx, listen: false).findTeam(winnerId);
    GameMatch vTeam;
    if (isWinner == true && "knockout" == tournamentType) {
      vTeam = _matches.firstWhere((element) {
        Team winner = Provider.of<TeamProvider>(ctx, listen: false).findTeam(element.winnerId);
        addMatchToFireBase(winnerId, winner.id, tId);
        return element.winnerId != null && element.id != winnerId && winner.gamePlayed == t.gamePlayed;
      });
    }
    await Provider.of<TournamentProvider>(ctx, listen: false).updateTornamentWinnerSearching(tId, !isWinner);
    await updateMatchFromFireBase(winnerId, match, ctx);
    notifyListeners();
  }

  void createRoundRobinSchedule(String tId, BuildContext ctx) async {
    List<Team> teams =
        Provider.of<TeamProvider>(ctx, listen: false).Teams.where((element) => element.tId == tId).toList();
    int numTeams = teams.length;
    int totalmatches = numTeams;

    for (int k = 0; k < totalmatches; k++) {
      for (int i = 0; i < totalmatches; i++) {
        if (i <= k) {
          continue;
        }
        await addMatchToFireBase(teams[k].id, teams[i].id, tId);
      }
    }
  }
}

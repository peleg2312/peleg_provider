import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  //intput: tourId
  //output: new list of matches searched by tourId
  List<GameMatch> getMatchForTournment(tourId) {
    return _matches.where((element) => element.tId == tourId).toList();
  }

  //output: getting data from firebase and putting it inside _match List
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

  //input: homeTeam, awayTeam, tId
  //output: adding new GameMatch to _matches and Firebase
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

  //input: winnerId, match, ctx
  //output: update the winnerId of the match to the Id of the winner and the winner team game played count
  Future<void> updateMatchFromFireBase(String winnerId, GameMatch match, BuildContext ctx) async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection("matches").get();

    String Id = match.id;
    await FirebaseFirestore.instance.collection("matches").doc(Id).update({
      "winner": winnerId,
    });

    GameMatch m = _matches.firstWhere((element) => element.id == match.id);
    m.winnerId = winnerId;

    Provider.of<TeamProvider>(ctx, listen: false).updateTeamGamePlayedFromFireBase(ctx, winnerId);
  }

  //input: tid, ctx
  //output: add new GameMatch to _matches once for every 2 teams and add team if the number of teams % 2 != 0
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

  //input: winnerId, match, ctx, tId, tournamentType
  //output: add new GameMatch to _matches if isWinnner == true or "knockout" == tournamentType and then update the tornament winnerSearching and update the match winner id and team GameCount
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

  //intput: tId, ctx
  //output: add new GameMatch to _matches as many times as number of teams pair you can make
  void createRoundRobinSchedule(String tId, BuildContext ctx) async {
    List<Team> teams =
        Provider.of<TeamProvider>(ctx, listen: false).Teams.where((element) => element.tId == tId).toList();
    int numTeams = teams.length;

    for (int k = 0; k < numTeams; k++) {
      for (int i = 0; i < numTeams; i++) {
        if (i <= k) {
          continue;
        }
        await addMatchToFireBase(teams[k].id, teams[i].id, tId);
      }
    }
  }
}

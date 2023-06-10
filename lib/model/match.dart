import 'package:flutter_complete_guide/model/team.dart';

class GameMatch {
  String homeTeamId;
  String awayTeamId;
  String? winnerId = null;
  String tId;
  String id;

  //input: homeTeamId, awayTeamId, winnerId, tId, id
  //output: new GameMatch
  GameMatch({required this.homeTeamId, required this.awayTeamId, this.winnerId, required this.tId, required this.id});
}

import 'package:flutter_complete_guide/model/OLD/player.dart';

class Team {
  String name;
  String id;
  String tId;
  String userId;
  int gamePlayed;

  //input: name, id, tId, userId, gamePlayed
  //output: new Team
  Team({required this.name, required this.id, required this.tId, required this.userId, required this.gamePlayed});
}

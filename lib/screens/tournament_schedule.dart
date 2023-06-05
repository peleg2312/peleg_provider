import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_complete_guide/algorithm/groupWithPlayOff.dart';
import 'package:flutter_complete_guide/algorithm/knockOut.dart';
import 'package:flutter_complete_guide/algorithm/robinRound.dart';
import 'package:flutter_complete_guide/model/team.dart';
import 'package:flutter_complete_guide/model/match.dart';
import 'package:flutter_complete_guide/model/topG.dart';
import 'package:flutter_complete_guide/provider/match_provider.dart';
import 'package:flutter_complete_guide/provider/team_provider.dart';
import 'package:provider/provider.dart';

class TournamentScheduleScreen extends StatefulWidget {
  String selectedTournamentType;
  String tId;

  TournamentScheduleScreen(this.selectedTournamentType, this.tId);

  @override
  _TournamentScheduleScreenState createState() => _TournamentScheduleScreenState();
}

class _TournamentScheduleScreenState extends State<TournamentScheduleScreen> {
  List<Team> teams = [];
  List<GameMatch> schedule = [];

  @override
  void didChangeDependencies() {
    schedule = Provider.of<MatchProvider>(context).getMatchForTournment(widget.tId);
    teams = Provider.of<TeamProvider>(context, listen: false).Teams;
    super.didChangeDependencies();
  }

  // void generateTournamentSchedule(TournamentType tournamentType) {
  //   //List<Team> teams = teamNames.map((name) => Team(name)).toList();

  //   if (tournamentType == TournamentType.knockout) {

  //   }
  //   else{

  //   }

  //   switch (tournamentType) {
  //     case TournamentType.roundRobin:
  //       generateRoundRobinSchedule(teams, winners, schedule);
  //       return null;
  //     case TournamentType.knockout:
  //       return generateKnockoutSchedule(teams, winners, schedule);
  //       return null;
  //     case TournamentType.groupWithPlayoff:
  //       generateGroupPlayoffSchedule(teams, winners, groups, schedule);
  //       return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tournament Schedule'),
      ),
      body: ListView.builder(
        itemCount: schedule.length,
        itemBuilder: (context, index) {
          final match = schedule[index];
          Team homeTeam = teams.firstWhere(((element) => element.id == match.homeTeamId));
          Team awayTeam = teams.firstWhere(((element) => element.id == match.awayTeamId));
          return ListTile(
            title: Text('Match ${index + 1}'),
            subtitle: Text('${homeTeam.name ?? 'TBD'} vs ${awayTeam.name ?? 'TBD'}'),
            trailing: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Set Winner'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${homeTeam.name ?? 'TBD'} vs ${awayTeam.name ?? 'TBD'}'),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                Provider.of<MatchProvider>(context)
                                    .matchWin(homeTeam.id, match, context, widget.tId, widget.selectedTournamentType);
                              });

                              Navigator.pop(context);
                            },
                            child: Text(homeTeam?.name ?? 'TBD'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                match.winnerId = awayTeam.id;
                              });
                              Navigator.pop(context);
                            },
                            child: Text(awayTeam.name ?? 'TBD'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text('Set Winner')),
          );
        },
      ),
    );
  }

  bool checkIfHaveWinner(Team? a) {
    bool c = false;
    if (a!.name.contains("winner ")) {
      c = true;
    }
    return c;
  }
}

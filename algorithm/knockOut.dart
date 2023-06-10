// import 'package:flutter_complete_guide/model/team.dart';
// import 'package:flutter_complete_guide/model/match.dart';

// void generateKnockoutSchedule(
//     List<Team> teams, List<Team> winners, List<Match> schedule) {
//   int numTeams = teams.length;

//   if (numTeams % 2 != 0) {
//     teams.add(Team('TBD')); // Add a placeholder for the last team
//     numTeams++;
//   }

//   int numMatches = (numTeams - 1);
//   int baseMatches = (numTeams / 2).round();
//   //int numMatchesInRound = numTeams ~/ 2;

//   for (int i = 0; i < baseMatches; i++) {
//     int homeIndex = i * 2;
//     int awayIndex = i * 2 + 1;

//     Match match = Match(
//       homeTeam: teams[homeIndex],
//       awayTeam: teams[awayIndex],
//     );
//     winners.add(Team("null"));
//     schedule.add(match);
//   }

//   int playOffMatches = numMatches - baseMatches;

//   for (int i = 0; i < playOffMatches; i++) {
//     if (schedule[i * 2].winner == null &&
//         schedule[(i * 2) + 1].winner == null) {
//       Match match = Match(
//         homeTeam: Team("winner " + (i * 2 + 1).toString()),
//         awayTeam: Team("winner " + ((i * 2) + 2).toString()),
//       );
//       winners.add(Team("winner " + (schedule.length + 1).toString()));
//       schedule.add(match);
//     } else {
//       Match match1 = schedule[i * 2];
//       Match match2 = schedule[(i * 2) + 1];

//       Match match = Match(
//         homeTeam: match1.winner,
//         awayTeam: match2.winner,
//       );
//       winners.add(Team("winner " + (schedule.length + 1).toString()));
//       schedule.add(match);
//     }
//   }
// }

// List<Match> generateKnockoutScheduleWin(
//     List<Match> schedule, List<Team> winners) {
//   List<Match> newSchedule = [];

//   int numMatches = (schedule.length);
//   int baseMatches = (schedule.length / 2).round();
//   //int numMatchesInRound = numTeams ~/ 2;

//   int playOffMatches = numMatches - baseMatches;

//   for (int i = 0; i < playOffMatches; i++) {
//     schedule.remove(schedule.last);
//   }

//   for (int i = 0; i < playOffMatches; i++) {
//     if (schedule[i * 2].winner == null &&
//         schedule[(i * 2) + 1].winner == null) {
//       Match match = Match(
//         homeTeam: Team("winner " + (i * 2 + 1).toString()),
//         awayTeam: Team("winner " + ((i * 2) + 2).toString()),
//       );
//       match.winner = winners[schedule.length + 1];
//       schedule.add(match);
//     } else if (schedule[i * 2].winner == null &&
//         schedule[(i * 2) + 1].winner != null) {
//       Match match2 = schedule[(i * 2) + 1];
//       Match match = Match(
//         homeTeam: Team("winner " + (i * 2 + 1).toString()),
//         awayTeam: match2.winner,
//       );
//       match.winner = winners[schedule.length];
//       schedule.add(match);
//     } else if (schedule[i * 2].winner != null &&
//         schedule[(i * 2) + 1].winner == null) {
//       Match match1 = schedule[i * 2];
//       Match match = Match(
//         homeTeam: match1.winner,
//         awayTeam: Team("winner " + ((i * 2) + 2).toString()),
//       );
//       match.winner = winners[schedule.length];
//       schedule.add(match);
//     } else {
//       Match match1 = schedule[i * 2];
//       Match match2 = schedule[(i * 2) + 1];

//       Match match = Match(
//         homeTeam: match1.winner,
//         awayTeam: match2.winner,
//       );
//       match.winner = winners[schedule.length];
//       schedule.add(match);
//     }
//   }

//   return schedule;
// }

// import 'package:flutter_complete_guide/model/team.dart';
// import 'package:flutter_complete_guide/model/match.dart';
// import 'dart:math' as math;

// import 'package:flutter_complete_guide/model/topG.dart';

// Map<Team, int> map = new Map();
// int groupWithPlayoffMatches = 0;
// int numGroups = 0;

// void generateGroupPlayoffSchedule(List<Team> teams, List<Team> winners, List<List<Team>> groups, List<Match> schedule) {
//   double logBase(num x, num base) => math.log(x) / math.log(base);
//   double log10(num x) => math.log(x) / math.ln10;
//   groupWithPlayoffMatches = 0;
//   // Divide teams into groups
//   int teamIndex = 0;
//   numGroups = 0;
//   bool c = true;
//   while (c == true) {
//     if (teams.length % 4 == 0 && (teams.length ~/ 4) % 2 == 0 && logBase(teams.length ~/ 3, 2) % 1 == 0) {
//       numGroups = teams.length ~/ 4;
//       c = false;
//       for (int i = 0; i < numGroups; i++) {
//         List<Team> group = [];
//         for (int j = 0; j < 4; j++) {
//           group.add(teams[teamIndex]);
//           teamIndex++;
//         }
//         groups.add(group);
//       }
//       for (int i = 0; i < numGroups; i++) {
//         generateRoundRobinScheduleWithGroups(groups[i], winners, schedule);
//       }
//     } else if (teams.length % 3 == 0 && (teams.length ~/ 3) % 2 == 0 && logBase(teams.length ~/ 3, 2) % 1 == 0) {
//       numGroups = teams.length ~/ 3;
//       c = false;
//       for (int i = 0; i < numGroups; i++) {
//         List<Team> group = [];
//         for (int j = 0; j < 3; j++) {
//           group.add(teams[teamIndex]);
//           teamIndex++;
//         }
//         groups.add(group);
//       }
//       for (int i = 0; i < numGroups; i++) {
//         generateRoundRobinScheduleWithGroups(groups[i], winners, schedule);
//       }
//     } else {
//       teams.add(Team('BYE'));
//     }
//   }

//   for (int i = 0; i < numGroups / 2; i++) {
//     schedule.add(Match(
//         homeTeam: Team("second place barket " + (i * 2 + 1).toString()),
//         awayTeam: Team("first place barket " + (i * 2 + 2).toString())));
//     winners.add(Team("winner " + schedule.length.toString()));
//     groupWithPlayoffMatches++;
//     schedule.add(Match(
//         homeTeam: Team("second place " + (i * 2 + 2).toString()),
//         awayTeam: Team("first place " + (i * 2 + 1).toString())));
//     winners.add(Team("winner " + schedule.length.toString()));
//     groupWithPlayoffMatches++;
//   }

//   int playOffMatches = groups.length;
//   int index = 1;
//   for (var i = 0; i < winners.length - index; i += 2) {
//     if (!winners[i].name.contains("null")) {
//       schedule.add(Match(
//         homeTeam: winners[i],
//         awayTeam: winners[i + 1],
//       ));
//       winners.add(Team("winner " + schedule.length.toString()));
//       groupWithPlayoffMatches++;
//       index++;
//     }
//   }
//   // for (var i = 0; i < playOffMatches / 2; i++) {
//   //   schedule.add(Match(
//   //     homeTeam: winners[winners.length - (index * 2 - 2)],
//   //     awayTeam: winners[winners.length - (index * 2 - 3)],
//   //   ));
//   //   winners.add(Team("winner " + schedule.length.toString()));
//   //   groupWithPlayoffMatches++;
//   //   index++;
//   // }
//   schedule.add(Match(
//     homeTeam: Team("Final 1"),
//     awayTeam: Team("Final 2"),
//   ));
//   winners.add(Team("winner " + schedule.length.toString()));

//   groupWithPlayoffMatches++;
// }

// void generateGroupPlayoffSchedulWin(
//     List<Match> schedule, List<Team> winners, Map<int, Team> a, int playoff, List<TopG> tops, List<List<Team>> groups) {
//   // Divide teams into groups
//   int numMatches = schedule.length;
//   playoff = groupWithPlayoffMatches;
//   for (int i = 0; i < groupWithPlayoffMatches; i++) {
//     schedule.remove(schedule.last);
//   }

//   for (var match in schedule) {
//     if (a.containsKey(match.hashCode)) {
//       if (a[match.hashCode] != match.winner) {
//         if (match.winner == match.homeTeam) {
//           if (map.containsKey(match.awayTeam) == false) {
//             map[match.awayTeam!] = 0;
//           }
//           map[match.awayTeam!] = (map[match.awayTeam!]! - 1);
//         } else {
//           if (map.containsKey(match.homeTeam) == false) {
//             map[match.homeTeam!] = 0;
//           }
//           map[match.homeTeam!] = (map[match.homeTeam!]! - 1);
//         }
//         if (map.containsKey(match.winner) == false) {
//           map[match.winner!] = 0;
//         }
//         map[match.winner!] = (map[match.winner!]! + 1);
//         a[match.hashCode] = match.winner!;
//       }
//       continue;
//     }
//     if (match.winner!.name == "null" || checkIfHaveWinner(match.winner) == true) {
//       continue;
//     }
//     if (map.containsKey(match.winner) == false) {
//       map[match.winner!] = 0;
//     }
//     map[match.winner!] = (map[match.winner!]! + 1);
//     a[match.hashCode] = match.winner!;
//   }

//   if (a.length == schedule.length) {
//     tops = [];
//     for (List<Team> group in groups) {
//       List<TopG> top = [];

//       for (Team team in group) {
//         if (map.containsKey(team) == false) continue;
//         top.add(new TopG(winner: team, winCount: map[team]!));
//       }
//       top.sort(((a, b) => (b.winCount.compareTo(a.winCount))));

//       tops.add(top[0]);
//       tops.add(top[1]);
//     }
//   }

//   if (tops.isEmpty) {
//     for (int i = 0; i < numGroups / 2; i++) {
//       schedule.add(Match(
//           homeTeam: Team("second place barket " + (i * 2 + 1).toString()),
//           awayTeam: Team("first place barket " + (i * 2 + 2).toString()),
//           winner: winners[schedule.length]));
//       schedule.add(Match(
//           homeTeam: Team("second place barket " + (i * 2 + 2).toString()),
//           awayTeam: Team("first place barket " + (i * 2 + 1).toString()),
//           winner: winners[schedule.length]));
//       playoff -= 2;
//     }
//   } else {
//     for (int i = 0; i < numGroups; i += 2) {
//       schedule
//           .add(Match(homeTeam: tops[2 * i].winner, awayTeam: tops[2 * i + 3].winner, winner: winners[schedule.length]));
//       schedule.add(
//           Match(homeTeam: tops[2 * i + 2].winner, awayTeam: tops[2 * i + 1].winner, winner: winners[schedule.length]));
//       playoff -= 2;
//     }
//   }

//   for (var i = 0; i < playoff; i += 2) {
//     schedule.add(Match(
//         homeTeam: winners[winners.length - (playoff * 2 + 1 - i)],
//         awayTeam: winners[winners.length - (playoff * 2 - i)],
//         winner: winners[schedule.length]));
//   }

//   if (!winners[schedule.length - 1].name.contains("winner ") &&
//       !winners[schedule.length - 2].name.contains("winner ")) {
//     schedule.add(Match(
//         homeTeam: winners[schedule.length - 1],
//         awayTeam: winners[schedule.length - 2],
//         winner: winners[schedule.length]));
//   } else {
//     schedule.add(Match(homeTeam: Team("Final 1"), awayTeam: Team("Final 2"), winner: winners[schedule.length]));
//   }
// }

// bool checkIfHaveWinner(Team? a) {
//   bool c = false;
//   if (a!.name.contains("winner ")) {
//     c = true;
//   }
//   return c;
// }

// void generateRoundRobinScheduleWithGroups(List<Team> teams, List<Team> winners, List<Match> schedule) {
//   int numTeams = teams.length;
//   int totalmatches = numTeams;

//   List<Team> copy = List.from(teams);

//   for (int round = 0; round < totalmatches; round++) {
//     for (int match = 0; match < totalmatches; match++) {
//       if (match <= round) {
//         continue;
//       }
//       schedule.add(Match(homeTeam: copy[round], awayTeam: copy[match], winner: Team("null")));
//       winners.add(Team("winner null"));
//     }
//   }
// }

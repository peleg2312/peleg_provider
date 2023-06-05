// import 'package:flutter_complete_guide/model/team.dart';
// import 'package:flutter_complete_guide/model/match.dart';
// import 'package:flutter_complete_guide/model/topG.dart';

// Map<Team, int> map = new Map();

// void generateRoundRobinSchedule(
//     List<Team> teams, List<Team> winners, List<Match> schedule) {
//   int numTeams = teams.length;
//   int totalmatches = numTeams;

//   List<Team> copy = List.from(teams);

//   for (int round = 0; round < totalmatches; round++) {
//     for (int match = 0; match < totalmatches; match++) {
//       if (match <= round) {
//         continue;
//       }
//       schedule.add(Match(
//           homeTeam: copy[round], awayTeam: copy[match], winner: Team("null")));
//       winners.add(Team("winner null"));
//     }
//   }
// }

// void generateRoundRobinScheduleWin(
//     List<Match> schedule, List<Team> teams, Map<int, Team> a) {
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
//     if (match.winner!.name == "null" ||
//         checkIfHaveWinner(match.winner) == true) {
//       continue;
//     }
//     if (map.containsKey(match.winner) == false) {
//       map[match.winner!] = 0;
//     }
//     map[match.winner!] = (map[match.winner!]! + 1);
//     a[match.hashCode] = match.winner!;
//   }
//   if (a.length == schedule.length) {
//     List<TopG> top = [];
//     for (Team team in teams) {
//       if (map.containsKey(team) == false) continue;
//       top.add(new TopG(winner: team, winCount: map[team]!));
//     }
//     top.sort(((a, b) => (b.winCount.compareTo(a.winCount))));

//     print("GG");
//   }
// }

// bool checkIfHaveWinner(Team? a) {
//   bool c = false;
//   if (a!.name.contains("winner ")) {
//     c = true;
//   }
//   return c;
// }

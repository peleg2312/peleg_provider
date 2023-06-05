import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_complete_guide/model/match.dart';
import 'package:flutter_complete_guide/model/team.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:flutter_complete_guide/provider/favorite_tournament_provider.dart';
import 'package:flutter_complete_guide/provider/match_provider.dart';
import 'package:flutter_complete_guide/provider/team_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final Tournament tournament;

  const DetailPage({Key? key, required this.tournament})
      : super(
          key: key,
        );

  @override
  State<DetailPage> createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool liked = false;
  List<Team> teams = [];
  List<GameMatch> schedule = [];

  @override
  void didChangeDependencies() {
    schedule = Provider.of<MatchProvider>(context).getMatchForTournment(widget.tournament.Id);
    teams = Provider.of<TeamProvider>(context, listen: false).Teams;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    liked = widget.tournament.favorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 60, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.red),
                    height: 30,
                    width: 80,
                    //margin: new EdgeInsets.only(left: 15.0, top: 60.0),
                    child: TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 15,
                          color: Colors.white,
                        ),
                        label: Text(
                          "BACK",
                          style: TextStyle(color: Colors.white),
                        ))),
                IconButton(
                  onPressed: (() async {
                    Provider.of<FavoriteTournamentProvider>(context, listen: false)
                        .FavoriteTournament(widget.tournament);
                    setState(() {
                      liked = !liked;
                    });
                  }),
                  icon: !liked
                      ? Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite,
                          color: Colors.red,
                          shadows: [Shadow(blurRadius: 7)],
                        ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 17.0, top: 20),
            child: Row(
              children: [
                Text(
                  widget.tournament.name.toUpperCase(),
                  style: TextStyle(fontSize: 25, color: Colors.red, fontWeight: FontWeight.w500),
                ),
                Text(
                  " Tournament Detail",
                  style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 17.0, top: 5),
            child: Text(
              "You can view the tournament progress",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          Container(
            height: 600,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: schedule.length,
              itemBuilder: (context, index) {
                final match = schedule[index];
                Team homeTeam;
                Team awayTeam;
                if (match.awayTeamId == "id") {
                  homeTeam = Team(name: "Bye", id: "id", tId: "tId", userId: "userId", gamePlayed: 0);
                } else {
                  homeTeam = teams.firstWhere(((element) => element.id == match.homeTeamId));
                }
                if (match.awayTeamId == "id") {
                  awayTeam = Team(name: "Bye", id: "id", tId: "tId", userId: "userId", gamePlayed: 0);
                } else {
                  awayTeam = teams.firstWhere(((element) => element.id == match.awayTeamId));
                }
                return ListTile(
                  title: Text(
                    'Match ${index + 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text('${homeTeam.name ?? 'TBD'} vs ${awayTeam.name ?? 'TBD'}',
                      style: TextStyle(color: Colors.white60)),
                  trailing: match.winnerId == null
                      ? Text('No Winner Yet')
                      : Text(Provider.of<TeamProvider>(context, listen: false).findTeam(match.winnerId).name),
                );
              },
            ),
          ),
        ])));
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(left: 10.0, top: 40.0),
      child: Row(
        children: [
          new BackButton(color: Colors.black),
          SizedBox(
            width: 10,
          ),
          Text(
            widget.tournament.name,
            style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

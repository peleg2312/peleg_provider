import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/components/IconList.dart';
import 'package:flutter_complete_guide/model/element.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:flutter_complete_guide/provider/favorite_tournament_provider.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:flutter_complete_guide/screens/likes_tournament.dart';
import 'package:flutter_complete_guide/screens/page_addtourna.dart';
import 'package:flutter_complete_guide/screens/score_board.dart';
import 'package:flutter_complete_guide/screens/tournament_detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../model/tournament.dart';
import 'package:fl_chart/fl_chart.dart';

class TournamentPage extends StatefulWidget {
  final auth = FirebaseAuth.instance;
  //final UserCredential user;

  //TaskPage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TournamentPageState();
}

class _TournamentPageState extends State<TournamentPage>
    with SingleTickerProviderStateMixin {
  int index = 1;
  bool liked = false;
  late TextEditingController searchBar = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<String>? SlikedTournament =
        Provider.of<FavoriteTournamentProvider>(context).FavoriteTournaments;
    List<Tournament>? tournaments =
        Provider.of<TournamentProvider>(context).Tournaments;
    List<Tournament>? likedTournament =
        SortLikedTournament(SlikedTournament, tournaments);
    SetFavorite(likedTournament, tournaments);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.all(10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.deepPurple,
            onPressed: _addTaskPressed,
            label: Text(
              "Add Tournament",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            splashColor: Color.fromARGB(255, 88, 198, 206),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Tournament',
                              style: new TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            Text(
                              'Lists',
                              style: new TextStyle(
                                  fontSize: 28.0, color: Colors.white70),
                            )
                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: TextField(
                controller: searchBar,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchBar.text = "";
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Container(
                height: 400,
                padding: EdgeInsets.only(bottom: 25.0),
                child: ListView.builder(
                    itemCount: tournaments.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromRGBO(87, 95, 113, 1)),
                              height: 70,
                              child: Center(
                                child: ListTile(
                                  key: new Key(index.toString()),
                                  subtitle:
                                      tournaments![index].isStarted == false
                                          ? Text("in registration")
                                          : Text("in progress"),
                                  leading: IconsList[tournaments[index].icon],
                                  title: Text(
                                    tournaments[index].name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                  trailing: IconButton(
                                    icon: !tournaments[index].favorite
                                        ? Icon(Icons.favorite_border)
                                        : Icon(
                                            Icons.favorite,
                                            color: Colors.deepPurple,
                                            shadows: [Shadow(blurRadius: 7)],
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        Provider.of<FavoriteTournamentProvider>(
                                                context,
                                                listen: false)
                                            .FavoriteTournament(
                                                tournaments[index]);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                        onTap: () => _DetailPressed(tournaments[index]),
                      );
                    })),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _addTaskPressed() async {
    Navigator.of(context).push(
      new PageRouteBuilder(
        pageBuilder: (_, __, ___) => new NewTournamentPage(
            //user: widget.user,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            new ScaleTransition(
          scale: new Tween<double>(
            begin: 1.5,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.50,
                1.00,
                curve: Curves.linear,
              ),
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.00,
                  0.50,
                  curve: Curves.linear,
                ),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
    //Navigator.of(context).pushNamed('/new');
  }

  void _DetailPressed(Tournament tournament) async {
    Navigator.of(context).push(
      new PageRouteBuilder(
        pageBuilder: (_, __, ___) => new DetailPage(
          tournament: tournament,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            new ScaleTransition(
          scale: new Tween<double>(
            begin: 1.5,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.50,
                1.00,
                curve: Curves.linear,
              ),
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.00,
                  0.50,
                  curve: Curves.linear,
                ),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
    //Navigator.of(context).pushNamed('/new');
  }

  List<Tournament> SortLikedTournament(
      List<String> likedTournament, List<Tournament> tournaments) {
    List<Tournament> liked = <Tournament>[];

    for (var tournament in tournaments) {
      for (var item in likedTournament) {
        if (tournament.Id == item) {
          liked.add(tournament);
        }
      }
    }
    return liked;
  }

  void SetFavorite(
      List<Tournament> likedTournament, List<Tournament> tournaments) {
    for (var ftournament in likedTournament) {
      for (var tournament in tournaments) {
        if (ftournament.name == tournament.name) {
          tournament.SetFavorite(true);
        }
      }
    }
  }
}

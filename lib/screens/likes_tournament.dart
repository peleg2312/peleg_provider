import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_complete_guide/components/IconList.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:flutter_complete_guide/provider/favorite_tournament_provider.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class LikedTournament extends StatefulWidget {
  const LikedTournament({Key? key}) : super(key: key);

  @override
  State<LikedTournament> createState() => _LikedTournamentState();
}

class _LikedTournamentState extends State<LikedTournament> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<String>? SlikedTournament =
        Provider.of<FavoriteTournamentProvider>(context).FavoriteTournaments;
    List<Tournament>? tournaments =
        Provider.of<TournamentProvider>(context).Tournaments;
    List<Tournament>? likedTournament =
        SortLikedTournament(SlikedTournament, tournaments);
    return Scaffold(
        key: _scaffoldKey,
        body: ModalProgressHUD(
          inAsyncCall: false,
          child: Column(children: [
            Container(
              child: Column(
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
                                  'Liked',
                                  style: new TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                Text(
                                  'Tournament',
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
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Container(
                  height: 400,
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: ListView.builder(
                      itemCount: likedTournament?.length,
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
                                    leading:
                                        IconsList[likedTournament[index].icon],
                                    title: Text(
                                      likedTournament![index].name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
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
                                                  likedTournament[index]);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          //onTap: () => _DetailPressed(tournaments[index]),
                        );
                      })),
            ),
          ]),
        ));
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
}

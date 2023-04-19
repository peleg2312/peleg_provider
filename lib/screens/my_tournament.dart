import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_complete_guide/components/IconList.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:flutter_complete_guide/provider/favorite_tournament_provider.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:flutter_complete_guide/screens/edit_tournament.dart';
import 'package:flutter_complete_guide/screens/page_addtourna.dart';
import 'package:flutter_complete_guide/screens/tournament_detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class MyTournamnt extends StatefulWidget {
  @override
  State<MyTournamnt> createState() => _MyTournamntState();
}

class _MyTournamntState extends State<MyTournamnt> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<Tournament>? tournaments =
        Provider.of<TournamentProvider>(context).Tournaments;
    List<Tournament>? myTournament = AdminTournament(tournaments);
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
                            flex: 3,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'My',
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
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: myTournament.length == 0
                        ? Padding(
                            padding: EdgeInsets.only(top: 150),
                            child: Column(
                              children: [
                                Container(
                                  child: Text("You dont have any tournament",
                                      style: new TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(221, 19, 19, 19))),
                                ),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: FloatingActionButton.extended(
                                    backgroundColor:
                                        Color.fromARGB(255, 82, 82, 82),
                                    onPressed: _addTaskPressed,
                                    label: Text(
                                      "Add Tournament",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    splashColor:
                                        Color.fromARGB(255, 88, 198, 206),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: 400,
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: ListView.builder(
                                itemCount: myTournament.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    child: Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color.fromRGBO(
                                                  87, 95, 113, 1)),
                                          height: 70,
                                          child: Center(
                                            child: ListTile(
                                              leading: IconsList[
                                                  myTournament[index].icon],
                                              title: Text(
                                                myTournament[index].name,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20),
                                              ),
                                              trailing: IconButton(
                                                icon:
                                                    Icon(FontAwesomeIcons.edit),
                                                onPressed: () {
                                                  setState(() {
                                                    _UpdatePressed(
                                                        myTournament[index]);
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                    onTap: () =>
                                        _DetailPressed(myTournament[index]),
                                  );
                                })),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }

  List<Tournament> AdminTournament(List<Tournament> tournaments) {
    User? authResult = FirebaseAuth.instance.currentUser;
    List<Tournament> myTournament = <Tournament>[];

    for (var tournament in tournaments) {
      if (tournament.Admin == authResult!.uid) {
        myTournament.add(tournament);
      }
      ;
    }
    return myTournament;
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

  void _UpdatePressed(Tournament tournament) async {
    Navigator.of(context).push(
      new PageRouteBuilder(
        pageBuilder: (_, __, ___) => new EditTournament(
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
}

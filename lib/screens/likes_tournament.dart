import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LikedTournament extends StatefulWidget {
  const LikedTournament({Key? key}) : super(key: key);

  @override
  State<LikedTournament> createState() => _LikedTournamentState();
}

class _LikedTournamentState extends State<LikedTournament> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
          ]),
        ));
  }
}

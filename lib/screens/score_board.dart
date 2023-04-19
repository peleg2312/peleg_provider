import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/model/element.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScoreBoard extends StatefulWidget {
  //final UserCredential user;
  final auth = FirebaseAuth.instance;
  //DonePage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard>
    with SingleTickerProviderStateMixin {
  int TeamAScore = 0;
  int TeamBScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          new Column(
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
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Score',
                              style: new TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            Text(
                              'Board',
                              style: new TextStyle(
                                  fontSize: 28.0, color: Colors.white70),
                            ),
                            IconButton(
                                onPressed: restartScore,
                                icon: Icon(FontAwesomeIcons.trashRestoreAlt))
                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 50.0)),
              Column(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Text("Team A",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w600)),
                        Padding(padding: EdgeInsets.only(top: 40)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                    onPressed: (() {
                                      setState(() {
                                        TeamAScore++;
                                      });
                                    }),
                                    icon: Icon(FontAwesomeIcons.add))),
                            Text(TeamAScore.toString(),
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.w600)),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                    onPressed: (() {
                                      setState(() {
                                        if (TeamAScore > 0) TeamAScore--;
                                      });
                                    }),
                                    icon: Icon(FontAwesomeIcons.minus))),
                          ],
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    height: 220,
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Text(
                          "Team B",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w600),
                        ),
                        Padding(padding: EdgeInsets.only(top: 40)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                    onPressed: (() {
                                      setState(() {
                                        TeamBScore++;
                                      });
                                    }),
                                    icon: Icon(FontAwesomeIcons.add))),
                            Text(TeamBScore.toString(),
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.w600)),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                    onPressed: (() {
                                      setState(() {
                                        if (TeamBScore > 0) TeamBScore--;
                                      });
                                    }),
                                    icon: Icon(FontAwesomeIcons.minus))),
                          ],
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                    ),
                    height: 220,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void restartScore() {
    setState(() {
      TeamAScore = 0;
      TeamBScore = 0;
    });
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
//}
}

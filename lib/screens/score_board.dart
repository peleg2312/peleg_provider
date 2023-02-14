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
                        flex: 2,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Score',
                              style: new TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Board',
                              style: new TextStyle(
                                  fontSize: 28.0, color: Colors.grey),
                            )
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
              Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Text("Team A",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.w600)),
                          Padding(padding: EdgeInsets.only(top: 15)),
                          Text(TeamAScore.toString(),
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15)),
                      height: 150,
                    ),
                  ),
                  Expanded(
                      child: Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Text(
                          "Team B",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w600),
                        ),
                        Padding(padding: EdgeInsets.only(top: 15)),
                        Text(
                          TeamBScore.toString(),
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(15)),
                    height: 150,
                  ))
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 3)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueAccent, shape: BoxShape.circle),
                        child: IconButton(
                            onPressed: (() {
                              setState(() {
                                TeamAScore++;
                              });
                            }),
                            icon: Icon(Icons.add))),
                  ),
                  SizedBox(
                    width: 120,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.redAccent, shape: BoxShape.circle),
                        child: IconButton(
                            onPressed: (() {
                              setState(() {
                                TeamBScore++;
                              });
                            }),
                            icon: Icon(Icons.add))),
                  )
                ],
              )
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

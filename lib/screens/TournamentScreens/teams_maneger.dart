import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/match_provider.dart';
import 'package:flutter_complete_guide/provider/team_provider.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class TeamsManeger extends StatefulWidget {
  final TextEditingController tournamentNameController;
  final int IconPicker;
  final String tId;
  TeamsManeger(this.tournamentNameController, this.IconPicker, this.tId);

  @override
  State<TeamsManeger> createState() => _TeamsManegerState();
}

class _TeamsManegerState extends State<TeamsManeger> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> teams = <String>[];
  TextEditingController listNameController = new TextEditingController();
  String tournamentType = "roundrobin";
  String _dropDownValue = "Points";

  //input: context
  //output: create new screen that lets you to add team and choose the tournamentType and create the matches for you base on the type
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.all(0),
          width: 200,
          height: 100,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    listNameController.text = "";
                    _showDialog();
                  },
                  label: Text(
                    "Add",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  splashColor: Color.fromARGB(255, 88, 198, 206),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.red,
                  onPressed: () async {
                    await Provider.of<TournamentProvider>(context, listen: false)
                        .updateTornamentType(tournamentType, widget.tId);
                    if (tournamentType == "knockout") {
                      Provider.of<MatchProvider>(context, listen: false).createKnockOutSchedule(widget.tId, context);
                    } else {
                      Provider.of<MatchProvider>(context, listen: false).createRoundRobinSchedule(widget.tId, context);
                    }

                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                    setState(() {});
                  },
                  label: Text(
                    "Finish",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  splashColor: Color.fromARGB(255, 88, 198, 206),
                ),
              ),
            ],
          ),
        ),
      ),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.red),
                height: 30,
                width: 80,
                margin: new EdgeInsets.only(left: 15.0, top: 60.0),
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
            Padding(
              padding: const EdgeInsets.only(left: 17.0, top: 20),
              child: Text(
                "Manage Your Tournament",
                style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17.0, top: 5),
              child: Text(
                "Please choose your preferonce and add teams",
                style: TextStyle(color: Colors.white54),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ButtonStyle(),
                            onPressed: (() {
                              showModalBottomSheet(
                                  backgroundColor: Color.fromARGB(255, 36, 40, 51),
                                  context: context,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  builder: (BuildContext context) {
                                    return Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 100,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: TextButton(
                                                        onPressed: (() {
                                                          setState(() {
                                                            tournamentType = "roundrobin";
                                                          });
                                                          Navigator.of(context).pop();
                                                        }),
                                                        child: Text(
                                                          "Round Robin",
                                                          style: TextStyle(
                                                              color: tournamentType == "Round Robin"
                                                                  ? Colors.red
                                                                  : Colors.blue),
                                                        ),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '''Tournament where all teams play agains each other. All teams play the same number of matches.''',
                                                    maxLines: null,
                                                    style: TextStyle(fontSize: 12, color: Colors.white54),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 100,
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: TextButton(
                                                        onPressed: (() {
                                                          setState(() {
                                                            tournamentType = "knockout";
                                                          });
                                                          Navigator.of(context).pop();
                                                        }),
                                                        child: Text(
                                                          "Knock out",
                                                          style: TextStyle(
                                                              color: tournamentType == "Knock out"
                                                                  ? Colors.red
                                                                  : Colors.blue),
                                                        )),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '''Tournament where the loser of each match is sent out of the tournament and the winning team continues.''',
                                                    maxLines: null,
                                                    style: TextStyle(fontSize: 12, color: Colors.white54),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            }),
                            child: Text("Tournament Type")),
                      ),
                    ],
                  ),
                  Container(
                    height: 450,
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Teams:",
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        ),
                      ),
                      teams.isEmpty == true
                          ? Align(
                              alignment: Alignment.center,
                              child: Container(
                                  child: Text(
                                "You didnt add any team yet",
                                style: TextStyle(fontSize: 20, color: Colors.white54),
                              )))
                          : ListView.builder(
                              itemCount: teams.length,
                              itemBuilder: (context, index) {
                                return Stack(children: [
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
                                          title: Text(
                                            teams[index],
                                            style: TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]);
                              }),
                    ]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //output: new Container with back button
  Container _getToolbar() {
    return new Container(
      margin: new EdgeInsets.only(left: 10.0, top: 40.0),
      child: Row(
        children: [
          new BackButton(color: Colors.black),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  //output: new dialog that let you choose the team name and add new Team to the local list and Firebase
  void _showDialog() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 36, 40, 51),
            title: Text(
              "Team Name",
              style: TextStyle(color: Colors.white54),
            ),
            content: new TextFormField(
              cursorColor: Colors.red,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
                  //labelText: "Team name",
                  contentPadding: EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 5.0)),
              controller: listNameController,
              autofocus: true,
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 15,
            ),
            actions: [
              TextButton(
                  onPressed: (() {
                    setState(() {
                      if (listNameController.text == null ||
                          listNameController.text.isEmpty ||
                          listNameController.text == "") {
                        showInSnackBar("Enter Valid Name", context, Colors.red);
                        return;
                      }
                      teams.add(listNameController.text);
                      Provider.of<TeamProvider>(context, listen: false)
                          .addTeamToFireBase(context, listNameController, widget.tId);
                      Navigator.of(context).pop();
                    });
                  }),
                  child: Text(
                    "Add Team",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        }));
  }

  //input: value, context, color
  //output: make visual SnackBar with error message
  void showInSnackBar(String value, BuildContext context, Color color) {
    ScaffoldMessenger.of(context)?.removeCurrentSnackBar();

    ScaffoldMessenger.of(context)?.showSnackBar(new SnackBar(
      content: new Text(value, textAlign: TextAlign.center),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }
}

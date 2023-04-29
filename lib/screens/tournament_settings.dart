import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/components/IconList.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class TournamentSettings extends StatefulWidget {
  @override
  State<TournamentSettings> createState() => _TournamentSettingsState();
}

class _TournamentSettingsState extends State<TournamentSettings> {
  TextEditingController listNameController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late String Tournament_type;
  late int IconPicker;
  late ValueChanged<Color> onColorChanged;
  bool IsDone = false;
  bool _saving = false;
  int selectedCard = -1;
  late String _dropDownValue;
  late String _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
          child: new Stack(
            children: <Widget>[
              _getToolbar(context),
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 100.0),
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
                                    'New',
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
                      padding:
                          EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                      child: new Column(
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: (() {
                                showModalBottomSheet(
                                    backgroundColor:
                                        Color.fromARGB(255, 36, 40, 51),
                                    context: context,
                                    shape: RoundedRectangleBorder(),
                                    builder: (BuildContext context) {
                                      return Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: TextButton(
                                                          onPressed: (() {
                                                            (() {
                                                              Tournament_type =
                                                                  "Round Robin";
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }),
                                                          child: Text(
                                                              "Round Robin")),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '''Tournament where all teams play agains each other. All teams play the same number of matches.''',
                                                      maxLines: null,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: TextButton(
                                                          onPressed: (() {
                                                            (() {
                                                              Tournament_type =
                                                                  "Knock out";
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }),
                                                          child: Text(
                                                              "Knock out")),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '''Tournament where the loser of each match is sent out of the tournament and the winning team continues.''',
                                                      maxLines: null,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    child: TextButton(
                                                        onPressed: (() {
                                                          (() {
                                                            Tournament_type =
                                                                "Groups with play off";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        }),
                                                        child: Text(
                                                            "Groups with play off")),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '''Tournament where teams first play each other inside their group. the best placed teams then continue to play off.''',
                                                      maxLines: null,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              }),
                              child: Text("Tournament Type")),
                        ],
                      ),
                    ),
                    Column(children: [
                      Center(child: Text("Select Win Type")),
                      GridView.count(
                        crossAxisCount: 2,
                        children: [
                          Container(
                            color: _selectedType == "Points"
                                ? Color.fromARGB(255, 36, 40, 51)
                                : Colors.deepPurple,
                            child: TextButton(
                              child: Text("Points"),
                              onPressed: () {
                                setState(() {
                                  _selectedType = "Points";
                                });
                              },
                            ),
                            padding: EdgeInsets.all(20),
                          ),
                          Container(
                            color: _selectedType == "Time"
                                ? Color.fromARGB(255, 36, 40, 51)
                                : Colors.deepPurple,
                            child: TextButton(
                              child: Text("Time"),
                              onPressed: () {
                                setState(() {
                                  _selectedType = "Time";
                                });
                              },
                            ),
                            padding: EdgeInsets.all(20),
                          )
                        ],
                      ),
                    ]),
                    Container(
                        height: 150,
                        child: DropdownButton(
                          items: [
                            DropdownMenuItem(
                              child: Text("Points"),
                              value: "Points",
                            ),
                            DropdownMenuItem(
                              child: Text("Time"),
                              value: "Time",
                            )
                          ],
                          onChanged: dropDownCallback,
                          value: _dropDownValue,
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child: new Column(
                        children: <Widget>[
                          new ElevatedButton(
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                elevation: 4.0,
                                backgroundColor: Colors.deepPurple),
                            onPressed: () {
                              Provider.of<TournamentProvider>(context,
                                      listen: false)
                                  .addTournamentToFirebase(listNameController,
                                      IsDone, context, IconPicker);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          inAsyncCall: _saving),
    );
  }

  @override
  void dispose() {
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  void dropDownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropDownValue = selectedValue;
      });
    }
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(left: 10.0, top: 40.0),
      child: new BackButton(color: Colors.black),
    );
  }
}

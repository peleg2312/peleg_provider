import 'dart:async';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_complete_guide/components/IconList.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:flutter_complete_guide/provider/auth_provider.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class EditTournament extends StatefulWidget {
  final Tournament tournament;

  EditTournament({Key? key, required this.tournament}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditTournamentState();
}

class _EditTournamentState extends State<EditTournament> {
  @override
  TextEditingController listNameController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late int IconPicker;
  late ValueChanged<Color> onColorChanged;
  bool IsDone = false;
  bool _saving = false;
  int selectedCard = -1;

  @override
  void initState() {
    listNameController.text = widget.tournament.name;
    selectedCard = widget.tournament.icon;
    IconPicker = widget.tournament.icon;
    super.initState();
  }

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
                                    'Edit',
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
                          new TextFormField(
                            decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color:
                                            Color.fromARGB(255, 17, 106, 97))),
                                labelText: "Tournament name",
                                contentPadding: EdgeInsets.only(
                                    left: 16.0,
                                    top: 20.0,
                                    right: 16.0,
                                    bottom: 5.0)),
                            controller: listNameController,
                            autofocus: false,
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            maxLength: 20,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                          shrinkWrap: false,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemCount: IconsList.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80)),
                                color: selectedCard == index
                                    ? Color.fromARGB(255, 58, 108, 183)
                                    : Colors.deepPurple,
                                child: IconButton(
                                    iconSize: 50,
                                    alignment: Alignment.center,
                                    icon: IconsList[index]!,
                                    color: Color.fromARGB(255, 164, 164, 164),
                                    onPressed: (() {
                                      setState(() => IconPicker = index);
                                      selectedCard = index;
                                    })),
                              ),
                            );
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new Column(
                        children: <Widget>[
                          new ElevatedButton(
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                elevation: 4.0,
                                backgroundColor: Colors.deepPurple),
                            onPressed: () {
                              Provider.of<TournamentProvider>(context,
                                      listen: false)
                                  .updateTournamentToFirebase(
                                      listNameController,
                                      IsDone,
                                      context,
                                      IconPicker,
                                      widget.tournament);
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

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(left: 10.0, top: 40.0),
      child: new BackButton(color: Colors.black),
    );
  }
}

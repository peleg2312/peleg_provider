import 'dart:async';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_complete_guide/provider/auth_provider.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class NewTournamentPage extends StatefulWidget {
  NewTournamentPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewTournamentPageState();
}

class _NewTournamentPageState extends State<NewTournamentPage> {
  @override
  TextEditingController listNameController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late Icon IconPicker;
  late ValueChanged<Color> onColorChanged;
  bool IsDone = false;
  bool _saving = false;
  int selectedCard = -1;
  List<Icon> Iname = [
    Icon(Icons.sports_basketball),
    Icon(Icons.sports_baseball),
    Icon(Icons.sports_volleyball),
    Icon(Icons.sports_football),
    Icon(Icons.sports_soccer)
  ];

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
                            autofocus: true,
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
                          itemCount: Iname.length,
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
                                    icon: Iname[index],
                                    color: Color.fromARGB(255, 164, 164, 164),
                                    onPressed: (() {
                                      setState(() => IconPicker = Iname[index]);
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
                                  .addTournamentToFirebase(
                                      listNameController, IsDone, context);
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

  ChangeIconPicker(Icon icon) {
    setState(() => IconPicker = icon);
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

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
import 'package:flutter_complete_guide/screens/TournamentSettings/teams_maneger.dart';
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
  bool isStarted = false;

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
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 10.0, left: 40.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              width: 250,
              height: 50,
              child: TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white70),
                  fillColor: Color.fromARGB(139, 135, 127, 127),
                  filled: true,
                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30)),
                  hintText: 'Enter Name',
                  hintStyle: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                controller: listNameController,
                validator: (value) {
                  return (value == null) ? 'Enter Text' : null;
                },
              ),
            ),
            Container(
                height: 50,
                width: 50,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50), color: Color.fromARGB(255, 193, 67, 75)),
                child: IconButton(
                    color: Colors.white70,
                    onPressed: () {
                      //_TeamManeger();
                    },
                    icon: Icon(Icons.arrow_forward)))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            child: Row(
              children: [
                Text(
                  widget.tournament.name.toUpperCase(),
                  style: TextStyle(fontSize: 25, color: Colors.red, fontWeight: FontWeight.w500),
                ),
                Text(
                  " Tournament Edit",
                  style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 17.0, top: 5),
            child: Text(
              "Please choose your preferonce",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          Container(
            height: 500,
            child: Align(
              alignment: Alignment.topCenter,
              child: GridView.builder(
                  padding: const EdgeInsets.only(top: 4, right: 15.0, left: 15, bottom: 10),
                  shrinkWrap: false,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: IconsList.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: selectedCard == index
                              ? Color.fromARGB(255, 183, 73, 73)
                              : Color.fromARGB(48, 131, 131, 131),
                        ),
                        child: IconButton(
                            padding: const EdgeInsets.all(0.0),
                            iconSize: 30,
                            alignment: Alignment.center,
                            icon: IconsList[index]!,
                            color: Colors.white70,
                            onPressed: (() {
                              setState(() => IconPicker = index);
                              selectedCard = index;
                            })),
                      ),
                    );
                  }),
            ),
          ),
        ]),
      ),
    );
    // return Scaffold(
    //   key: _scaffoldKey,
    //   body: ModalProgressHUD(
    //       child: new Stack(
    //         children: <Widget>[
    //           _getToolbar(context),
    //           Container(
    //             child: Column(
    //               children: <Widget>[
    //                 Padding(
    //                   padding: EdgeInsets.only(top: 100.0),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: <Widget>[
    //                       Expanded(
    //                         flex: 1,
    //                         child: Container(
    //                           color: Colors.white,
    //                           height: 1.5,
    //                         ),
    //                       ),
    //                       Expanded(
    //                           flex: 4,
    //                           child: new Row(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: <Widget>[
    //                               Text(
    //                                 'Edit',
    //                                 style: new TextStyle(
    //                                     fontSize: 30.0,
    //                                     fontWeight: FontWeight.bold,
    //                                     color: Colors.grey),
    //                               ),
    //                               Text(
    //                                 'Tournament',
    //                                 style: new TextStyle(
    //                                     fontSize: 28.0, color: Colors.white70),
    //                               )
    //                             ],
    //                           )),
    //                       Expanded(
    //                         flex: 1,
    //                         child: Container(
    //                           color: Colors.white,
    //                           height: 1.5,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding:
    //                       EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
    //                   child: new Column(
    //                     children: <Widget>[
    //                       new TextFormField(
    //                         decoration: InputDecoration(
    //                             border: new OutlineInputBorder(
    //                                 borderSide: new BorderSide(
    //                                     color:
    //                                         Color.fromARGB(255, 17, 106, 97))),
    //                             labelText: "Tournament name",
    //                             contentPadding: EdgeInsets.only(
    //                                 left: 16.0,
    //                                 top: 20.0,
    //                                 right: 16.0,
    //                                 bottom: 5.0)),
    //                         controller: listNameController,
    //                         autofocus: false,
    //                         style: TextStyle(
    //                           fontSize: 22.0,
    //                           color: Colors.black,
    //                           fontWeight: FontWeight.w500,
    //                         ),
    //                         keyboardType: TextInputType.text,
    //                         textCapitalization: TextCapitalization.sentences,
    //                         maxLength: 20,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 Expanded(
    //                   child: GridView.builder(
    //                       shrinkWrap: false,
    //                       gridDelegate:
    //                           const SliverGridDelegateWithFixedCrossAxisCount(
    //                               crossAxisCount: 3),
    //                       itemCount: IconsList.length,
    //                       itemBuilder: (BuildContext ctx, index) {
    //                         return Padding(
    //                           padding: const EdgeInsets.all(8.0),
    //                           child: Card(
    //                             shape: RoundedRectangleBorder(
    //                                 borderRadius: BorderRadius.circular(80)),
    //                             color: selectedCard == index
    //                                 ? Color.fromARGB(255, 58, 108, 183)
    //                                 : Colors.deepPurple,
    //                             child: IconButton(
    //                                 iconSize: 50,
    //                                 alignment: Alignment.center,
    //                                 icon: IconsList[index]!,
    //                                 color: Color.fromARGB(255, 164, 164, 164),
    //                                 onPressed: (() {
    //                                   setState(() => IconPicker = index);
    //                                   selectedCard = index;
    //                                 })),
    //                           ),
    //                         );
    //                       }),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.only(top: 20.0),
    //                   child: new Column(
    //                     children: <Widget>[
    //                       new ElevatedButton(
    //                         child: const Text(
    //                           'Save',
    //                           style: TextStyle(color: Colors.white),
    //                         ),
    //                         style: ElevatedButton.styleFrom(
    //                             primary: Colors.blue,
    //                             elevation: 4.0,
    //                             backgroundColor: Colors.deepPurple),
    //                         onPressed: () {
    //                           Provider.of<TournamentProvider>(context,
    //                                   listen: false)
    //                               .updateTournamentToFirebase(
    //                                   listNameController,
    //                                   IsDone,
    //                                   context,
    //                                   IconPicker,
    //                                   widget.tournament,
    //                                   isStarted);
    //                         },
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //       inAsyncCall: _saving),
    // );
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

  // void _TeamManeger() async {
  //   Navigator.of(context).push(
  //     new PageRouteBuilder(
  //       pageBuilder: (_, __, ___) =>
  //           new TeamsManeger(listNameController, IconPicker),
  //       transitionsBuilder: (context, animation, secondaryAnimation, child) =>
  //           new ScaleTransition(
  //         scale: new Tween<double>(
  //           begin: 1.5,
  //           end: 1.0,
  //         ).animate(
  //           CurvedAnimation(
  //             parent: animation,
  //             curve: Interval(
  //               0.50,
  //               1.00,
  //               curve: Curves.linear,
  //             ),
  //           ),
  //         ),
  //         child: ScaleTransition(
  //           scale: Tween<double>(
  //             begin: 0.0,
  //             end: 1.0,
  //           ).animate(
  //             CurvedAnimation(
  //               parent: animation,
  //               curve: Interval(
  //                 0.00,
  //                 0.50,
  //                 curve: Curves.linear,
  //               ),
  //             ),
  //           ),
  //           child: child,
  //         ),
  //       ),
  //     ),
  //   );
  //   //Navigator.of(context).pushNamed('/new');
  // }
}

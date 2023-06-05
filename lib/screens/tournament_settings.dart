import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_complete_guide/components/IconList.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:flutter_complete_guide/screens/TournamentSettings/teams_maneger.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class TournamentSettings extends StatefulWidget {
  @override
  State<TournamentSettings> createState() => _TournamentSettingsState();
}

class _TournamentSettingsState extends State<TournamentSettings> {
  TextEditingController listNameController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late int IconPicker;
  late ValueChanged<Color> onColorChanged;
  bool IsDone = false;
  bool _saving = false;
  int selectedCard = -1;
  String _dropDownValue = "Points";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.all(10),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute<void>(
            //     builder: (BuildContext context) => (),
            //   ),
            // );
            // Provider.of<TournamentProvider>(context, listen: false)
            //     .addTournamentToFirebase(
            //         listNameController, IsDone, context, IconPicker);
          },
          label: Text(
            "Add",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          splashColor: Color.fromARGB(255, 88, 198, 206),
        ),
      ),
      key: _scaffoldKey,
      body: ModalProgressHUD(
          child: Container(
            width: 400,
            child: new Stack(
              children: <Widget>[
                _getToolbar(context),
                SingleChildScrollView(
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
                                          fontSize: 28.0,
                                          color: Colors.white70),
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
                                          color: Color.fromARGB(
                                              255, 17, 106, 97))),
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
                      Container(
                        height: 120,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: GridView.builder(
                              shrinkWrap: false,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5),
                              itemCount: IconsList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80)),
                                    color: selectedCard == index
                                        ? Color.fromARGB(255, 58, 108, 183)
                                        : Colors.deepPurple,
                                    child: IconButton(
                                        iconSize: 30,
                                        alignment: Alignment.center,
                                        icon: IconsList[index]!,
                                        color:
                                            Color.fromARGB(255, 164, 164, 164),
                                        onPressed: (() {
                                          setState(() => IconPicker = index);
                                          selectedCard = index;
                                        })),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          inAsyncCall: _saving),
    );
  }

  @override
  void dispose() {
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  void _validation() {}

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(left: 10.0, top: 40.0),
      child: new BackButton(color: Colors.black),
    );
  }
}

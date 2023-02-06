import 'dart:async';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_complete_guide/provider/auth_provider.dart';

import 'package:connectivity/connectivity.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class NewTaskListPage extends StatefulWidget {
  NewTaskListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewTaskListPageState();
}

class _NewTaskListPageState extends State<NewTaskListPage> {
  @override
  TextEditingController listNameController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Color pickerColor = Color.fromARGB(255, 51, 248, 255);
  Color currentColor = Color(0xff6633ff);

  late ValueChanged<Color> onColorChanged;

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEFF5),
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
                                    'New',
                                    style: new TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'List',
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
                                labelText: "List name",
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
                          new Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                          ),
                          ButtonTheme(
                            minWidth: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                pickerColor = currentColor;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Pick a color!'),
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: pickerColor,
                                          onColorChanged: changeColor,
                                          showLabel: true,
                                          colorPickerWidth: 1000.0,
                                          pickerAreaHeightPercent: 0.7,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Got it'),
                                          onPressed: () {
                                            setState(() =>
                                                currentColor = pickerColor);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Card color'),
                              style: ElevatedButton.styleFrom(
                                  elevation: 3,
                                  primary: currentColor,
                                  foregroundColor: const Color(0xffffffff)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50.0),
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
                              Provider.of<AuthProvider>(context, listen: false)
                                  .addListToFirebase(currentColor,
                                      listNameController, context);
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

  changeColor(Color color) {
    setState(() => pickerColor = color);
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

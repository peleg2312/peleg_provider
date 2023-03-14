import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, Tournament? tournament}) : super(key: key);

  @override
  State<DetailPage> createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
          inAsyncCall: false,
          child: new Stack(children: <Widget>[
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
                                  'Tournament',
                                  style: new TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                Text(
                                  'Detail',
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
            )
          ])),
    );
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(left: 10.0, top: 40.0),
      child: new BackButton(color: Colors.black),
    );
  }
}

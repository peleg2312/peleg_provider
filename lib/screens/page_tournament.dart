import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/model/element.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:flutter_complete_guide/screens/page_addtourna.dart';
import 'package:flutter_complete_guide/screens/task_list/page_detail.dart';
import 'package:flutter_complete_guide/screens/page_done.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../model/tournament.dart';
import 'package:fl_chart/fl_chart.dart';

class TournamentPage extends StatefulWidget {
  final auth = FirebaseAuth.instance;
  //final UserCredential user;

  //TaskPage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TournamentPageState();
}

class _TournamentPageState extends State<TournamentPage>
    with SingleTickerProviderStateMixin {
  int index = 1;
  @override
  Widget build(BuildContext context) {
    List<Tournament>? tournaments =
        Provider.of<TournamentProvider>(context).Tournaments;
    tournaments
        .add(Tournament(name: "Football", isDone: false, Admin: "12345"));
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.all(10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.deepPurple,
            onPressed: _addTaskPressed,
            label: Text(
              "Add Tournament",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            splashColor: Color.fromARGB(255, 88, 198, 206),
          ),
        ),
      ),
      backgroundColor: Color(0xFFEEEFF5),
      body: ListView(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
                            Text(
                              'Tournament',
                              style: new TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Lists',
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
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 70.0),
            child: Container(
                height: 360.0,
                padding: EdgeInsets.only(bottom: 25.0),
                child: ListView.builder(
                    itemCount: tournaments.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Card(
                          child: ListTile(
                            title: Text(tournaments[index].name),
                            trailing: Icon(FontAwesomeIcons.basketball),
                          ),
                        ),
                      );
                    })
                // ListView.builder(
                //     itemCount: tournaments.length,
                //     itemBuilder: (BuildContext ctx, index) {
                //       return Container(
                //         padding: EdgeInsets.all(5),
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //             color: Colors.lightBlue,
                //             borderRadius: BorderRadius.circular(15)),
                //         child: Column(children: [
                //           Text(
                //             tournaments[index].name,
                //             textAlign: TextAlign.start,
                //           ),
                //         ]),
                //       );
                //     })
                // child: NotificationListener<OverscrollIndicatorNotification>(
                //   onNotification: (overscroll) {
                //     overscroll.disallowGlow();
                //     return true;
                //   },
                // child: new StreamBuilder<QuerySnapshot>(
                //     stream: FirebaseFirestore.instance
                //         .collection(widget.auth.currentUser!.uid)
                //         .doc("TaskList")
                //         .collection("Tasks")
                //         .orderBy("date", descending: true)
                //         .snapshots(),
                //     builder: (BuildContext context,
                //         AsyncSnapshot<QuerySnapshot> snapshot) {
                //       if (!snapshot.hasData)
                //         return new Center(
                //             child: CircularProgressIndicator(
                //           backgroundColor: Colors.blue,
                //         ));
                //       return Column(
                //         children: [
                //           Expanded(
                //             child: new ListView(
                //               shrinkWrap: true,
                //               physics: const BouncingScrollPhysics(),
                //               padding: EdgeInsets.only(left: 40.0, right: 40.0),
                //               scrollDirection: Axis.horizontal,
                //               children: getExpenseItems(snapshot),
                //             ),
                //           ),
                //         ],
                //       );
                //     }),
                // ),
                ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ElementTask> listElement = [], listElement2;
    Map<String, List<ElementTask>> userMap = new Map();

    List<String> cardColor = [];

    if (widget.auth.currentUser!.uid.isNotEmpty) {
      cardColor.clear();

      snapshot.data!.docs.map<List>((f) {
        late String color;

        (f.data() as Map<String, dynamic>).forEach((a, b) {
          if (b.runtimeType == bool) {
            listElement.add(new ElementTask(a, b));
          }
          if (b.runtimeType == String && a == "color") {
            color = b;
          }
        });
        listElement2 = new List<ElementTask>.from(listElement);
        for (int i = 0; i < listElement2.length; i++) {
          if (listElement2.elementAt(i).isDone == false) {
            userMap[f.id] = listElement2;
            cardColor.add(color);
            break;
          }
        }
        if (listElement2.length == 0) {
          userMap[f.id] = listElement2;
          cardColor.add(color);
        }
        listElement.clear();
        return listElement2;
      }).toList();

      return new List.generate(userMap.length, (int index) {
        return new GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              new PageRouteBuilder(
                pageBuilder: (_, __, ___) => new DetailPage(
                  //user: widget.user,
                  i: index,
                  currentList: userMap,
                  color: cardColor.elementAt(index),
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        new ScaleTransition(
                  scale: new Tween<double>(
                    begin: 1.5,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Interval(
                        0.50,
                        1.00,
                        curve: Curves.linear,
                      ),
                    ),
                  ),
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Interval(
                          0.00,
                          0.50,
                          curve: Curves.linear,
                        ),
                      ),
                    ),
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            color: Color(int.parse(cardColor.elementAt(index))),
            child: new Container(
              width: 200.0,
              height: 400.0,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                      child: Container(
                        child: Text(
                          userMap.keys.elementAt(index),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.only(left: 50.0),
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 30.0, left: 15.0, right: 5.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 210.0,
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    userMap.values.elementAt(index).length,
                                itemBuilder: (BuildContext ctxt, int i) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        userMap.values
                                                .elementAt(index)
                                                .elementAt(i)
                                                .isDone
                                            ? FontAwesomeIcons.checkCircle
                                            : FontAwesomeIcons.circle,
                                        color: userMap.values
                                                .elementAt(index)
                                                .elementAt(i)
                                                .isDone
                                            ? Colors.white70
                                            : Colors.white,
                                        size: 14.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                      ),
                                      Flexible(
                                        child: Text(
                                          userMap.values
                                              .elementAt(index)
                                              .elementAt(i)
                                              .name,
                                          style: userMap.values
                                                  .elementAt(index)
                                                  .elementAt(i)
                                                  .isDone
                                              ? TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color: Colors.white70,
                                                  fontSize: 17.0,
                                                )
                                              : TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17.0,
                                                ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _addTaskPressed() async {
    Navigator.of(context).push(
      new PageRouteBuilder(
        pageBuilder: (_, __, ___) => new NewTournamentPage(
            //user: widget.user,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            new ScaleTransition(
          scale: new Tween<double>(
            begin: 1.5,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.50,
                1.00,
                curve: Curves.linear,
              ),
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.00,
                  0.50,
                  curve: Curves.linear,
                ),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
    //Navigator.of(context).pushNamed('/new');
  }

  void _doneListTask() async {
    Navigator.of(context).push(
      new PageRouteBuilder(
        pageBuilder: (_, __, ___) => new DonePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            new ScaleTransition(
          scale: new Tween<double>(
            begin: 1.5,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.50,
                1.00,
                curve: Curves.linear,
              ),
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.00,
                  0.50,
                  curve: Curves.linear,
                ),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
    //Navigator.of(context).pushNamed('/new');
  }
}

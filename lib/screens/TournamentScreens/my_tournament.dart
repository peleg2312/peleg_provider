import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_complete_guide/components/Icon_list.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:flutter_complete_guide/provider/favorite_tournament_provider.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:flutter_complete_guide/screens/TournamentScreens/tournament_detail.dart';
import 'package:flutter_complete_guide/screens/TournamentScreens/edit_tournament.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class MyTournament extends StatefulWidget {
  List<Tournament> myTournament;
  MyTournament(this.myTournament);

  @override
  State<MyTournament> createState() => _MyTournamentState();
}

class _MyTournamentState extends State<MyTournament> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Text(
          "Your Tournament",
          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 17.0, top: 5),
        child: Text(
          "Here are the tournament you created",
          style: TextStyle(color: Colors.white54),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 30.0),
        child: Container(
            height: 700,
            padding: EdgeInsets.only(bottom: 0.0),
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.myTournament?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            //color: Color(0xCC979797)
                          ),
                          height: 55,
                          child: Center(
                            child: ListTile(
                              leading: GetIcon(widget.myTournament[index].icon, Colors.red),
                              title: Text(
                                widget.myTournament[index].name,
                                style: TextStyle(color: Color(0xCC979797), fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.edit,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: ((context) =>
                                            EditTournament(tournament: widget.myTournament[index]))));
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => DetailPage(tournament: widget.myTournament[index])))),
                    ),
                  );
                })),
      ),
    ])));
  }
}
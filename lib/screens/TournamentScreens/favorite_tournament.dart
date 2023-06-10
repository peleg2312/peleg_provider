import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/components/Icon_list.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:flutter_complete_guide/provider/favorite_tournament_provider.dart';
import 'package:flutter_complete_guide/screens/TournamentScreens/tournament_detail.dart';
import 'package:provider/provider.dart';

class LikedTournament extends StatefulWidget {
  List<Tournament> likedTournament;
  LikedTournament(this.likedTournament);

  @override
  State<LikedTournament> createState() => _LikedTournamentState();
}

class _LikedTournamentState extends State<LikedTournament> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //input: context
  //output: new screen where you can view all of your favorite tournaments
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
          "Favorite Tournament",
          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 17.0, top: 5),
        child: Text(
          "Here are the tournament you liked",
          style: TextStyle(color: Colors.white54),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 30.0),
        child: Container(
            height: 700,
            padding: EdgeInsets.only(bottom: 0.0),
            child: ListView.builder(
                itemCount: widget.likedTournament?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                      child: Stack(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 55,
                            child: Center(
                              child: ListTile(
                                key: new Key(index.toString()),
                                leading: GetIcon(widget.likedTournament[index].icon, Colors.red),
                                title: Text(
                                  widget.likedTournament![index].name,
                                  style: TextStyle(color: Color(0xCC979797), fontWeight: FontWeight.w500, fontSize: 20),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    shadows: [Shadow(blurRadius: 7)],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      Provider.of<FavoriteTournamentProvider>(context, listen: false)
                                          .FavoriteTournament(widget.likedTournament[index]);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => DetailPage(tournament: widget.likedTournament[index])))),
                    ),
                  );
                })),
      ),
    ])));
  }
}

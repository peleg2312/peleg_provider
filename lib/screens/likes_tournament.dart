import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_complete_guide/components/IconList.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:flutter_complete_guide/provider/favorite_tournament_provider.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class LikedTournament extends StatefulWidget {
  List<Tournament> likedTournament;
  LikedTournament(this.likedTournament);

  @override
  State<LikedTournament> createState() => _LikedTournamentState();
}

class _LikedTournamentState extends State<LikedTournament> {
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
                      //onTap: () => _DetailPressed(tournaments[index]),
                    ),
                  );
                })),
      ),
    ])));
    // key: _scaffoldKey,
    // body: ModalProgressHUD(
    //   inAsyncCall: false,
    //   child: Column(children: [
    //     Container(
    //       child: Column(
    //         children: <Widget>[
    //           Padding(
    //             padding: EdgeInsets.only(top: 50.0),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: <Widget>[
    //                 Expanded(
    //                   flex: 1,
    //                   child: Container(
    //                     color: Colors.white,
    //                     height: 1.5,
    //                   ),
    //                 ),
    //                 Expanded(
    //                     flex: 4,
    //                     child: new Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: <Widget>[
    //                         Text(
    //                           'Liked',
    //                           style: new TextStyle(
    //                               fontSize: 30.0,
    //                               fontWeight: FontWeight.bold,
    //                               color: Colors.grey),
    //                         ),
    //                         Text(
    //                           'Tournament',
    //                           style: new TextStyle(
    //                               fontSize: 28.0, color: Colors.white70),
    //                         )
    //                       ],
    //                     )),
    //                 Expanded(
    //                   flex: 1,
    //                   child: Container(
    //                     color: Colors.white,
    //                     height: 1.5,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     Padding(
    //       padding: EdgeInsets.only(top: 40.0),
    //       child: Container(
    //           height: 400,
    //           padding: EdgeInsets.only(bottom: 25.0),
    //           child: ListView.builder(
    //               itemCount: likedTournament?.length,
    //               itemBuilder: (context, index) {
    //                 return GestureDetector(
    //                   child: Stack(children: [
    //                     Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: Container(
    //                         decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(10),
    //                             color: Color.fromRGBO(87, 95, 113, 1)),
    //                         height: 70,
    //                         child: Center(
    //                           child: ListTile(
    //                             key: new Key(index.toString()),
    //                             subtitle:
    //                                 likedTournament![index].isStarted ==
    //                                         false
    //                                     ? Text("in registration")
    //                                     : Text("in progress"),
    //                             leading:
    //                                 IconsList[likedTournament[index].icon],
    //                             title: Text(
    //                               likedTournament![index].name,
    //                               style: TextStyle(
    //                                   color: Colors.white,
    //                                   fontWeight: FontWeight.w500,
    //                                   fontSize: 20),
    //                             ),
    //                             trailing: IconButton(
    //                               icon: Icon(
    //                                 Icons.favorite,
    //                                 color: Colors.deepPurple,
    //                                 shadows: [Shadow(blurRadius: 7)],
    //                               ),
    //                               onPressed: () {
    //                                 setState(() {
    //                                   Provider.of<FavoriteTournamentProvider>(
    //                                           context,
    //                                           listen: false)
    //                                       .FavoriteTournament(
    //                                           likedTournament[index]);
    //                                 });
    //                               },
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ]),
    //                   //onTap: () => _DetailPressed(tournaments[index]),
    //                 );
    //               })),
    //     ),
    //   ]),
    // ));
  }
}

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/components/IconList.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:flutter_complete_guide/provider/favorite_tournament_provider.dart';
import 'package:flutter_complete_guide/provider/match_provider.dart';
import 'package:flutter_complete_guide/provider/team_provider.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:flutter_complete_guide/screens/TournamentSettings/edit_tournament.dart';
import 'package:flutter_complete_guide/screens/TournamentSettings/my_tournament_edit.dart';
import 'package:flutter_complete_guide/screens/TournamentSettings/new_tournament.dart';
import 'package:flutter_complete_guide/screens/TournamentSettings/tournament_detail.dart';
import 'package:flutter_complete_guide/screens/likes_tournament.dart';
import 'package:flutter_complete_guide/screens/my_tournament.dart';
import 'package:flutter_complete_guide/screens/tournament_settings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  User? authResult = FirebaseAuth.instance.currentUser;
  List<Tournament> _display = [];
  List<Tournament> tournaments = [];
  bool myTournamentViewMore = false;
  FocusNode myFocusNode = FocusNode();
  double hightIndex = 70;
  double hightIndex2 = 70;
  Tournament? _selected = Tournament(
      name: "name",
      isDone: false,
      Admin: "Admin",
      icon: 0,
      Id: "Id",
      isSearchingWinner: false,
      tournamentType: "roundrobin");

  @override
  void initState() {
    try {
      Provider.of<TournamentProvider>(context, listen: false).fetchTournamentData(context);
    } catch (e) {
      print(e);
    }
    try {
      Provider.of<FavoriteTournamentProvider>(context, listen: false).fetchFavoriteTournamentData();
    } catch (e) {
      print(e);
    }
    try {
      Provider.of<TeamProvider>(context, listen: false).fetchTeamData(context);
    } catch (e) {
      print(e);
    }
    try {
      Provider.of<MatchProvider>(context, listen: false).fetchMatchData(context);
    } catch (e) {
      print(e);
    }

    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_display.isEmpty) {
      _display = List.from(tournaments);
    }
    List<String>? SlikedTournament = Provider.of<FavoriteTournamentProvider>(context).FavoriteTournaments;
    tournaments = Provider.of<TournamentProvider>(context).Tournaments;
    List<Tournament>? likedTournament = SortLikedTournament(SlikedTournament, tournaments);
    SetFavorite(likedTournament, tournaments);
    List<Tournament>? myTournament = AdminTournament(tournaments);
    if (myTournament.length > 1) {
      hightIndex = 140;
    }
    if (likedTournament.length > 1) {
      hightIndex2 = 140;
    }
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF1B1B1F),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: AppBar(
          backgroundColor: Color(0xFF1B1B1F),
          automaticallyImplyLeading: false,
          title: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Hello, ',
                          style: TextStyle(color: Colors.white70, fontFamily: 'Readex Pro', fontSize: 40),
                        ),
                        Text(authResult!.displayName.toString(),
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 89, 99),
                                fontFamily: 'Readex Pro',
                                fontSize: 40,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(15),
              child: IconButton(
                  onPressed: LogOut,
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 26,
                    color: Colors.red,
                  )),
            )
          ],
          centerTitle: false,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        top: true,
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(right: 10, top: 10, bottom: 20, left: 10),
                    width: 320,
                    height: 40,
                    child: DropdownSearch<Tournament>(
                      popupShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      maxHeight: 260,
                      popupBackgroundColor: Color.fromARGB(255, 119, 119, 119),
                      itemAsString: (Tournament? t) => t!.name,
                      selectedItem: _selected,
                      mode: Mode.MENU,
                      popupItemBuilder: _customPopupItemBuilder,
                      dropdownBuilder: _customDropDownMenu,
                      items: tournaments,
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'search for tournament',
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Color(0xff2a2a2a),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onChanged: (value) {
                        _DetailPressed(value!);
                      },
                      //showSelectedItems: true,
                      showSearchBox: true,
                    )),
                Container(
                  width: 330,
                  decoration: BoxDecoration(
                    color: Color(0xFF1B1B1F),
                  ),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Color.fromARGB(255, 105, 105, 105),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(10, 20, 0, 0),
                              child: Text(
                                'Your Tournament',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: 'Readex Pro', fontSize: 28, color: Color.fromARGB(255, 20, 24, 27)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(20, 25, 10, 0),
                                  child: IconButton(
                                    iconSize: 20,
                                    icon: Icon(
                                      FontAwesomeIcons.arrowsTurnRight,
                                    ),
                                    onPressed: (() {
                                      _YourTournamentPage(myTournament);
                                    }),
                                  )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        myTournament.isEmpty == true
                            ? Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Center(
                                        child: Text("You dont have any tournament",
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(221, 19, 19, 19))),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      child: FloatingActionButton.extended(
                                        elevation: 6,
                                        backgroundColor: Color.fromARGB(255, 193, 67, 75),
                                        onPressed: _addTaskPressed,
                                        label: Text(
                                          "Add Tournament",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                        splashColor: Color.fromARGB(255, 88, 198, 206),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  Container(
                                      height: hightIndex,
                                      padding: EdgeInsets.only(bottom: 5.0),
                                      child: ListView.builder(
                                          itemCount: myTournament.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              child: Stack(children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      //color: Color.fromRGBO(
                                                      //87, 95, 113, 1)
                                                    ),
                                                    height: 50,
                                                    child: Center(
                                                      child: ListTile(
                                                        leading: GetIcon(
                                                            myTournament[index].icon, Color.fromARGB(255, 193, 67, 75)),
                                                        title: Text(
                                                          myTournament[index].name,
                                                          style: TextStyle(
                                                              color: Color.fromARGB(196, 0, 0, 0),
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 20),
                                                        ),
                                                        trailing: IconButton(
                                                          icon: Icon(
                                                            FontAwesomeIcons.edit,
                                                            color: Color.fromARGB(255, 193, 67, 75),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              _UpdatePressed(myTournament[index]);
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              onTap: () => _DetailPressed(myTournament[index]),
                                            );
                                          })),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 193, 67, 75),
                                          borderRadius: BorderRadius.circular(50)),
                                      child: IconButton(
                                        onPressed: _addTaskPressed,
                                        icon: Icon(
                                          FontAwesomeIcons.plus,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   height: 40,
                                    //   width: 40,
                                    //   child: InkWell(
                                    //     onTap: null,
                                    //     child: Image.asset(
                                    //         "assets/images/show_more.png"),
                                    //   ),
                                    // ),
                                  )
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    width: 330,
                    decoration: BoxDecoration(
                      color: Color(0xFF1B1B1F),
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Color.fromARGB(255, 105, 105, 105),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(10, 20, 0, 0),
                                child: Text(
                                  'Favorite Tournament',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: 'Readex Pro', fontSize: 28, color: Color.fromARGB(255, 20, 24, 27)),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 5, 0),
                                    child: IconButton(
                                      iconSize: 20,
                                      icon: Icon(
                                        FontAwesomeIcons.arrowsTurnRight,
                                      ),
                                      onPressed: (() {
                                        _favoritePage(likedTournament);
                                      }),
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          likedTournament.isEmpty == true
                              ? Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Text("You dont have favorite tournament",
                                                  style: new TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color.fromARGB(221, 19, 19, 19))),
                                              Text("Please search for tournament",
                                                  style: new TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color.fromARGB(221, 19, 19, 19)))
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      )
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    Container(
                                        height: hightIndex2,
                                        padding: EdgeInsets.only(bottom: 5.0),
                                        child: ListView.builder(
                                            itemCount: likedTournament.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                child: Stack(children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        //color: Color.fromRGBO(
                                                        //87, 95, 113, 1)
                                                      ),
                                                      height: 50,
                                                      child: Center(
                                                        child: ListTile(
                                                            leading: GetIcon(likedTournament[index].icon,
                                                                Color.fromARGB(255, 193, 67, 75)),
                                                            title: Text(
                                                              likedTournament[index].name,
                                                              style: TextStyle(
                                                                  color: Color.fromARGB(196, 0, 0, 0),
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 20),
                                                            ),
                                                            trailing: IconButton(
                                                              onPressed: (() async {
                                                                Provider.of<FavoriteTournamentProvider>(context,
                                                                        listen: false)
                                                                    .FavoriteTournament(likedTournament[index]);
                                                                setState(() {});
                                                              }),
                                                              icon: Icon(
                                                                Icons.favorite,
                                                                color: Colors.red,
                                                                shadows: [Shadow(blurRadius: 7)],
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                onTap: () => _DetailPressed(likedTournament[index]),
                                              );
                                            })),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Container(
                                    //     height: 40,
                                    //     width: 40,
                                    //     child: InkWell(
                                    //       onTap: null,
                                    //       child: Image.asset("assets/images/show_more.png"),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customDropDownMenu(BuildContext context, Tournament? t) {
    return Container(
      height: 300,
      decoration: BoxDecoration(color: Colors.green),
      child: Text("ssss"),
    );
  }

  Widget _customPopupItemBuilder(BuildContext context, Tournament item, bool isSelected) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            //color: Color.fromRGBO(118, 118, 118, 0.332)
          ),
          height: 60,
          child: Center(
            child: ListTile(
              leading: IconsList[item.icon],
              title: Text(
                item.name,
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 20),
              ),
              // trailing: IconButton(
              //   icon: !item.favorite
              //       ? Icon(Icons.favorite_border)
              //       : Icon(
              //           Icons.favorite,
              //           color: Colors.deepPurple,
              //           shadows: [Shadow(blurRadius: 7)],
              //         ),
              //   onPressed: () {
              //     setState(() {
              //       Provider.of<FavoriteTournamentProvider>(context,
              //               listen: false)
              //           .FavoriteTournament(item);
              //     });
              //   },
              // ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget ScreenAnimation(BuildContext context, Animation<double> animation, Animation<double> s, Widget child) {
    return new ScaleTransition(
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
    );
  }

  void _addTaskPressed() async {
    Navigator.of(context).push(
      new PageRouteBuilder(
          pageBuilder: (_, __, ___) => new NewTournament(
              //user: widget.user,
              ),
          transitionsBuilder: ScreenAnimation),
    );
    //Navigator.of(context).pushNamed('/new');
  }

  void _favoritePage(List<Tournament> arr) async {
    Navigator.of(context).push(
      new PageRouteBuilder(pageBuilder: (_, __, ___) => new LikedTournament(arr), transitionsBuilder: ScreenAnimation),
    );
    //Navigator.of(context).pushNamed('/new');
  }

  void _YourTournamentPage(List<Tournament> arr) async {
    Navigator.of(context).push(
      new PageRouteBuilder(pageBuilder: (_, __, ___) => new MyTournament(arr), transitionsBuilder: ScreenAnimation),
    );
    //Navigator.of(context).pushNamed('/new');
  }

  void _UpdatePressed(Tournament tournament) async {
    Navigator.of(context).push(
      new PageRouteBuilder(
          pageBuilder: (_, __, ___) => new EditTournament(
                tournament: tournament,
              ),
          transitionsBuilder: ScreenAnimation),
    );
    //Navigator.of(context).pushNamed('/new');
  }

  void _DetailPressed(Tournament tournament) async {
    Navigator.of(context).push(
      new PageRouteBuilder(
          pageBuilder: (_, __, ___) => tournament.Admin == FirebaseAuth.instance.currentUser?.uid
              ? new MyDetailPage(
                  tournament: tournament,
                )
              : new DetailPage(
                  tournament: tournament,
                ),
          transitionsBuilder: ScreenAnimation),
    );
    //Navigator.of(context).pushNamed('/new');
  }

  void LogOut() {
    showDialog(
        context: context,
        builder: ((ctx) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to sign out?'),
              actions: [
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            )));
  }

  List<Tournament> SortLikedTournament(List<String> likedTournament, List<Tournament> tournaments) {
    List<Tournament> liked = <Tournament>[];

    for (var tournament in tournaments) {
      for (var item in likedTournament) {
        if (tournament.Id == item) {
          liked.add(tournament);
        }
      }
    }
    return liked;
  }

  void SetMyTournamentViewMore() {
    setState(() {
      myTournamentViewMore = !myTournamentViewMore;
    });
  }

  void SetFavorite(List<Tournament> likedTournament, List<Tournament> tournaments) {
    for (var ftournament in likedTournament) {
      for (var tournament in tournaments) {
        if (ftournament.name == tournament.name) {
          tournament.SetFavorite(true);
        }
      }
    }
  }

  List<Tournament> AdminTournament(List<Tournament> tournaments) {
    User? authResult = FirebaseAuth.instance.currentUser;
    List<Tournament> myTournament = <Tournament>[];

    for (var tournament in tournaments) {
      if (tournament.Admin == authResult!.uid) {
        myTournament.add(tournament);
      }
      ;
    }
    return myTournament;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:flutter_complete_guide/screens/score_board.dart';
import 'package:flutter_complete_guide/screens/page_tournament.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 1;

  final List<Widget> _children = [
    TournamentPage(),
    ScoreBoard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          color: Color.fromARGB(255, 36, 40, 51),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: GNav(
                activeColor: Colors.deepPurple,
                color: Colors.white70,
                backgroundColor: Color.fromARGB(255, 36, 40, 51),
                tabBackgroundColor: Colors.grey.shade500,
                gap: 3,
                padding: EdgeInsets.all(14),
                onTabChange: onTabTapped,
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: "home",
                  ),
                  GButton(icon: Icons.scoreboard, text: "Board"),
                  GButton(
                    icon: Icons.search,
                    text: "Search",
                  ),
                  GButton(
                    icon: Icons.favorite_border,
                    text: "Likes",
                  )
                ]),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Row(
            children: [
              Text(
                'TournamentApp',
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: LogOut,
                icon: Icon(
                  Icons.exit_to_app,
                  size: 26,
                  color: Colors.red,
                ))
          ],
        ),
        body: _children[_currentIndex]);
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

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      Provider.of<TournamentProvider>(context, listen: false)
          .fetchTournamentData();
    } catch (e) {
      print(e);
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

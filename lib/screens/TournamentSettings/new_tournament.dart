import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/components/IconList.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:flutter_complete_guide/screens/TournamentSettings/teams_maneger.dart';
import 'package:provider/provider.dart';

class NewTournament extends StatefulWidget {
  @override
  State<NewTournament> createState() => _NewTournamentState();
}

class _NewTournamentState extends State<NewTournament> {
  int IconPicker = -1;
  late ValueChanged<Color> onColorChanged;
  int selectedCard = -1;
  TextEditingController listNameController = new TextEditingController();
  String tId = "";

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
                  return (value == null || IconPicker == -1) ? 'Enter Text Or Icon' : null;
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
                    onPressed: () async {
                      await Provider.of<TournamentProvider>(context, listen: false)
                          .addTournamentToFirebase(listNameController, context, IconPicker)
                          .then((value) => tId = value);
                      _TeamManeger(tId);
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
            child: Text(
              "Select Tournament Sport",
              style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),
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
  }

  void _TeamManeger(String tId) async {
    Navigator.of(context).push(
      new PageRouteBuilder(
        pageBuilder: (_, __, ___) => new TeamsManeger(listNameController, IconPicker, tId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => new ScaleTransition(
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

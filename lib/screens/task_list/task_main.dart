import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/screens/task_list/page_done.dart';
import 'package:flutter_complete_guide/screens/task_list/page_settings.dart';
import 'package:flutter_complete_guide/screens/task_list/page_task.dart';
import 'package:flutter_complete_guide/screens/task_list/page_taskByTime.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskApp extends StatefulWidget {
  @override
  _TaskAppState createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> with SingleTickerProviderStateMixin {
  int _currentIndex = 1;

  final List<Widget> _children = [TaskPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          fixedColor: Colors.deepPurple,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: new Icon(FontAwesomeIcons.clock), label: ""),
            BottomNavigationBarItem(
                icon: new Icon(FontAwesomeIcons.calendar), label: ""),
            BottomNavigationBarItem(
                icon: new Icon(FontAwesomeIcons.slidersH), label: "")
          ],
        ),
        appBar: AppBar(
          backgroundColor: Color(0xFFEEEFF5),
          elevation: 0,
          title: Row(
            children: [
              Icon(
                Icons.menu,
                color: Colors.black87,
              ),
              Container(
                width: 20,
              ),
              Text(
                'ListApp',
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
          actions: [
            DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.more_vert,
                color: Colors.black87,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.black87,
                        ),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                  value: 'logout',
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          ],
        ),
        body: _children[_currentIndex]);
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

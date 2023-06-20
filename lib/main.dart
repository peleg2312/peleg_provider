import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/auth_provider.dart';
import 'package:flutter_complete_guide/provider/favorite_tournament_provider.dart';
import 'package:flutter_complete_guide/provider/match_provider.dart';
import 'package:flutter_complete_guide/provider/team_provider.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:flutter_complete_guide/screens/TournamentScreens/main_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/Auth/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  //input: context
  //output: if the device have User login it open HomePageWidget() else AuthScreen()
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => TeamProvider()),
          ChangeNotifierProvider(create: (_) => MatchProvider()),
          ChangeNotifierProvider(create: (_) => TournamentProvider()),
          ChangeNotifierProvider(create: (_) => FavoriteTournamentProvider())
        ],
        child: FutureBuilder(
            future: _initialization,
            builder: (context, appSnapshot) {
              return MaterialApp(
                title: 'FlutterChat',
                theme: ThemeData(
                  primarySwatch: Colors.red,
                  scaffoldBackgroundColor: Color(0xFF1B1B1F),
                  buttonTheme: ButtonTheme.of(context).copyWith(
                    textTheme: ButtonTextTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                debugShowCheckedModeBanner: false,
                home: StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (ctx, userSnapshot) {
                      if (userSnapshot.hasData) {
                        return HomePageWidget();
                      }
                      return AuthScreen();
                    }),
              );
            }));
  }
}

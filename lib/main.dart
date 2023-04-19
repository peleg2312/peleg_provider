import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/auth_provider.dart';
import 'package:flutter_complete_guide/provider/favorite_tournament_provider.dart';
import 'package:flutter_complete_guide/provider/tournament_provider.dart';
import 'package:flutter_complete_guide/screens/Auth/login_screen.dart';
import 'package:flutter_complete_guide/screens/main_app_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/Auth/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //FireBaseAuthenticaion fireBaseAuthenticaion = FireBaseAuthenticaion();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => TournamentProvider()),
          ChangeNotifierProvider(create: (_) => FavoriteTournamentProvider())
        ],
        child: FutureBuilder(
            future: _initialization,
            builder: (context, appSnapshot) {
              return MaterialApp(
                title: 'FlutterChat',
                theme: ThemeData(
                  scaffoldBackgroundColor: Color.fromARGB(255, 67, 75, 95),
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
                        return MainScreen();
                      }
                      return AuthScreen();
                    }),
              );
            }));
  }
}

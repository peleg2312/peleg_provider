import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/auth_provider.dart';
import 'package:flutter_complete_guide/screens/login_screen.dart';
import 'package:flutter_complete_guide/screens/profile.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/register.dart';

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
        ],
        child: FutureBuilder(
            // Initialize FlutterFire:
            future: _initialization,
            builder: (context, appSnapshot) {
              return MaterialApp(
                title: 'FlutterChat',
                theme: ThemeData(
                  primarySwatch: Colors.pink,
                  backgroundColor: Colors.pink,
                  accentColor: Colors.deepPurple,
                  accentColorBrightness: Brightness.dark,
                  buttonTheme: ButtonTheme.of(context).copyWith(
                    buttonColor: Colors.pink,
                    textTheme: ButtonTextTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                home: appSnapshot.connectionState != ConnectionState.done
                    ? SignInPage()
                    : StreamBuilder(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (ctx, userSnapshot) {
                          if (userSnapshot.hasData) {
                            return Profile();
                          }
                          return AuthScreen();
                        }),
              );
            }));
  }
}
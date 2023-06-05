import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/model/tournament.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  late String Uid;
  final _auth = FirebaseAuth.instance;
  var isLoading = false;
  bool saving = false;

  //מקבל מהזנה של משתמש אימייל סיסמה והאם הוא רק מתחבר או יוצר משתשמש
  void submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      isLoading = true;
      notifyListeners();
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        FirebaseFirestore.instance.collection('users').doc(authResult.user?.uid).set({
          'username': username,
          'email': email,
        });
        authResult.user?.updateDisplayName(username);
      }
    } on PlatformException catch (err) {
      String? message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message!),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      isLoading = false;
      notifyListeners();
    } catch (err) {
      print(err);
      isLoading = false;
      notifyListeners();
    }
  }
  //מחבר את המשתמש למשתמש שלו ויוצר משתמש חדש במידת הצורך

}

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
        FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user?.uid)
            .set({
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

  void addListToFirebase(Color currentColor,
      TextEditingController listNameController, BuildContext context) async {
    User? authResult = _auth.currentUser;
    saving = true;
    bool isExist = false;

    QuerySnapshot query =
        await FirebaseFirestore.instance.collection(authResult!.uid).get();

    query.docs.forEach((doc) {
      if (listNameController.text.toString() == doc.id) {
        isExist = true;
      }
    });

    if (isExist == false && listNameController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection(authResult.uid)
          .doc("TaskList")
          .collection("Tasks")
          .doc(listNameController.text.toString().trim())
          .set({
        "color": currentColor.value.toString(),
        "date": DateTime.now().millisecondsSinceEpoch
      });

      listNameController.clear();

      //pickerColor = Color(0xff6633ff);
      currentColor = Color(0xff6633ff);

      Navigator.of(context).pop();
    }
    if (isExist == true) {
      showInSnackBar("This list already exists", context, currentColor);
      saving = false;
    }
    if (listNameController.text.isEmpty) {
      showInSnackBar("Please enter a name", context, currentColor);
      saving = false;
    }
  }

  void addTaskToFirebase(DateTime dateTime,
      TextEditingController listNameController, BuildContext context) async {
    User? authResult = _auth.currentUser;
    saving = true;
    bool isExist = false;

    QuerySnapshot query =
        await FirebaseFirestore.instance.collection(authResult!.uid).get();

    query.docs.forEach((doc) {
      if (listNameController.text.toString() == doc.id) {
        isExist = true;
      }
    });

    if (isExist == false && listNameController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection(authResult.uid)
          .doc("TaskByTime")
          .collection("Tasks")
          .doc(listNameController.text.toString().trim())
          .set({
        "dateTime": dateTime.toString(),
        "date": DateTime.now().millisecondsSinceEpoch
      });

      listNameController.clear();

      Navigator.of(context).pop();
    }
    if (isExist == true) {
      showInSnackBar("This list already exists", context, Colors.grey);
      saving = false;
    }
    if (listNameController.text.isEmpty) {
      showInSnackBar("Please enter a name", context, Colors.grey);
      saving = false;
    }
  }

  void addFavorite() {
    User? authResult = _auth.currentUser;
    List<Tournament> favoriteTournaments = <Tournament>[];

    FirebaseFirestore.instance.collection('users').doc(authResult?.uid).set({
      'username': authResult?.displayName,
      'email': authResult?.email,
      'favorite': favoriteTournaments
    });
  }

  void showInSnackBar(String value, BuildContext context, Color color) {
    ScaffoldMessenger.of(context)?.removeCurrentSnackBar();

    ScaffoldMessenger.of(context)?.showSnackBar(new SnackBar(
      content: new Text(value, textAlign: TextAlign.center),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }
}

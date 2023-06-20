import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/auth_provider.dart';
import 'package:flutter_complete_guide/screens/Auth/register_screen.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  //output: if valid login to your account
  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      _formKey.currentState!.save();
      Provider.of<AuthProvider>(context, listen: false)
          .submitAuthForm(_userEmail.trim(), _userPassword.trim(), _userName.trim(), _isLogin, context);
    }
  }

  //output: new widget InkWell
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 20, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  //output: new widget Stack with TextFormField
  Widget _emailWidget() {
    return Stack(
      children: [
        TextFormField(
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          key: ValueKey('email'),
          validator: (String? value) {
            if (value!.isEmpty || value.contains('@')) {
              return 'Please enter a valid email address.';
            }
            return null;
          },
          onSaved: (value) {
            _userEmail = value!;
          },
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(color: Colors.white54, fontWeight: FontWeight.w500, fontSize: 13),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //output: new widget Stack with TextFormField
  Widget _passwordWidget() {
    return Stack(
      children: [
        TextFormField(
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          key: ValueKey('password'),
          validator: (String? value) {
            if (value!.isEmpty || value.length < 7) {
              return 'Password must be at least 7 characters long.';
            }
            return null;
          },
          onSaved: (value) {
            _userPassword = value!;
          },
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.white54, fontWeight: FontWeight.w500, fontSize: 13),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //output: new widget Column with InkWell
  Widget _submitButton() {
    final isLoading = Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Align(
        alignment: Alignment.centerRight,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                _trySubmit();
              },
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'Sign in',
                  style: TextStyle(
                      color: Color.fromRGBO(76, 81, 93, 1), fontSize: 25, fontWeight: FontWeight.w500, height: 1.6),
                ),
                SizedBox.fromSize(
                  size: Size.square(70.0),
                  child: ClipOval(
                    child: Material(
                      color: Color.fromRGBO(76, 81, 93, 1),
                      child: Icon(Icons.arrow_forward, color: Colors.white), // button color
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ));
  }

  //output: new widget Container with InkWell
  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen())),
            child: Text(
              'Register',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                  color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  //input: context
  //output: new screen where you can login into you account
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: (height * .4) + 80),
                          _emailWidget(),
                          SizedBox(height: 20),
                          _passwordWidget(),
                          SizedBox(height: 30),
                          _submitButton(),
                          SizedBox(height: height * .050),
                          _createAccountLabel(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(top: 60, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}

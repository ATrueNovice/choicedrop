import 'dart:math';

import 'package:choicedrop/LogIn/SignIn/SignInPage.dart';
import 'package:choicedrop/LogIn/SignUp/SignUpPage.dart';
import 'package:choicedrop/LogIn/SignUp/walkthrough.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

// import './preferences.dart';

// import './Model/token.dart';
// import 'package:flutter/rendering.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Random random = Random();
  int index = 0;
  bool firstStateEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoggedIn = false;

  Widget _interactionButtions(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.blue[400],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _headerWidget(),
            ),
            SizedBox(height: screenAwareSize(10, context)),
            _buttonWidget(),
            SizedBox(height: screenAwareSize(40, context)),
          ],
        ),
      ),
    );
  }

  Widget _headerWidget() {
    return Column(
      children: [
        Image(
          image: const AssetImage('assets/cdLogo.png'),
          height: MediaQuery.of(context).size.height / 2,
          width: screenAwareSize(250, context),
        ),
      ],
    );
  }

  Widget _buttonWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Center(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                      splashColor: Colors.blue[500],
                      elevation: 10.0,
                      color: Colors.white,
                      child: const SizedBox(
                        width: 100,
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontFamily: 'Roboto', color: Colors.blue),
                          ),
                        ),
                      ), //`Text` to display
                      shape: const StadiumBorder(),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => SignUpPage()));
                      }),
                  const SizedBox(
                    width: 15,
                  ),
                  MaterialButton(
                    splashColor: Colors.blue[500],

                    elevation: 8.0,

                    color: Colors.blue[200],
                    child: const SizedBox(
                      width: 100,
                      child: Center(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Roboto'),
                        ),
                      ),
                    ), //`Text` to display
                    shape: const StadiumBorder(),
                    // borderSide: BorderSide(color: Colors.white),
                    onPressed: () {
                      // _showModalSheet();

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => SignIn()));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 35),
              const Padding(
                padding: EdgeInsets.only(bottom: 28.0),
                child: Text(
                  'By Continuing, You Are Agreeing To Our Terms Of Service & Privacy Policy',
                  style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Roboto-Regular',
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.green,
      // systemNavigationBarColor: hlPurple
      // systemNavigationBarIconBrightness: Brightness.light
    ));

    return _interactionButtions(context);
  }
}

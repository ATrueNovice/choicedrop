import 'dart:async';

import 'package:choicedrop/APIS/google_sign_in.dart';
import 'package:choicedrop/APIS/model/data.dart';
import 'package:choicedrop/BottomBar/bottombar.dart';
import 'package:choicedrop/LogIn/SignUp/SignUpPage.dart';
import 'package:choicedrop/Static/ensure_visible.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  State createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  Future _emailLoginFunc;
  Future _googleSignIn;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

//form key
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();

  final _pwdFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();

  //Google Variables

  var userDetails;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  String cityName;
  String cityZip;
  String textA;
  String textB;
  String locationStatus;
  // Geolocator geolocator = Geolocator();
  int textValue;
  String passwordValidator =
      r'^(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[^\w\d\s:])([^\s]){8,16}$';

  final Map<String, dynamic> _signInForm = {'username': null, 'password': null};

  // Token emailToken;

  bool isLoggedIn = false;

  String _token = '';

//Facebook login
  Future initiateFacebookLogin() async {
    // var facebookLogin = FacebookLogin();

    // var facebookLoginResult =
    //     await facebookLogin.logIn(['email', 'public_profile']);
    // switch (facebookLoginResult.status) {
    //   case FacebookLoginStatus.error:
    //     print("Error");
    //     onLoginStatusChanged(false);
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     print("Cancelled ByUser");
    //     onLoginStatusChanged(false);
    //     break;
    //   case FacebookLoginStatus.loggedIn:
    //     final token = facebookLoginResult.accessToken.token;
    //     _token = token;

    //     final graphResponse = await http.get(
    //         'https://graph.facebook.com/v2.12/me?fields=id,name,email,picture.type(normal)&access_token=$token');
    //     print(graphResponse);
    //     var responseData = json.decode(graphResponse.body);

    //     // User user = User.fromJSON(responseData);

    //     // setState(() {
    //     //   userProfile = user;
    //     // });
    //     facebookUserLogin(token);

    //     print(token);
    //     onLoginStatusChanged(true);

    //     break;
    // }
  }

  //Email Login

  Future _emailLogin(userdetails) async {
    auth
        .signInWithEmailAndPassword(
            email: userdetails['email'], password: userdetails['password'])
        .catchError((e) {
      print('The Error For Sign In $e');
    }).then((value) {
      if (value.user.uid != null) {
        myId = value.user.uid;
        print('I am a user and myId is $myId');

        onLoginStatusChanged(true);
      } else {
        popupSwitch(2);

        print('Couldnt login');
      }
    });

    // _emailLoginFunc.then((value) {
    //   print(value);

    //   if (value == 'good') {
    //     onLoginStatusChanged(true);
    //   } else {
    //     popupSwitch(2);

    //     print('Couldnt login');
    //   }
    // });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      if (isLoggedIn == true) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                ),
              );
            });
        Future.delayed(
            const Duration(
              seconds: 1,
            ), () {
          Navigator.pop(context);
          preformLogin();
        });
      } else {
        print('Still Logged Out');
      }
    });
  }

  void popupSwitch(int value) {
    setState(() {
      textValue = value;

      switch (value) {
        case 0:
          textA = 'No Internet Connection Detected';
          textB = 'Need The Internet To Meet Our Buds';
          _showPopup(textA, textB);

          break;
        case 1:
          textA = 'We Need Your Location';
          textB = 'See Buds Near You';
          _showPopup(textA, textB);

          break;
        case 2:
          textA = 'Have We Met?';
          textB =
              "Check Your User Name Or Password.\nIf You Haven't Activated Your Account\nCheck Your Email For Your Link";
          _showPopup(textA, textB);
          break;
        case 3:
          textA = 'Not Activated yet';
          textB = "Please Check Your Email\nFor Your Activation Link";
          _showPopup(textA, textB);
          break;
      }
    });
  }

  Future _submit() async {
    final form = _signInFormKey.currentState;
    _emailLogin(_signInForm);

    // if (form.validate()) {
    //   form.save();
    // } else {
    //   print('Cant save form');
    //   print(_signInForm.values);
    // }
  }

  preformLogin() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 6,
            ),
          );
        });
    Future.delayed(
        const Duration(
          milliseconds: 200,
        ), () async {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BottomBarController()));
    });
  }

  void clearText() {
    setState(() {
      _usernameController.clear();
      _pwdController.clear();
    });
  }

  void _showPopup(textA, textB) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: new Text(
            textA,
            style: TextStyle(fontFamily: 'Poppins'),
            textAlign: TextAlign.center,
          ),
          content: new Text(
            textB,
            style: TextStyle(fontFamily: 'Roboto-Regular'),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future emailButtonPressed(_signInForm) async {
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _loginKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Choice Drop'),
        elevation: 0,
        centerTitle: true,
        actions: [
          MaterialButton(
            elevation: 8.0,
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => SignUpPage()));
            },
            child: const Text('Sign Up',
                style: TextStyle(fontFamily: 'Roboto', color: Colors.white)),
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Form(
            key: _signInFormKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: screenAwareSize(60, context),
                  ),
                  Expanded(flex: 1, child: _header(theme)),
                  Expanded(flex: 2, child: _screenBody(theme)),
                  Expanded(flex: 3, child: _loginButton()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(theme) {
    return Text(
      '',
      style: TextStyle(
          fontFamily: theme.textTheme.headline1.fontFamily,
          color: theme.textTheme.headline1.color,
          fontSize: theme.textTheme.headline1.fontSize),
    );
  }

  Widget _screenBody(theme) {
    return Container(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    "Email",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenAwareSize(12.0, context),
                        fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(child: _usernameField(theme)),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    "PASSWORD",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenAwareSize(12.0, context),
                        fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(child: _buildPasswordTextField(theme)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        margin: const EdgeInsets.only(left: 70.0, right: 70.0, top: 5.0),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.blue[500],
                onPressed: () {
                  emailButtonPressed(_signInForm);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          "LOGIN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: TextButton(
          child: const Text(
            "Forgot Your Password?",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                fontFamily: 'Roboto'),
            textAlign: TextAlign.end,
          ),
          onPressed: () {
            _launchURL();
          },
        ),
      ),
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: EdgeInsets.only(left: 8.0),
            alignment: Alignment.center,
            child: IconButton(
              iconSize: screenAwareSize(60, context),
              icon: Image.asset('assets/googleIcon.png'),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              },
            ),
          ))
    ]);
  }

  _launchURL() async {
    // if (await canLaunch(resetPwdUrl)) {
    //   await launch(resetPwdUrl);
    // } else {
    //   throw 'Could not launch $resetPwdUrl';
    // }
  }

  Widget _usernameField(theme) {
    return SizedBox(
      width: 175,
      child: EnsureVisibleWhenFocused(
        focusNode: _usernameFocusNode,
        child: TextFormField(
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          focusNode: _usernameFocusNode,
          controller: _usernameController,
          keyboardType: TextInputType.emailAddress,
          maxLength: 40,
          obscureText: false,
          style: TextStyle(
              color: theme.textTheme.subtitle1.color,
              fontSize: theme.textTheme.bodyText2.fontSize),
          decoration: const InputDecoration(
              icon: Icon(
                FontAwesomeIcons.userAlt,
              ),
              hintText: "Email",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              fillColor: Colors.transparent,
              filled: true),
          validator: (value) {
            if (value.isEmpty) {
              return 'Bad Username';
            }
          },
          onChanged: (String value) {
            _signInForm['email'] = value.replaceAll("", "").toLowerCase();
          },
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(theme) {
    return Container(
      width: 175,
      child: EnsureVisibleWhenFocused(
        focusNode: _pwdFocusNode,
        child: TextFormField(
          focusNode: _pwdFocusNode,
          controller: _pwdController,
          keyboardType: TextInputType.text,
          maxLength: 25,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          obscureText: true,
          textCapitalization: TextCapitalization.none,
          style: TextStyle(
              color: theme.textTheme.subtitle1.color,
              fontSize: theme.textTheme.bodyText2.fontSize),
          decoration: InputDecoration(
              icon: Icon(FontAwesomeIcons.userLock),
              hintText: "Enter Password",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              fillColor: Colors.transparent,
              filled: true),
          validator: (value) {
            if (value.isEmpty) {
              return 'Enter Password';
            } else if (!RegExp(passwordValidator).hasMatch(value)) {
              return 'Please Enter Vaild Password';
            }
          },
          onChanged: (String value) {
            _signInForm['password'] = value.replaceAll("", "");
          },
        ),
      ),
    );
  }
}

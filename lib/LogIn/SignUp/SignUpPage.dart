import 'package:choicedrop/APIS/Apis.dart';
import 'package:choicedrop/APIS/model/data.dart';
import 'package:choicedrop/LogIn/SignIn/SignInPage.dart';
import 'package:choicedrop/Static/InheritedWidgets.dart';
import 'package:choicedrop/Static/ensure_visible.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';

class SignUpPage extends StatefulWidget {
  @override
  State createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
//Text Controllers
  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    _usernameController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _renterPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  final auth = FirebaseAuth.instance;

  //passwords match
  bool passwordsMatch = false;
  bool signUpComplete = false;
  String tmpPwd;
  String tmpPwd2;
  String _address;
  //Sign Up
  bool _allowSubcription = false;
  bool _allowEmails = true;
  bool _agreeTOS = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _renterPasswordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  //  final _descriptionFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _pwdFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _renterPasswordFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  //FormData
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _signupForm = {
    'username': null,
    'first_name': null,
    'last_name': null,
    'password': null,
    'email': null,
    'phone': null,
    'address': null,
  };

  String emailValidator =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  String firstNameValidator =
      r'^(?=[a-zA-Z\s]{2,25}$)(?=[a-zA-Z\s])(?:([\w\s*?])\1?(?!\1))+$';

  String usernameValidator = r'([\d\D][^!£$%&@/()=?ì^#{}[\]]*)';

  String lastNameValidator =
      r'^(?=[a-zA-Z\s]{2,25}$)(?=[a-zA-Z\s])(?:([\w\s*?])\1?(?!\1))+$';

  String phoneValidator = r'^[0-9]*$';

  String textA;
  String textB;
  var segue;

  void _submit() async {
    _checkPasswords();
    _signupForm['username'] = _signupForm['email'];

    final form = _formKey.currentState;
    if (form.validate() && _agreeTOS == true) {
      form.save();
      upload(_signupForm);
      print(_signupForm.values);
    } else {
      HLAlertWidget()
          .showPopup(context, Text('Please Accept The Terms To Continue'));
      print('Cant save form');
      print(_signupForm.values);
    }
  }

  void upload(_signupForm) {
    setState(() {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 6,
              ),
            );
          });
      Future.delayed(
          Duration(
            seconds: 4,
          ), () async {
        print('submiting');

        auth
            .createUserWithEmailAndPassword(
                email: _signupForm['email'], password: _signupForm['password'])
            .then((value) {
          if (value == null) {
            print(value);
            Navigator.pop(context);
            createUserCheck(1);
          } else {
            _createCustomerProfile(
                _signupForm['firstName'],
                _signupForm['lastName'],
                _signupForm['email'],
                _signupForm['phone'],
                _signupForm['address']);
          }
        }).catchError((e) {
          var error = e.code;
          Navigator.pop(context);

          if (error == 'email-already-in-use') {
            popupSwitch(7);
          } else {
            print('There is an Error here $error');
          }
        });

        // Add user account
      });
    });
  }

  void _createCustomerProfile(firstName, lastName, email, phone, address) {
    APIS
        .addCustomer(firstName, lastName, email, phone, address)
        .catchError((e) {
      print('This error is the customer error$e');
    }).then((value) {
      setState(() {
        signUpComplete = true;
      });
      print('signUpCompleted $signUpComplete');
      Navigator.pop(context);
      popupSwitch(0);
    });
  }

  void createUserCheck(signUpComplete) {
    switch (signUpComplete) {
      case true:
        print('User Was Created Successfully Moving To Next Page');
        popupSwitch(0);

        setState(() {
          signUpComplete = false;
        });

        break;
      default:

        // print('Could Not Register because the reult is $result');
        print('Did the user Sign Up Successfully $signUpComplete');
        break;
    }
  }

  // Future<dynamic> customerSignUp(customerDetails) async {
  //   var url = Uri.parse('$hlServer/api/customer_signup/');

  //   await http.post(url, body: json.encode(customerDetails), headers: {
  //     "Content-Type": "application/json"
  //   }).then((http.Response response) async {
  //     var responseData = json.decode(response.body);
  //     print(responseData);

  //     print('Direct response $responseData');

  //     if (responseData == 'success') {
  //       setState(() {
  //         signUpComplete = true;
  //         print('signUpCompleted $signUpComplete');
  //       });
  //       createUserCheck(signUpComplete);
  //     } else {
  //       popupSwitch(1);
  //       signUpComplete = false;

  //       print('Not completed');
  //     }
  //     createUserCheck(signUpComplete);

  //     return responseData;
  //   });
  // }

  void popupSwitch(int value) {
    setState(() {
      switch (value) {
        case 0:
          textA = 'Wecome to Choice Drop';
          textB =
              'Check Your Email For Your\n Activation Link\nDont forget to check spam!';

          _showPopup(textA, textB);

          break;
        case 1:
          textA = 'Have We Met?';
          textB =
              'User Name Or Email Already Registered.\n\n Try A New Username \n\nOr\n\n Click The Reset Link To Recover Account';

          _showPopup(textA, textB);

          break;
        case 2:
          textA = 'Only Text Here';
          textB = 'Please only letters\n (no letters or special characters)';

          _showPopup(textA, textB);
          break;
        case 3:
          textA = 'Username ';
          textB = 'User Name Cannot Contain:\n Spaces\nDashes\nOr The @ Symbol';

          _showPopup(textA, textB);
          break;
        case 4:
          textA = 'Double Check Your Email';
          textB =
              'Your email cannot start or finish with a dot\nContain spaces\nContain special chars (<:, *,etc)';

          _showPopup(textA, textB);
          break;
        case 5:
          textA = 'That Password Isnt It Bud';
          textB =
              '\n\nPassword must contain: 1 number (0-9)\n\nPassword must contain 1 uppercase letters\n\nPassword must contain 1 lowercase letters\n\nPassword must contain 1 non-alpha numeric number\n\nPassword is 8-16 characters with no space';

          _showPopup(textA, textB);
          break;
        case 6:
          textA = 'Whoaaa Something Happened';
          textB = '\n\n Could Not Upload';

          _showPopup(textA, textB);
          break;
        case 7:
          textA = 'Email Already In Use';
          textB =
              '\n\n If you forgot your password\nPlease Click The Password Reset Link.';

          _showPopup(textA, textB);
          break;
      }
    });
  }

  void _showPopup(textA, textB) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text(
            textA,
            style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
            textAlign: TextAlign.center,
          ),
          content: Text(
            textB,
            style: TextStyle(fontFamily: 'Roboto-Regular', color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            signUpComplete
                ? MaterialButton(
                    elevation: 8,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: Text(
                      "Sign In Screen",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _getMessageToken();
                    })
                : FlatButton(
                    child: Text(
                      "Close",
                      style: TextStyle(),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
          ],
        );
      },
    );
  }

  void _getMessageToken() async {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (BuildContext context) => SignIn()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          title: Text('Choice Drop'),
          centerTitle: true,
          // title: buddiesLogo,
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => SignIn()));
              },
              child: Text('Sign In',
                  style: TextStyle(fontFamily: 'Roboto', color: Colors.white)),
            ),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      // autovalidate: true,
                      child: Column(children: <Widget>[
                        _header(),
                        SizedBox(
                          height: screenAwareSize(40, context),
                        ),
                        _signUpBody(theme),
                        SizedBox(
                          height: screenAwareSize(40, context),
                        ),
                        _subscriptionWidget(),
                        SizedBox(
                          height: screenAwareSize(10, context),
                        ),
                        _submitButton()
                      ]),
                    ),
                  ),
                ))));
  }

  Widget _header() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: screenAwareSize(20, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signUpBody(theme) {
    return Column(children: [
      Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("About Me",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: screenAwareSize(16, context))),
            ),
          ),
        ],
      ),
      SizedBox(
        height: screenAwareSize(10, context),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: screenAwareSize(125, context),
                  child: _textInputField(
                      _firstNameFocusNode,
                      _firstnameController,
                      TextInputType.text,
                      'first name',
                      'Invaild text',
                      firstNameValidator,
                      'firstName',
                      20,
                      null),
                ),
                Container(
                  width: screenAwareSize(125, context),
                  child: _textInputField(
                      _lastNameFocusNode,
                      _lastnameController,
                      TextInputType.text,
                      'last name',
                      'Invaild Text',
                      lastNameValidator,
                      'lastName',
                      20,
                      null),
                ),
              ],
            ),
            SizedBox(
              height: screenAwareSize(20, context),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: _textInputField(
                      _phoneFocusNode,
                      _phoneController,
                      TextInputType.phone,
                      'Phone Number',
                      'number',
                      phoneValidator,
                      'phone',
                      10,
                      null),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: _textInputField(
                          _emailFocusNode,
                          _emailController,
                          TextInputType.emailAddress,
                          'email',
                          'Please Enter Valid Email',
                          emailValidator,
                          'email',
                          40,
                          null)),
                ),
              ],
            ),

            SizedBox(
              height: screenAwareSize(20, context),
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: _addressInputField(
                _addressFocusNode,
                _addressController,
                TextInputType.text,
                'Address',
                'address',
              ),
            ),

            SizedBox(
              height: screenAwareSize(20, context),
            ),

            //Password Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildPasswordTextField(),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: SizedBox(
                      width: screenAwareSize(125, context),
                      child: _buildPasswordVerification(
                          _renterPasswordFocusNode,
                          _renterPasswordController,
                          TextInputType.text,
                          're-enter pwd',
                          'Passwords Do Not Match',
                          emailValidator,
                          're-enter password',
                          25,
                          're-enter password')),
                ),
              ],
            ),
          ],
        ),
      )
    ]);
  }

  Widget _submitButton() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 1.5,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  elevation: screenAwareSize(8.0, context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.blue[500],
                  onPressed: () {
                    _submit();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
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
      ],
    );
  }

  Widget _textInputField(focusNode, controller, keyboardType, hint, empty,
      formVaildator, formField, maxLength, helperText) {
    return EnsureVisibleWhenFocused(
      focusNode: focusNode,
      child: TextFormField(
        maxLength: maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
            helperText: helperText,
            hintText: hint,
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            fillColor: Colors.transparent,
            filled: true),
        validator: (value) {
          if (value.isEmpty) {
            return empty;
          } else if (!RegExp(formVaildator).hasMatch(value)) {}
        },
        onChanged: (String value) {
          _signupForm[formField] = value.replaceAll(' ', '').toLowerCase();
        },
      ),
    );
  }

  Widget _addressInputField(
    focusNode,
    controller,
    keyboardType,
    hint,
    empty,
  ) {
    return EnsureVisibleWhenFocused(
      focusNode: focusNode,
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            fillColor: Colors.transparent,
            filled: true),
        onTap: () => _getAddress(),
      ),
    );
  }

  void _getAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapBoxAutoCompleteWidget(
          apiKey: mapboxKey,
          hint: "Enter Address",
          onSelect: (place) {
            _addressController.text = place.placeName;

            setState(() {
              _address = _addressController.text;
              _signupForm['address'] = _address;
            });

            print(_addressController.text);

            return _addressController.text;
          },
          limit: 10,
          country: "US",
        ),
      ),
    );
  }

  Widget _addressBuilderWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Address',
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 14, color: Colors.black),
          ),
          _address == null
              ? MaterialButton(
                  onPressed: _getAddress,
                  elevation: 8,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    'Enter Address',
                    style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14),
                  ),
                )
              : Container(
                  width: screenAwareSize(150, context),
                  child: Text(
                    _addressController.text,
                    maxLines: 5,
                    softWrap: true,
                  ))
        ],
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
      width: screenAwareSize(125, context),
      child: EnsureVisibleWhenFocused(
        focusNode: _pwdFocusNode,
        child: TextFormField(
          focusNode: _pwdFocusNode,
          controller: _pwdController,
          keyboardType: TextInputType.text,
          maxLength: 25,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          obscureText: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
              hintText: "password",
              helperText:
                  '1 Uppercase \n1 Lowercase \n1 Number\n1 Special \nCharacter ',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              fillColor: Colors.transparent,
              filled: true),
          validator: (value) {
            if (value.isEmpty) {
              return 'Enter Password';
            } else if (!RegExp(passwordValidator).hasMatch(value)) {
              return 'Invalid Password';
            }
          },
          onChanged: (String value) {
            tmpPwd = value.replaceAll(' ', '');
          },
        ),
      ),
    );
  }

  Widget _buildPasswordVerification(focusNode, controller, keyboardType, hint,
      empty, formVaildator, formField, maxLength, helperText) {
    return Container(
      width: screenAwareSize(150, context),
      child: EnsureVisibleWhenFocused(
        focusNode: focusNode,
        child: TextFormField(
          maxLength: maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
              helperText:
                  '1 Uppercase \n1 Lowercase \n1 Number\n1 Special \nCharacter ',
              hintText: hint,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              fillColor: Colors.transparent,
              filled: true),
          validator: (value) {
            if (value.isEmpty) {
              return 'Enter Password';
            } else {
              if (tmpPwd != value) {
                return 'Passwords Do not Match';
              }
            }
          },
          onChanged: (String value) {
            tmpPwd2 = value.replaceAll(' ', '');
          },
        ),
      ),
    );
  }

  Widget _subscriptionWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    activeColor: Colors.transparent,
                    checkColor: Colors.teal,
                    value: _agreeTOS,
                    onChanged: (value) {
                      setState(() {
                        _agreeTOS = value;
                      });
                    }),
                Text(
                  'By checking this box you are agreeing\n  to our terms of service',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blue[500],
                      fontSize: screenAwareSize(12, context),
                      fontFamily: 'Roboto-Regular'),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                  activeColor: Colors.transparent,
                  checkColor: Colors.teal,
                  value: _allowEmails,
                  onChanged: (value) {
                    setState(() {
                      _allowEmails = value;
                    });
                  }),
              Text(
                'Can we send you promos, deals,\n and other fun stuff?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue[500],
                    fontSize: screenAwareSize(12, context),
                    fontFamily: 'Roboto-Regular'),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _checkPasswords() {
    setState(() {
      if (tmpPwd == tmpPwd2) {
        _signupForm['password'] = tmpPwd2.replaceAll(' ', '');
      } else {
        print('Passwords Do Not Match');
        _signupForm['password'] = null;
      }
    });
  }
}

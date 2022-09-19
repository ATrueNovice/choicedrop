import 'dart:convert';
import 'package:choicedrop/APIS/model/userProfile.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountInfo extends StatefulWidget {
  @override
  State createState() => _AccountInfo();
}

class _AccountInfo extends State<AccountInfo> with TickerProviderStateMixin {
  final _phoneFocus = FocusNode();

  File currentSelfie;
  final nickNameFocus = FocusNode();
  dynamic _userDetails;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();

  List _type = ["Hybrid", "Indica", "Sativa", " No Preferences"];
  List _level = ["Newbie", "Experienced", "Canna-Veteran"];
  List _customerType = ["Medical", "Recreational"];

  String nickName;
  String _preferedStrainType;
  String _selectedFeelings;
  String _selectedLevel;
  String _needsHelpWith;
  String _customerTypeUpdate;
  int sharedValue = 0;

  bool _editAccount = false;
  bool _editPref = false;
  bool _editPhoto = false;
  String _phone = '';
  String _address;
  var previousOrders;

  final Map<int, Widget> logoWidgets = const <int, Widget>{
    0: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text('Profile',
            style: TextStyle(fontFamily: 'Roboto-Regular', fontSize: 14))),
  };

  //Map Data

  List _feelings = [
    "Arousal",
    "Creative",
    "Energetic",
    "Euphoric",
    "Focused",
    "Giggly",
    "Happy",
    "Hungry",
    "Relaxed",
    "Sleepy",
    "Talkative",
    "Tingly",
    "Uplifted"
  ];

  final Map<int, Widget> userDetailsSegment = <int, Widget>{
    0: null,
    1: null,
  };

  Map<String, dynamic> _detailUpdateMap = {'phone': ''};

  List _usage = [
    'Headache',
    'Insomnia',
    'Being Social',
    'First Timers',
    'Body High',
    'Cramps & Pains',
    'Stress',
    'Creativity',
    'Productivity',
  ];

  final GlobalKey<FormState> _updateAccountInfoKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _updatePreferenceInfoKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _updatePhotoInfoKey = GlobalKey<FormState>();

  Future getImage(bool isCamera) async {
    File image;

    if (isCamera) {
      image = File(await ImagePicker()
          .getImage(source: ImageSource.camera)
          .then((pickedFile) => pickedFile.path)
          .catchError((e) {
        print('e');
      }));
    } else {
      image = File(await ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((pickedFile) => pickedFile.path)
          .catchError((e) {
        print('e');
      }));
    }

    setState(() {
      currentSelfie = image;
      _detailUpdateMap['current_selfie'] =
          base64Encode(currentSelfie.readAsBytesSync());
    });
  }

  void signOut() {
    // logOut();
    removeValues();
    Navigator.of(context).pushReplacementNamed("/landingscreen");
  }

  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('vaildToken');
    var token = prefs.getString('token');
    print('Emptied Token $token');
  }

  @override
  void initState() {
    _userDetails = customerProfile;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userDetailsSegment[0] = _buildPageDetails(_userDetails);
    });
    sharedValue = 0;
    print(sharedValue);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateUser() {
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
          seconds: 2,
        ), () {
      setState(() {
        _userDetails = customerProfile;
        _editAccount = false;
        _editPref = false;
        _editPhoto = false;
      });
      print(_userDetails);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          elevation: 8.0,
          title: Text('Choice Drop'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.questionCircle,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/MoreInfo');
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.white,
              ),
              onPressed: () {
                signOut();
              },
            )
          ],
        ),
        body: SafeArea(
          child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: <Widget>[
                    _buildTopHeader(context),
                    _buddiesData()
                  ]),
                ),
              )),
        ));
  }

  //  _editPref == false ? Container() : _updatePrefrenceForm(),
  //           _editPref == false ? Container() : _submitButton('Submit')

  Widget _editAccountWidget() {
    return Container(
      child: Column(
        children: [
          _accountUpdate(),
          _submitButton('Submit', _updateAccountInfoKey)
        ],
      ),
    );
  }

  Widget _editPreferenceWidget() {
    return Container(
      child: Column(
        children: [
          _updatePrefrenceForm(),
          _submitButton('Submit', _updatePreferenceInfoKey)
        ],
      ),
    );
  }

  Widget _buddiesData() {
    userDetailsSegment[0] = _buildPageDetails(_userDetails);

    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  elevation: 20.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Profile',
                        style: TextStyle(
                            fontFamily: 'Roboto-Regular', fontSize: 14)),
                  ),
                )),
          ),
          Container(
            child: Container(child: userDetailsSegment[sharedValue]),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Form(
        key: _updatePhotoInfoKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
              Card(
                elevation: 8.0,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Preferences",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              //     Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: SizedBox(
              //             width: MediaQuery.of(context).size.width / 2,
              //             child: darkModeActive
              //                 ? _titleText(_titleWidget())
              //                 : _titleWidget()),
              //       ),
              //     // : _photoBuilderWidget(),
              // SizedBox(
              //   height: screenAwareSize(10, context),
              // ),
              SizedBox(
                height: 20,
              ),
            ]),
      ),
    );
  }

  Widget _titleText(widget) {
    return Card(elevation: 8, color: Colors.white, child: widget);
  }

  Widget _titleWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Update Profile Pic',
            style: TextStyle(color: Colors.black),
          ),
          IconButton(
              icon: Icon(FontAwesomeIcons.pen),
              splashColor: Colors.yellow,
              focusColor: Colors.yellow,
              color: Colors.black,
              iconSize: screenAwareSize(8, context),
              onPressed: () {
                setState(() {
                  _editPhoto = !_editPhoto;
                });
              }),
        ],
      ),
    );
  }

  Widget _photoBuilderWidget() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Add A Profile Pic',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlinedButton.icon(
                    // shape: StadiumBorder(),
                    icon: Icon(
                      Icons.camera,
                      color: Colors.blue,
                      size: 20,
                    ),
                    label: Text(
                      'Selfie',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      getImage(true);
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  OutlinedButton.icon(
                    // shape: StadiumBorder(),
                    icon: Icon(
                      Icons.photo_size_select_actual,
                      color: Colors.blue,
                    ),
                    label: Text(
                      'Or Gallery',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      getImage(false);
                    },
                  ),
                ],
              ),
              _editPhoto == false
                  ? _submitButton('Edit Photo', _updatePhotoInfoKey)
                  : currentSelfie == null
                      ? GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.ban,
                                        size: screenAwareSize(12, context),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _editPhoto = !_editPhoto;
                            });
                          },
                        )
                      : _submitButton('Submit Photo', _updatePhotoInfoKey)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageDetails(_userDetails) {
    return Container(
      child: Column(
        children: [
          Card(
            elevation: 8.0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 6.0, left: 8.0, bottom: 6.0),
                        child: Text(
                          "Info",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Name',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                        ),
                        Text(
                          '${_userDetails.firstName} ${_userDetails.lastName}',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Divider(
                      height: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _editAccount == false ? _accountHalf() : _editAccountWidget(),
          // _editPref == false ? _preferenceHalf() : _editPreferenceWidget()
        ],
      ),
    );
  }

  Widget _accountHalf() {
    return Container(
      child: Card(
        elevation: 4.0,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Account",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                  IconButton(
                      icon: Icon(FontAwesomeIcons.pen),
                      iconSize: 12,
                      color: Colors.grey,
                      onPressed: () {
                        setState(() {
                          _editAccount = !_editAccount;
                        });
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Address',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                  ),
                  Container(
                    width: screenAwareSize(150, context),
                    child: Text(
                      _userDetails.address != null
                          ? '${_userDetails.address}'
                          : '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Divider(
                height: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Text(
                  //   'Phone',
                  //   style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                  // ),
                  // Text(
                  //   _userDetails.phone != null ? '${_userDetails.phone}' : '',
                  //   style: TextStyle(
                  //       fontFamily: 'Roboto-Regular',
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 14),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Divider(
                height: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _preferenceHalf() {
    return Container(
      child: Card(
        elevation: 4.0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Preferences",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                        icon: Icon(FontAwesomeIcons.pen),
                        color: Colors.grey,
                        iconSize: 12,
                        onPressed: () {
                          setState(() {
                            _editPref = !_editPref;
                          });
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Divider(
                  height: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'I Need Help With',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                    ),
                    Text(
                      '}',
                      style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Divider(
                  height: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'I Want To Feel',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                    ),
                    Text(
                      ' ',
                      style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Divider(
                  height: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Canna-Level',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                    ),
                    Text(
                      '',
                      style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Divider(
                  height: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Favorite Strain',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                    ),
                    Text(
                      '',
                      style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Divider(
                  height: 2,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountUpdate() {
    return Container(
        child: Form(
      key: _updateAccountInfoKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  icon: Icon(FontAwesomeIcons.pen),
                  color: Colors.yellow,
                  iconSize: 12,
                  onPressed: () {
                    setState(() {
                      _editAccount = !_editAccount;
                    });
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Address:',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              _addressBuilderWidget(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Phone:',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              _phoneWidget(),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _updatePrefrenceForm() {
    return Container(
        child: Form(
      key: _updatePreferenceInfoKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  icon: Icon(FontAwesomeIcons.pen),
                  color: Colors.yellow,
                  iconSize: 12,
                  onPressed: () {
                    setState(() {
                      _editPref = !_editPref;
                    });
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Customer Type',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              _customerPreference(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'I Need Help With',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              _helpsWithDropdown(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'I Want To Feel',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              _feelingDropdown()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Canna-Level',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              _cannaLevelField(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Favorite Strain',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              _favStrainFields()
            ],
          )
        ],
      ),
    ));
  }

  Widget _addressBuilderWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            '',
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 14, color: Colors.black),
          ),
          _address == null
              ? MaterialButton(
                  onPressed: _getAddress,
                  elevation: 8,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  child: Text(
                    'Enter Address',
                    style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14),
                  ),
                )
              : _addressTextField(_address)
        ],
      ),
    );
  }

  Widget _addressTextField(address) {
    return GestureDetector(
      onTap: _getAddress,
      child: Row(
        children: <Widget>[
          Container(
            width: screenAwareSize(140, context),
            child: Text(
              _address,
              maxLines: 2,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          Icon(
            FontAwesomeIcons.edit,
            size: 12,
            color: Colors.yellow,
          )
        ],
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
            _address = place.placeName;

            setState(() {
              _addressUpdate(_address);
            });

            print(_address);

            return _address;
          },
          limit: 10,
          country: "US",
        ),
      ),
    );
  }

  Widget _phoneWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '',
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 14, color: Colors.black),
          ),
          Container(
            height: 75,
            width: screenAwareSize(130, context),
            child: TextFormField(
              textAlign: TextAlign.center,
              maxLength: 10,
              focusNode: _phoneFocus,
              controller: _phoneController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: '555-555-5555',
              ),
              validator: (String value) {
                if (value.isEmpty || value.length < 10) {
                  return 'Invaild Number';
                } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                  return 'Numbers only';
                }
              },
              onChanged: (value) {
                setState(() => _phone = value);
                _phoneUpdate(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _helpsWithDropdown() {
    return DropdownButton(
      hint: Text(_userDetails.needsHelpWith),
      value: _needsHelpWith,
      onChanged: (newValue) {
        _changeHelpsWith(newValue);
      },
      items: _usage.map((helpsWith) {
        return DropdownMenuItem(
          child: Text(helpsWith),
          value: helpsWith,
        );
      }).toList(),
    );
  }

  Widget _submitButton(details, _stateKey) {
    final form = _stateKey.currentState;

    return Container(
      child: Column(
        children: [
          SizedBox(
            height: screenAwareSize(10, context),
          ),
          Center(
            child: RaisedButton.icon(
              icon: Icon(
                FontAwesomeIcons.checkCircle,
                color: Colors.blue,
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 8,
              onPressed: () {
                print("Check the deets: ");
                print(_detailUpdateMap);

                // if (form.validate()) {
                //   form.save();

                // _detailUpdateMap.length > 0
                //     ? customerSingleUpdate(_detailUpdateMap).then((value) {
                //         setState(() {
                //           _editPref = !_editPref;
                //         });
                //       })
                //     : print('No Updates To Be Made');
                // _updateUser();
                // } else {
                //   print('Cant upload a damn thing');
                //   print(_detailUpdateMap.values);
                // }
              },
              label: Text(
                'Submit',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customerPreference() {
    return DropdownButton(
      hint: Text(_userDetails.customerType),
      value: _customerTypeUpdate,
      onChanged: (newValue) {
        _changedCusType(newValue);
      },
      items: _customerType.map((type) {
        return DropdownMenuItem(
          child: Text(type),
          value: type,
        );
      }).toList(),
    );
  }

  Widget _feelingDropdown() {
    return DropdownButton(
      hint: Text(_userDetails.feel),
      value: _selectedFeelings,
      onChanged: (newValue) {
        _changeFeeling(newValue);
      },
      items: _feelings.map((feels) {
        return DropdownMenuItem(
          child: Text(feels),
          value: feels,
        );
      }).toList(),
    );
  }

  Widget _cannaLevelField() {
    return DropdownButton(
      hint: Text(_userDetails.level),
      value: _selectedLevel,
      onChanged: (newValue) {
        _changedLevel(newValue);
      },
      items: _level.map((lvls) {
        return DropdownMenuItem(
          child: Text(lvls),
          value: lvls,
        );
      }).toList(),
    );
  }

  Widget _favStrainFields() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: Text(_userDetails.preferedStrain),
        value: _preferedStrainType,
        onChanged: (newValue) {
          setState(() {
            _strainType(newValue);
          });
        },
        items: _type.map((favStrain) {
          return DropdownMenuItem(
            child: Text(
              favStrain,
            ),
            value: favStrain,
          );
        }).toList(),
      ),
    );
  }

  Widget _likes(products) {
    print('Printing likes');
    print(products[0]);
    return Card(
      elevation: 8.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 6.0, bottom: 6),
              child: Row(
                children: [
                  Text(
                    "My Likes",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenAwareSize(30, context),
            ),
            Container(
              height: screenAwareSize(400, context),
              child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 14.0, right: 12.0),
                    child: InkWell(
                      onTap: () {
                        //

                        print('ID is: ${products[i].dispensaryId.id}');

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => DispensaryHome(
                        //             id: products[i].dispensaryId.id,
                        //             dispensary: products[i].dispensaryId)));
                      },
                      child: Container(
                        child: Stack(children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: screenAwareSize(80, context),
                                height: screenAwareSize(80, context),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    image: DecorationImage(
                                        image: NetworkImage(products[i].image),
                                        fit: BoxFit.fill)),
                              ),
                              Text(
                                products[i].name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              // Text('Body Pains, Heaaches'),
                            ],
                          ),
                          Positioned(
                              right: 5,
                              child: Icon(
                                FontAwesomeIcons.plusCircle,
                                size: 12,
                                color: Colors.blue,
                              ))
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _history(BuildContext context, pOrders) {
    return Container(
      // height: 400,
      child: ListView.builder(
        itemCount: 1,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return Container(
              child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '9/1/2019 ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[_topHeader(context)],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ));
        },
      ),
    );
  }

  Widget _rated(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        return Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '_prodName',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              iconSize: 10,
                              icon: Icon(
                                FontAwesomeIcons.pen,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                            Text(
                              'Special Instructions',
                              style: TextStyle(
                                  fontFamily: 'Roboto-Regular', fontSize: 10),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(FontAwesomeIcons.trash),
                              iconSize: 10,
                            ),
                            Text(
                              'Remove',
                              style: TextStyle(
                                  fontFamily: 'Roboto-Regular', fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '_price',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget _topHeader(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            '${previousOrders.order.OrderDetails.length}',
            style: TextStyle(color: Colors.grey),
          ),
          Container(
            height: 95,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return Container(
                  decoration: BoxDecoration(),
                  child: Text(
                      '${previousOrders.order.orderDetails[i].quantity}x ${previousOrders.order.name}'),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _showDialog(_title, _content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text(
            _title,
            textAlign: TextAlign.center,
          ),
          content: _content,
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changeFeeling(String newValue) {
    setState(() {
      _selectedFeelings = newValue;
      _detailUpdateMap['wants_to_feel'] = newValue;
    });
  }

  void _changeHelpsWith(String newValue) {
    setState(() {
      _needsHelpWith = newValue;
      _detailUpdateMap['needs_help_with'] = newValue;
    });
  }

  void _changedLevel(String newValue) {
    setState(() {
      _selectedLevel = newValue;
      _detailUpdateMap['level'] = newValue;
    });
  }

  void _changedCusType(String newValue) {
    setState(() {
      _customerTypeUpdate = newValue;
      _detailUpdateMap['customer_type'] = newValue;
    });
  }

  void _strainType(String newValue) {
    setState(() {
      _preferedStrainType = newValue;
      _detailUpdateMap['prefered_strain_type'] = newValue;
    });
  }

  void _addressUpdate(String newValue) {
    setState(() {
      _address = newValue;
      _detailUpdateMap['address'] = newValue;
    });
  }

  void _phoneUpdate(String newValue) {
    setState(() {
      _phone = newValue;
      _detailUpdateMap['phone'] = newValue;
    });
  }
}

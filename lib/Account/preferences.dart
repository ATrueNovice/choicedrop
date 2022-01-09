// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'dart:io';

// class Preferences extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return _Preferences();
//   }
// }

// class _Preferences extends StatefulWidget {
//   @override
//   _PreferencesState createState() => new _PreferencesState();
// }

// class _PreferencesState extends State<_Preferences>
//     with TickerProviderStateMixin {
//   late File currentSelfie;
//   bool vaildForm = false;
//   var currentPageValue = 1;
//   String name = '';
//   late String error;
//   late Uint8List data;
//   bool _oldEnough = false;

//   late PageController _pageController;

//   Future getImage(bool isCamera) async {
//     File image;

//     if (isCamera) {
//       image = File(await ImagePicker()
//           .getImage(source: ImageSource.camera)
//           .then((pickedFile) => pickedFile.path)
//           .catchError((e) {
//         print('e');
//       }));
//     } else {
//       image = File(await ImagePicker()
//           .getImage(source: ImageSource.gallery)
//           .then((pickedFile) => pickedFile.path)
//           .catchError((e) {
//         print('e');
//       }));
//     }
//     setState(() {
//       currentSelfie = image;
//       _accDetails['customer_selfie'] = currentSelfie;
//     });
//   }

//   final _preferenceScaffoldKey = GlobalKey<ScaffoldState>();
//   final GlobalKey<FormState> _accountKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _preferenceKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _scannerKey = GlobalKey<FormState>();

//   final nickNameFocus = FocusNode();
//   final _phoneFocus = FocusNode();

//   TextEditingController nickNameController = TextEditingController();
//   TextEditingController _phoneController = TextEditingController();
//   TextEditingController _addressController = TextEditingController();
//   int index = 0;

//   List _customerType = ["Medical", "Recreational"];

//   List _usage = [
//     'Headache',
//     'Insomnia',
//     'Being Social',
//     'First Timers',
//     'Cramps & Pains',
//     'Body Pains',
//     'Stress and Tension',
//     'Creativity',
//     'Productivity',
//     'Accessory',
//   ];

//   List _level = ["Newbie", "Experienced", "Canna-Veteran"];
//   List _preferredStrain = ["Hybrid", "Indica", "Sativa", "No Preference"];

//   List _feelings = [
//     "Arousal",
//     "Creative",
//     "Energetic",
//     "Euphoric",
//     "Focused",
//     "Giggly",
//     "Happy",
//     "Hungry",
//     "Relaxed",
//     "Sleepy",
//     "Talkative",
//     "Tingly",
//     "Uplifted"
//   ];

//   List _createRec = [];

//   late String _selectedCustomerType;
//   late String _helpsWith;
//   late String _selectedFeelings;
//   late String _selectedLevel;
//   late String _strainPreference;
//   late String nickName;
//   late String _phone;
//   late String _address;
//   late String _ageValue = '1';
//   var dob = '';

//   String _resultString = "";
//   String _fullDocumentFrontImageBase64 = "";
//   String _faceImageBase64 = "";

//   String textA = '';
//   String textB = '';

//   List<DropdownMenuItem<String>> _dropDownMenuItems;

//   double age = 0.0;

//   var selectedYear;
//   Animation animation;
//   AnimationController animationController;

//   @override
//   void initState() {
//     _pageController = PageController(initialPage: 0);

//     super.initState();

//     animationController = AnimationController(
//         vsync: this, duration: Duration(milliseconds: 1500));
//     animation = animationController;
//   }

//   void signOut() {
//     // logOut();
//     removeValues();
//     Navigator.of(context).pushReplacementNamed("/landingscreen");
//   }

//   removeValues() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('token');
//     prefs.remove('vaildToken');
//     var token = prefs.getString('token');
//     print('Emptied Token $token');
//   }

//   Map<String, dynamic> _accDetails = {
//     'customer_selfie': null,
//     'address': null,
//     'phone': null,
//   };

//   Map<String, dynamic> _prefDetails = {
//     'customer_type': null,
//     'needs_help_with': null,
//     'wants_to_feel': null,
//     'level': null,
//     'prefered_strain_type': null,
//   };

//   Map<String, dynamic> _scanDetails = {
//     'sex': null,
//     'age': null,
//     'gov_name': null,
//     'license_photo': null,
//     'sm_photo': null,
//   };

//   @override
//   void dispose() {
//     animationController.dispose();

//     nickNameController.dispose();
//     _phoneController.dispose();

//     super.dispose();
//   }

//   bool isValidPhoneNumber(String input) {
//     final RegExp regex = new RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
//     return regex.hasMatch(input);
//   }

//   void _changeCustomerType(String newValue) {
//     setState(() {
//       _selectedCustomerType = newValue;
//       _prefDetails['customer_type'] = _selectedCustomerType;
//     });
//   }

//   void _changeAssist(String newValue) {
//     setState(() {
//       _helpsWith = newValue;
//       _prefDetails['needs_help_with'] = _helpsWith;
//     });
//   }

//   void _changeFeelings(String newValue) {
//     setState(() {
//       _selectedFeelings = newValue;
//       _prefDetails['wants_to_feel'] = _selectedFeelings;
//     });
//   }

//   void _changeLevel(String newValue) {
//     setState(() {
//       _selectedLevel = newValue;
//       _prefDetails['level'] = _selectedLevel;
//     });
//   }

//   void _changeFavoriteStrain(String newValue) {
//     setState(() {
//       _strainPreference = newValue;
//       _prefDetails['prefered_strain_type'] = _strainPreference;
//     });
//   }

//   void _getPhoneNumb(String newValue) {
//     setState(() {
//       _phone = newValue;
//       _accDetails['phone'] = _phone;
//     });
//   }

//   void showMessage(String message, [MaterialColor color = Colors.red]) {
//     _preferenceScaffoldKey.currentState
//         .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
//   }

// //Blink ID

//   Future<void> scan() async {
//     String license;
//     if (Theme.of(context).platform == TargetPlatform.iOS) {
//       license = iosScanKey;
//     } else if (Theme.of(context).platform == TargetPlatform.android) {
//       license = androidScanKey;
//     } else {
//       license = "";
//     }

//     var idRecognizer = BlinkIdCombinedRecognizer();
//     idRecognizer.returnFullDocumentImage = true;
//     idRecognizer.returnFaceImage = true;

//     BlinkIdOverlaySettings settings = BlinkIdOverlaySettings();

//     var results = await MicroblinkScanner.scanWithCamera(
//         RecognizerCollection([idRecognizer]), settings, license);

//     if (!mounted) return;

//     if (results.length == 0) return;
//     for (var result in results) {
//       if (result is BlinkIdCombinedRecognizerResult) {
//         if (result.mrzResult?.documentType == MrtdDocumentType.Passport) {
//           _resultString = getPassportResultString(result);
//         } else {
//           _resultString = getIdResultString(result);
//         }

//         setState(() {
//           _resultString = _resultString;
//           _fullDocumentFrontImageBase64 = result.fullDocumentFrontImage ?? "";
//           _faceImageBase64 = result.faceImage ?? "";
//         });

//         return;
//       }
//     }
//   }

//   String getIdResultString(BlinkIdCombinedRecognizerResult result) {
//     String name = '${result.firstName} ${result.lastName}';

//     setState(() {
//       _scanDetails['age'] = result.age;
//       _scanDetails['sex'] = result.sex;
//       _scanDetails['gov_name'] = name;
//       if (result.age > 20) {
//         _oldEnough = true;
//       }
//     });
//     return buildResult(result.firstName, "First name") +
//         buildResult(result.lastName, "Last name") +
//         buildResult(result.fullName, "Full name") +
//         buildResult(result.sex, "Sex") +
//         buildDateResult(result.dateOfBirth, "Date of birth") +
//         buildIntResult(result.age, "Age") +
//         buildDateResult(result.dateOfExpiry, "Date of expiry");
//   }

//   String buildResult(String result, String propertyName) {
//     if (result == null || result.isEmpty) {
//       return "";
//     }

//     return propertyName + ": " + result + "\n";
//   }

//   String buildDateResult(Date result, String propertyName) {
//     if (result == null || result.year == 0) {
//       return "";
//     }

//     return buildResult(
//         "${result.month}.${result.day}.${result.year}", propertyName);
//   }

//   String buildIntResult(int result, String propertyName) {
//     if (result == null || result < 0) {
//       return "";
//     }

//     return buildResult(result.toString(), propertyName);
//   }

//   String buildDriverLicenceResult(DriverLicenseDetailedInfo result) {
//     if (result == null) {
//       return "";
//     }

//     return "";
//   }

//   String getPassportResultString(BlinkIdCombinedRecognizerResult result) {
//     if (result == null) {
//       return "";
//     }

//     var dateOfBirth = "";
//     if (result.mrzResult?.dateOfBirth != null) {
//       dateOfBirth = "Date of birth: ${result.mrzResult.dateOfBirth?.day}."
//           "${result.mrzResult.dateOfBirth?.month}."
//           "${result.mrzResult.dateOfBirth?.year}\n";
//     }

//     var dateOfExpiry = "";
//     if (result.mrzResult?.dateOfExpiry != null) {
//       dateOfExpiry = "Date of expiry: ${result.mrzResult?.dateOfExpiry?.day}."
//           "${result.mrzResult?.dateOfExpiry?.month}."
//           "${result.mrzResult?.dateOfExpiry?.year}\n";
//     }

//     return "First name: ${result.mrzResult?.secondaryId}\n"
//         "Last name: ${result.mrzResult?.primaryId}\n"
//         "Document number: ${result.mrzResult?.documentNumber}\n"
//         "Sex: ${result.mrzResult?.gender}\n"
//         "$dateOfBirth"
//         "$dateOfExpiry";
//   }

//   @override
//   Widget build(BuildContext context) {
//     List pages = [_firstPage(), _secondPage(), _scannerPage()];

//     return Scaffold(
//       key: _preferenceScaffoldKey,
//       appBar: AppBar(
//           centerTitle: true,
//           // automaticallyImplyLeading: false,
//           elevation: 8,
//           backgroundColor: hlGreen,
//           title: buddiesLogo,
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(
//                 FontAwesomeIcons.signOutAlt,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 signOut();
//               },
//             )
//           ]),
//       body: Column(children: <Widget>[
//         Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     "The hii-line \nTo Happiness ",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: hlPurple,
//                       // decoration: TextDecoration.underline,
//                       fontFamily: 'Poppins',
//                       fontSize: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         Expanded(
//             flex: 2,
//             child: IndexedStack(
//               index: index,
//               children: <Widget>[
//                 PageView.builder(
//                   physics: NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, i) {
//                     return pages[i];
//                   },
//                   itemCount: pages.length,
//                   controller: _pageController,
//                 )
//               ],
//             )),
//       ]),
//     );
//   }

//   Widget _firstPage() {
//     return Form(
//       key: _accountKey,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Container(
//               child: Column(
//             children: <Widget>[
//               _photoBuilderWidget(),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Account",
//                   style: TextStyle(
//                       fontFamily: 'Poppins', color: hlPurple, fontSize: 16),
//                   textAlign: TextAlign.left,
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               //address
//               _addressBuilderWidget(),
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Divider(
//                   height: 2,
//                 ),
//               ),
//               //Phone
//               _phoneWidget(),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: MaterialButton(
//                     elevation: 8,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                     color: hlGreen,
//                     child: Text(
//                       'Submit',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () {
//                       _checkData();
//                     }),
//               )
//             ],
//           )),
//         ),
//       ),
//     );
//   }

//   Widget _secondPage() {
//     return Form(
//       key: _preferenceKey,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             child: Column(children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     "Preferences",
//                     style: TextStyle(
//                         fontFamily: 'Poppins',
//                         color: hlPurple,
//                         fontSize: screenAwareSize(16, context)),
//                     textAlign: TextAlign.center,
//                   ),
//                   IconButton(
//                       icon: Icon(FontAwesomeIcons.listAlt),
//                       color: hlGreen,
//                       iconSize: 12,
//                       onPressed: () {
//                         // _showPopup();
//                       }),
//                 ],
//               ),
//               SizedBox(
//                 height: screenAwareSize(10, context),
//               ),
//               _cusTypeWidget(),
//               Padding(
//                 padding: const EdgeInsets.all(6.0),
//                 child: Divider(
//                   height: 2,
//                 ),
//               ),
//               _helpsWithWidget(),
//               Padding(
//                 padding: const EdgeInsets.all(6.0),
//                 child: Divider(
//                   height: 2,
//                 ),
//               ),
//               _desiredEffect(),
//               Padding(
//                 padding: const EdgeInsets.all(6.0),
//                 child: Divider(
//                   height: 2,
//                 ),
//               ),
//               _levelWidget(),
//               Padding(
//                 padding: const EdgeInsets.all(6.0),
//                 child: Divider(
//                   indent: 60,
//                   endIndent: 60,
//                   height: 2,
//                 ),
//               ),
//               _favoriteStrain(),
//               Padding(
//                   padding: const EdgeInsets.all(6.0),
//                   child: Divider(
//                     height: 2,
//                   )),
//               MaterialButton(
//                   elevation: 12,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                   color: hlGreen,
//                   child: Text(
//                     'Next',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     _secondPageSubmit();
//                   })
//             ]),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _scannerPage() {
//     Widget fullDocumentFrontImage = Container();
//     if (_fullDocumentFrontImageBase64 != null &&
//         _fullDocumentFrontImageBase64 != "") {
//       fullDocumentFrontImage = Column(
//         children: <Widget>[
//           Text("Document Front Image:"),
//           Image.memory(
//             Base64Decoder().convert(_fullDocumentFrontImageBase64),
//             height: 180,
//             width: 350,
//           )
//         ],
//       );
//       setState(() {
//         _scanDetails['license_photo'] = _fullDocumentFrontImageBase64;
//       });
//     }

//     Widget faceImage = Container();
//     if (_faceImageBase64 != null && _faceImageBase64 != "") {
//       faceImage = Column(
//         children: <Widget>[
//           Text("Face Image:"),
//           Image.memory(
//             Base64Decoder().convert(_faceImageBase64),
//             height: 150,
//             width: 100,
//           )
//         ],
//       );

//       setState(() {
//         _scanDetails['sm_photo'] = _faceImageBase64;
//       });
//     }

//     return Form(
//       key: _scannerKey,
//       child: Container(
//         child: SingleChildScrollView(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               children: <Widget>[
//                 _resultString == ""
//                     ? Text('We Got To Card Ya!',
//                         style: TextStyle(fontSize: 16, color: Colors.white))
//                     : Text('Verify Your Information:',
//                         style: TextStyle(fontSize: 16, color: Colors.white)),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: MaterialButton(
//                     elevation: 8,
//                     color: hlGreen,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                     child: _resultString == ""
//                         ? Text("Please Provide Valid ID!",
//                             style: TextStyle(fontSize: 16, color: Colors.white))
//                         : Text("Submit",
//                             style:
//                                 TextStyle(fontSize: 16, color: Colors.white)),
//                     onPressed: () => _resultString == "" ? scan() : _submit(),
//                   ),
//                 ),
//                 Text(_resultString),
//                 faceImage,
//                 fullDocumentFrontImage,
//               ],
//             )),
//       ),
//     );
//   }

//   Widget _photoBuilderWidget() {
//     return Container(
//       child: Column(children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 10.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: currentSelfie == null
//                     ? CircleAvatar(
//                         backgroundColor: hlGreen,
//                         radius: 60.0,
//                         child: Icon(Icons.account_circle,
//                             size: 80, color: Colors.white),
//                       )
//                     : Image.file(
//                         currentSelfie,
//                         height: screenAwareSize(100, context),
//                         width: screenAwareSize(100, context),
//                         fit: BoxFit.fill,
//                       ),
//               ),
//               Text(
//                 'Add A Profile Pic',
//                 style: TextStyle(color: hlPurple, fontSize: 16),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   OutlineButton.icon(
//                     shape: StadiumBorder(),
//                     icon: Icon(
//                       Icons.camera,
//                       color: hlGreen,
//                       size: 20,
//                     ),
//                     label: Text(
//                       'Selfie',
//                       style: TextStyle(color: hlPurple),
//                     ),
//                     onPressed: () {
//                       getImage(true);
//                     },
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   OutlineButton.icon(
//                     shape: StadiumBorder(),
//                     icon: Icon(
//                       Icons.photo_size_select_actual,
//                       color: hlGreen,
//                     ),
//                     label: Text(
//                       'Or Gallery',
//                       style: TextStyle(color: hlPurple),
//                     ),
//                     onPressed: () {
//                       getImage(false);
//                     },
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ]),
//     );
//   }

//   void _getAddress() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MapBoxAutoCompleteWidget(
//           apiKey: mapboxKey,
//           hint: "Enter Address",
//           onSelect: (place) {
//             _addressController.text = place.placeName;

//             setState(() {
//               _address = _addressController.text;
//               _accDetails['address'] = _address;
//             });

//             print(_addressController.text);

//             return _addressController.text;
//           },
//           limit: 10,
//           country: "US",
//         ),
//       ),
//     );
//   }

//   Widget _addressBuilderWidget() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text(
//             'Address',
//             style:
//                 TextStyle(fontFamily: 'Poppins', fontSize: 14, color: hlPurple),
//           ),
//           _address == null
//               ? MaterialButton(
//                   onPressed: _getAddress,
//                   elevation: 8,
//                   color: hlGreen,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Text(
//                     'Enter Address',
//                     style: TextStyle(
//                         fontFamily: 'Roboto-Regular',
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontSize: 14),
//                   ),
//                 )
//               : Container(
//                   width: screenAwareSize(150, context),
//                   child: Text(
//                     _addressController.text,
//                     maxLines: 5,
//                     softWrap: true,
//                   ))
//         ],
//       ),
//     );
//   }

//   Widget _phoneWidget() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text(
//             'Phone',
//             style:
//                 TextStyle(fontFamily: 'Poppins', fontSize: 14, color: hlPurple),
//           ),
//           Container(
//             height: 75,
//             width: screenAwareSize(130, context),
//             child: EnsureVisibleWhenFocused(
//               focusNode: _phoneFocus,
//               child: TextFormField(
//                 textAlign: TextAlign.center,
//                 maxLength: 10,
//                 controller: _phoneController,
//                 keyboardType: TextInputType.number,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: '5555555555',
//                 ),
//                 validator: (String value) {
//                   if (value.isEmpty || value.length < 10) {
//                     return 'Invaild Number';
//                   } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
//                     return 'Numbers only';
//                   } else {
//                     _phone = value;
//                     setState(() {
//                       _accDetails['phone'] = value;
//                     });
//                   }
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _cusTypeWidget() {
//     return Container(
//       height: screenAwareSize(55, context),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               'Customer Type',
//               style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
//             ),
//             Container(
//                 width: screenAwareSize(135, context),
//                 child: DropdownButtonFormField(
//                   value: _selectedCustomerType,
//                   onChanged: (newValue) {
//                     setState(() {
//                       _changeCustomerType(newValue);
//                     });
//                   },
//                   validator: (value) => value == null ? 'field required' : null,
//                   items: _customerType.map((type) {
//                     return DropdownMenuItem(
//                       child: Text(
//                         type,
//                         style: TextStyle(color: hlPurple, fontSize: 14),
//                       ),
//                       value: type,
//                     );
//                   }).toList(),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _helpsWithWidget() {
//     return Container(
//       height: screenAwareSize(55, context),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               'I Need Help With',
//               style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
//             ),
//             Container(
//               width: screenAwareSize(150, context),
//               height: screenAwareSize(55, context),
//               child: DropdownButtonFormField(
//                 itemHeight: screenAwareSize(50, context),
//                 value: _helpsWith,
//                 onChanged: (newValue) {
//                   setState(() {
//                     _changeAssist(newValue);
//                   });
//                 },
//                 validator: (value) => value == null ? 'field required' : null,
//                 items: _usage.map((usage) {
//                   return DropdownMenuItem(
//                     child: Text(
//                       usage,
//                       style: TextStyle(color: hlPurple, fontSize: 14),
//                     ),
//                     value: usage,
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _levelWidget() {
//     return Container(
//       height: screenAwareSize(55, context),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               'Canna-Level',
//               style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
//             ),
//             Container(
//               width: screenAwareSize(135, context),
//               child: DropdownButtonFormField(
//                 value: _selectedLevel,
//                 onChanged: (newValue) {
//                   setState(() {
//                     _selectedLevel = newValue;
//                     _changeLevel(newValue);
//                   });
//                 },
//                 validator: (value) => value == null ? 'field required' : null,
//                 items: _level.map((levels) {
//                   return DropdownMenuItem(
//                     child: Text(
//                       levels,
//                       style: TextStyle(color: hlPurple, fontSize: 14),
//                     ),
//                     value: levels,
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _favoriteStrain() {
//     return Container(
//       height: screenAwareSize(55, context),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               'Favorite Strain',
//               style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
//             ),
//             Container(
//               width: screenAwareSize(135, context),
//               child: DropdownButtonFormField(
//                 value: _strainPreference,
//                 onChanged: (newValue) {
//                   setState(() {
//                     _changeFavoriteStrain(newValue);
//                   });
//                 },
//                 validator: (value) => value == null ? 'field required' : null,
//                 items: _preferredStrain.map((strains) {
//                   return DropdownMenuItem(
//                     child: Text(
//                       strains,
//                       style: TextStyle(color: hlPurple, fontSize: 14),
//                     ),
//                     value: strains,
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _desiredEffect() {
//     return Container(
//       height: screenAwareSize(55, context),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               'I Want To Feel',
//               style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
//             ),
//             Container(
//                 width: screenAwareSize(135, context),
//                 // color: Colors.white,
//                 child: DropdownButtonFormField(
//                   value: _selectedFeelings,
//                   onChanged: (newValue) {
//                     setState(() {
//                       _changeFeelings(newValue);
//                     });
//                   },
//                   validator: (value) => value == null ? 'field required' : null,
//                   items: _feelings.map((feelings) {
//                     return DropdownMenuItem(
//                       child: Text(
//                         feelings,
//                         style: TextStyle(color: hlPurple, fontSize: 14),
//                       ),
//                       value: feelings,
//                     );
//                   }).toList(),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }

//   void _productDetailPopup() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//           title: Row(
//             children: <Widget>[
//               Image.asset('assets/smiley.png',
//                   width: screenAwareSize(60, context),
//                   height: screenAwareSize(60, context),
//                   fit: BoxFit.contain),
//               Text(
//                 'Dankrupt!',
//                 style: titleParagraphStyle,
//               )
//             ],
//           ),
//           content: Text(
//             'We didnt get any info please re-enter your info!',
//             textAlign: TextAlign.center,
//             style: secondaryParagraphStyle,
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: Text("Close"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _checkData() {
  
//     print('called');
//     if (_address != null && currentSelfie != null) {
//       _firstPageSubmit();
//     } else {
//       _productDetailPopup();
//       print('Address $_address, Selfie $currentSelfie');
//     }
//   }

//   void _firstPageSubmit() {
//     final form = _accountKey.currentState;

//     if (form.validate()) {
//       form.save();
//       print(_accDetails['customer_selfie']);
//       print(_accDetails['address']);
//       print(_accDetails['phone']);
//       print(_accDetails.values);

//       _pageController.jumpToPage(
//         1,
//       );
//     } else {
//       print('Invalid Form');
//       print(_accDetails.values);

//       print(_accDetails);
//     }
//   }

//   void _secondPageSubmit() {
//     final form = _preferenceKey.currentState;

//     if (form.validate()) {
//       form.save();

//       print(_prefDetails['customer_type']);
//       print(_prefDetails['needs_help_with']);
//       print(_prefDetails['wants_to_feel']);
//       print(_prefDetails['level']);
//       print(_prefDetails['prefered_strain_type']);
//       _createRec.add(_selectedFeelings);
//       _createRec.add(_selectedLevel);
//       _createRec.add(_helpsWith);
//       _createRec.add(_strainPreference);

//       List _profile = [_accDetails, _prefDetails, _createRec];
//       _localUpload(_profile);
//     } else {
//       print('Invaild Form');
//       print(_prefDetails.values);

//       print(_prefDetails);
//     }
//   }

//   void _localUpload(_profile) {
//     setState(() {
//       showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return Center(
//               child: CircularProgressIndicator(
//                 strokeWidth: 6,
//               ),
//             );
//           });
//       Future.delayed(
//           Duration(
//             seconds: 2,
//           ), () {
//         createProfile(_profile).then((value) {
//           Navigator.of(context).pop();

//           if (value == 201) {
//             _pageController.jumpToPage(
//               2,
//             );
//           } else {
//             HLAlertWidget()
//                 .showPopup(context, Text('Not uploaded \nTry again'));
//           }
//         });
//       });
//     });
//   }

//   void _submit() {
//     final form = _scannerKey.currentState;
//     // print(_scanDetails.values);
//     if (_oldEnough == true) {
//       if (form.validate()) {
//         form.save();
//         // print(_scanDetails['sex']);
//         // print(_scanDetails['age']);
//         // print(_scanDetails['gov_name']);
//         // print(_scanDetails['license_photo']);
//         // print(_scanDetails['sm_photo']);
//         _createProfile();
//       } else {
//         print('Invaild Form');
//         print(_scanDetails.values);

//         print(_scanDetails);
//       }
//     } else {
//       HLAlertWidget().showPopup(context, Text('Not Old Enough For This Party'));
//     }
//   }

//   void _createProfile() {
//     List _profile = [_scanDetails];
//     upload(_profile);
//   }

//   void upload(_profile) {
//     setState(() {
//       showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return Center(
//               child: CircularProgressIndicator(
//                 strokeWidth: 6,
//               ),
//             );
//           });
//       Future.delayed(
//           Duration(
//             seconds: 2,
//           ), () {
//         detailsUploader(_profile)
//             .whenComplete(() => _creationResults(isUploaded));

//         print('Has the profile been created: $isUploaded');
//         // Navigator.pushReplacementNamed(context, '/bottomBar');

//         orderPlaced = false;
//       });
//     });
//   }

//   void _creationResults(x) {
//     if (x == true) {
//       print('Updated Profile');
//       popupSwitch(0, true);
//     } else {
//       Navigator.pop(context);
//       popupSwitch(1, false);

//       print('Could Not Upload. Display Error Popup');
//     }
//   }

//   void popupSwitch(int value, x) {
//     setState(() {
//       switch (value) {
//         case 0:
//           textA = 'Whoo Whoot!';
//           textB = 'You Are Really One Of Us Now';

//           _showPopup(textA, textB, x);

//           break;
//         case 1:
//           textA = 'Uh Oh!';
//           textB = 'Cant upload profile';

//           _showPopup(textA, textB, x);

//           break;
//       }
//     });
//   }

//   void _showPopup(textA, textB, x) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//           title: Row(
//             children: [
//               Image.asset('assets/smiley.png',
//                   width: 75, height: 80, fit: BoxFit.fill),
//               Text(
//                 textA,
//                 style: TextStyle(fontFamily: 'Poppins', color: hlPurple),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//           content: Text(
//             textB,
//             style: TextStyle(fontFamily: 'Roboto-Regular', color: hlPurple),
//             textAlign: TextAlign.center,
//           ),
//           actions: <Widget>[
//             x
//                 ? MaterialButton(
//                     color: hlGreen,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                     child: Text(
//                       "Close",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () {
//                       Navigator.of(context).pop();

//                       Navigator.pushReplacementNamed(context, '/bottomBar');
//                     })
//                 : MaterialButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                     color: hlGreen,
//                     child: Text("Close", style: TextStyle(color: Colors.white)),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     })
//           ],
//         );
//       },
//     );
//   }

//   BoxDecoration buildBoxDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       shape: BoxShape.rectangle,
//       borderRadius: BorderRadius.circular(10.0),
//       border: Border.all(color: Colors.transparent, style: BorderStyle.solid),
//     );
//   }
// }

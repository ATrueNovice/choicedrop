import 'package:choicedrop/Static/ensure_visible.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DriverReviewPage extends StatefulWidget {
  dynamic currentReview;

  DriverReviewPage({this.currentReview});

  @override
  State createState() => _DriverReviewPage(currentReview);
}

class _DriverReviewPage extends State<DriverReviewPage> {
  dynamic currentReview;

  String _tipAmount = '';
  List tip = [3, 5, 10, 3];

  _DriverReviewPage(this.currentReview);

  double _driversRating = 0;
  int starCount = 5;
  final _customTipFocusNode = FocusNode();
  final GlobalKey<FormState> _driversRatingKey = GlobalKey<FormState>();

  TextEditingController _customTipController = TextEditingController();

  final Map<int, Widget> tipMap = const <int, Widget>{
    0: Text('\$3'),
    1: Text('\$5'),
    2: Text('\$10'),
    3: Text(
      'Add \nCustom Tip',
      textAlign: TextAlign.center,
    )

    // 2: Text('Buddies'),
  };

  final Map<String, dynamic> ratingCapsule = {"starRating": null, "tip": null};

  void _checkData() {
    if (_tipAmount != null && _driversRating != 0) {
      _submit();
    } else {
      print(ratingCapsule);
    }
  }

  void _submit() {
    final FormState form = _driversRatingKey.currentState;

    //Add Form Input

    //Check Form
    if (form.validate()) {
      form.save();
      print(ratingCapsule['starRating']);
      print(ratingCapsule['tip']);

      print(ratingCapsule.values);
      // rateDriver(ratingCapsule, currentReview.id).whenComplete(() {
      //   _checkRated(isUploaded);
      // });
    } else {
      print('Invaild Form');
      print(ratingCapsule.values);

      print(ratingCapsule);
    }
  }

  void _checkRated(bool) {
    if (bool == true) {
      Navigator.pushReplacementNamed(context, '/bottomBar');

      setState(() {
        isUploaded = false;
      });
    } else {
      print('not rated');
    }
  }

  int sharedValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              // title: buddiesLogo,
              // centerTitle: true,
              // backgroundColor: hlGreen,
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/bottomBar');
                  },
                  child: Text('Skip',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto-Regular',
                          fontSize: screenAwareSize(12, context))),
                )
              ],
            ),
            body: Form(
              key: _driversRatingKey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: screenAwareSize(10, context),
                      ),
                      Text(
                        'How Was Your Driver?',
                        style: TextStyle(
                            fontSize: screenAwareSize(18, context),
                            // color: hlPurple,
                            fontFamily: 'Poppins'),
                      ),
                      SizedBox(
                        height: screenAwareSize(20, context),
                      ),
                      Center(
                        child: CircleAvatar(
                          minRadius: screenAwareSize(40, context),
                          maxRadius: screenAwareSize(65, context),
                          backgroundImage:
                              NetworkImage('${currentReview.driver.photo}'),
                        ),
                      ),
                      SizedBox(
                        height: screenAwareSize(10, context),
                      ),
                      StarRating(
                        size: screenAwareSize(35, context),
                        rating: _driversRating,
                        color: Colors.orange,
                        borderColor: Colors.grey,
                        starCount: starCount,
                        onRatingChanged: (_driversRating) => setState(
                          () {
                            this._driversRating = _driversRating;
                            ratingCapsule['starRating'] = _driversRating;
                          },
                        ),
                      ),
                      SizedBox(
                        height: screenAwareSize(20, context),
                      ),

                      darkModeActive
                          ? Card(
                              elevation: 8.0,
                              color: Colors.white,
                              child: Text(
                                'Add A Tip For  ${currentReview.driver.name}',
                                style: TextStyle(
                                  fontSize: screenAwareSize(16, context),
                                ),
                              ),
                            )
                          : Text(
                              'Add A Tip For  ${currentReview.driver.name}',
                              style: TextStyle(
                                fontSize: screenAwareSize(16, context),
                              ),
                            ),
                      SizedBox(
                        height: screenAwareSize(40, context),
                      ),
                      _tipWidget(),

                      // Container(
                      //     width: screenAwareSize(200, context),
                      //     child: userDetailsSegment[sharedValue]),
                      SizedBox(
                        height: screenAwareSize(35, context),
                      ),
                      RaisedButton(
                        // color: hlGreen,
                        splashColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 6,
                        onPressed: () {
                          _checkData();
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Center(
                                child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontFamily: 'Poppins', color: Colors.white),
                            ))),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget _tipWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          CupertinoSegmentedControl<int>(
            borderColor: Colors.white,
            padding: EdgeInsets.only(left: 15, right: 15),
            // selectedColor: darkModeActive ? hlGreen : hlPurple,
            children: tipMap,
            onValueChanged: (int val) {
              setState(() {
                sharedValue = val;
                ratingCapsule['tip'] = tip[sharedValue];
                _tipAmount = '${tip[sharedValue]}';
              });
            },
            groupValue: sharedValue,
          ),
          SizedBox(
            height: 20,
          ),
          sharedValue == 3 ? _customTip() : Container()
        ],
      ),
    );
  }

  Widget _customTip() {
    return Container(
      width: 175,
      child: EnsureVisibleWhenFocused(
        focusNode: _customTipFocusNode,
        child: TextFormField(
          focusNode: _customTipFocusNode,
          controller: _customTipController,
          keyboardType: TextInputType.number,
          maxLength: 4,
          maxLengthEnforced: true,
          obscureText: false,
          decoration: InputDecoration(
              icon: Icon(
                FontAwesomeIcons.cannabis,
                // color: hlYellow,
              ),
              hintText: '\$${3}',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              fillColor: Colors.transparent,
              filled: true),
          validator: (value) {
            if (value.isEmpty) {
              return 'Bad Username';
            }
          },
          onFieldSubmitted: (value) {
            // setState(() {
            _tipAmount = value;
            ratingCapsule['tip'] = value;
            // });
          },
        ),
      ),
    );
  }
}

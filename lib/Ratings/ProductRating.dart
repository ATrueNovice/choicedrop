import 'package:choicedrop/Ratings/DriverRatingScreen.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class ProductRating extends StatefulWidget {
  final dynamic currentReview;

  ProductRating({this.currentReview, Key key}) : super(key: key);
  @override
  State createState() => _ProductRating(currentReview);
}

class _ProductRating extends State<ProductRating> {
  int _effectRating;
  int _usageRating;
  int _userRecommend;

  int starCount = 5;
  double rating = 0;
  double srating = 0;
  double driverRating = -1;
  int index = 0;
  dynamic currentReview;
  List ratingsList = [];

  int prodDesc1 = -1;
  int prodDesc2 = -1;
  int _recommend = -1;
  bool driverReview = false;

  //ProdRatings
  int prodRate1 = 0;
  int prodRate2 = 0;
  int prodRate3 = 0;
  int prodRate4 = 0;
  ScrollController c;

  PageController _pageController;
  var currentPageValue = 1;

  final GlobalKey<FormState> _userRatingKey = GlobalKey<FormState>();

  final Map<String, dynamic> ratingCapsule = {
    "prodId": null,
    "starRating": null,
    "effectRating": null,
    "usageRating": null,
    "recommend": null,
  };

  _ProductRating(this.currentReview);

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choice Drop'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/bottomBar');
            },
            child: Text('Skip',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto-Regular',
                    fontSize: screenAwareSize(14, context))),
          )
        ],
      ),
      body: Form(
        key: _userRatingKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height >= 250.0
              ? MediaQuery.of(context).size.height
              : 250.0,
          alignment: Alignment.center,
          child: Column(children: <Widget>[
            //Change header
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "How Was Your Hii",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: screenAwareSize(400, context),
                child: IndexedStack(
                  index: index,
                  children: <Widget>[
                    PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return _prodctReview2(context, i);
                      },
                      itemCount: currentReview.orderDetails.length,
                      controller: _pageController,
                    )
                  ],
                ),
              ),
            ),
            RaisedButton(
              color: Colors.blue,
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
                    'Next',
                    style:
                        TextStyle(fontFamily: 'Poppins', color: Colors.white),
                  ))),
            )
          ]),
        ),
      ),
    );
  }

  Widget _cardWidget(widget) {
    return Card(
      color: Colors.white,
      elevation: 8.0,
      child: widget,
    );
  }

  Widget _header(orderDetails, i) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.network(
          '${orderDetails.image}',
          height: screenAwareSize(125, context),
          width: screenAwareSize(100, context),
        ),
        //Add photo here
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: screenAwareSize(200, context),
              child: Text(
                orderDetails.name,
                maxLines: 2,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenAwareSize(14, context),
                    color: Colors.black,
                    fontFamily: 'Poppins'),
              ),
            ),
            SizedBox(
              height: screenAwareSize(16, context),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  orderDetails.usage,
                  style: TextStyle(
                      fontSize: screenAwareSize(14, context),
                      fontFamily: 'Roboto-Regular'),
                ),
                Text(
                  '${orderDetails.productCategory[0].toUpperCase()}${orderDetails.productCategory.substring(1)}',
                  style: TextStyle(
                      fontSize: screenAwareSize(14, context),
                      fontFamily: 'Roboto-Regular'),
                ),
              ],
            ),
            StarRating(
              size: screenAwareSize(30, context),
              rating: srating,
              color: Colors.orange,
              borderColor: Colors.grey,
              starCount: starCount,
              onRatingChanged: (srating) => setState(
                () {
                  this.srating = srating;
                  ratingCapsule['prodId'] =
                      currentReview.orderDetails[i].prodId;
                  ratingCapsule['starRating'] = starCount;
                },
              ),
            ),
          ],
        ),
      ],
    ));
  }

  Widget _prodctReview2(BuildContext context, i) {
    var orderDetails = currentReview.orderDetails[i];
    return Container(
      height: screenAwareSize(350, context),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          darkModeActive
              ? _cardWidget(_header(orderDetails, i))
              : _header(orderDetails, i),
          SizedBox(
            height: screenAwareSize(12, context),
          ),
          (Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'How Did You Feel:',
                style: TextStyle(
                    fontSize: screenAwareSize(14, context),
                    fontFamily: 'Poppins',
                    color: Colors.black),
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: screenAwareSize(20, context),
                      ),
                      Text(
                        'No',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: screenAwareSize(14, context),
                            fontFamily: 'Roboto-Regular'),
                      ),
                      SizedBox(
                        width: screenAwareSize(10, context),
                      ),
                      Text(
                        'Yes',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: screenAwareSize(14, context),
                            fontFamily: 'Roboto-Regular'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
          darkModeActive
              ? _cardWidget(_productReviewWidget(i))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _productReviewWidget(i),
                ),
          SizedBox(
            height: screenAwareSize(12, context),
          ),
        ],
      ),
    );
  }

  void _rateDriverPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DriverReviewPage(
                  currentReview: currentReview,
                )));
  }

  void _checkData() {
    if (srating != 0 &&
        _recommend != -1 &&
        _effectRating != null &&
        _userRecommend != null) {
      _submit();
    }
    print('The values are ${ratingCapsule.values}');
  }

  void _submit() {
    final form = _userRatingKey.currentState;

    //Add Form Input
    //Check Form
    if (form.validate()) {
      form.save();
      print('valid Form');
      print(ratingCapsule.values);

      print(ratingCapsule);

      _uploadProductRating(ratingCapsule, currentReview.id);
    } else {
      print('Invalid Form');

      print(ratingCapsule['prodId']);
      print(ratingCapsule['starRating']);
      print(ratingCapsule['effectRating']);
      print(ratingCapsule['usageRating']);

      ratingsList.add(ratingCapsule);
      print(ratingsList);
    }
  }

  Future _uploadProductRating(ratingCapsule, id) async {
    // rateOrder(ratingCapsule, id).then((value) {
    //   _checkRated(isUploaded);
    // });
  }

  void nextPage() {
    if (currentPageValue == currentReview.orderDetails.length) {
      _rateDriverPage();
    } else {
      _clearInput();
      ratingCapsule.clear();
      _pageController.jumpToPage(
        currentPageValue,
      );
      setState(() {
        isUploaded = false;
      });
      currentPageValue++;
    }
  }

  void _checkRated(bool) {
    if (bool == true) {
      nextPage();
    } else {
      print('not rated');
    }
  }

  Widget _productReviewWidget(i) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: screenAwareSize(150, context),
                child: Text(
                  currentReview.orderDetails[i].usage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: screenAwareSize(16, context),
                      fontFamily: 'Roboto-Regular'),
                ),
              ),
              SizedBox(
                width: screenAwareSize(20, context),
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: 0,
                    groupValue: prodDesc1,
                    onChanged: _usageReviewButton,
                  ),
                  Radio(
                    value: 1,
                    groupValue: prodDesc1,
                    onChanged: _usageReviewButton,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: screenAwareSize(150, context),
                child: Text(
                  currentReview.orderDetails[i].effect,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: screenAwareSize(16, context),
                      fontFamily: 'Roboto-Regular'),
                ),
              ),
              SizedBox(
                width: screenAwareSize(20, context),
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: 0,
                    groupValue: prodDesc2,
                    onChanged: _effectReviewButton,
                  ),
                  Radio(
                    value: 1,
                    groupValue: prodDesc2,
                    onChanged: _effectReviewButton,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: screenAwareSize(150, context),
                child: Text(
                  'Would You Recommend:\n${currentReview.orderDetails[i].name}?',
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: screenAwareSize(16, context),
                      fontFamily: 'Roboto-Regular'),
                ),
              ),
              SizedBox(
                width: screenAwareSize(20, context),
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: 0,
                    groupValue: _recommend,
                    onChanged: _recommendQuestion,
                  ),
                  Radio(
                    value: 1,
                    groupValue: _recommend,
                    onChanged: _recommendQuestion,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _clearInput() {
    prodDesc1 = -1;
    prodDesc2 = -1;
    _recommend = -1;
    srating = 0;
    _effectRating = 0;
    _usageRating = 0;
    _userRecommend = 0;
  }

  _usageReviewButton(value) {
    setState(() {
      prodDesc1 = value;

      switch (prodDesc1) {
        case 0:
          print(prodDesc1);
          _usageRating = 1;
          break;
        case 1:
          print(prodDesc1);
          _usageRating = 5;
          break;
      }
      ratingCapsule['usageRating'] = _usageRating;
    });
  }

  void _effectReviewButton(value) {
    setState(() {
      prodDesc2 = value;

      switch (prodDesc2) {
        case 0:
          print(prodDesc2);

          _effectRating = 1;
          break;
        case 1:
          print(prodDesc2);
          _effectRating = 5;
          break;
      }
      ratingCapsule['effectRating'] = _effectRating;
    });
  }

  void _recommendQuestion(value) {
    setState(() {
      _recommend = value;

      switch (_recommend) {
        case 0:
          _userRecommend = 1;

          print(_userRecommend);

          break;
        case 1:
          _userRecommend = 5;

          print(_userRecommend);

          break;
      }
      ratingCapsule['recommend'] = _userRecommend;
    });
  }
}

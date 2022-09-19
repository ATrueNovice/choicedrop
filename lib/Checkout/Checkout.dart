import 'dart:math';
import 'package:choicedrop/APIS/Apis.dart';
import 'package:choicedrop/BottomBar/bottombar.dart';
import 'package:choicedrop/Checkout/CartDetails.dart';
import 'package:choicedrop/Checkout/CartProvider.dart';
import 'package:choicedrop/Static/InheritedWidgets.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  double cartTotal = 0.0;
  int _paymentCounter = 0;
  String _paymentType = 'Square';
  String _paymentDetails = '';
  int currentSizeIndex = 0;
  String _address = "";

  String tempText;
  String _couponCode = '';
  var tx = 0.0;
  var _validCouponData = '';

  final _couponFocusNode = FocusNode();
  TextEditingController _couponController = TextEditingController();
  int sharedValue = 0;
  int _shippingIconNum = 0;
  //Address
  var userAddress;
  double _totalNumber = 0.0;
  var nonce = '';
  var _lastCoupon = '';
  double fee;
  double _shippingFee = 0.0;
  var tempCart;

  double _updatedTotal;

  var address, address2, city, state, zip, fname, lname;

  String textA;
  String textB;
  TextStyle receiptStyle = TextStyle(
      fontFamily: 'Roboto-Regular',
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w700);

  Text _addCard = Text(
    'Do You Want To Store This Card On File',
    style: TextStyle(
        fontFamily: 'Roboto-Regular', fontSize: 14, color: Colors.black),
  );

//Keys

  List _shippingIndicatorIcons = [
    Container(
      child: Icon(
        FontAwesomeIcons.car,
        color: Colors.blue,
        size: 25,
      ),
    ),
    Container(
      child: Icon(
        FontAwesomeIcons.box,
        color: Colors.blue,
        size: 25,
      ),
    ),
  ];

  List _shippingOptions = [
    'Deliver To:',
    'Mail To:',
  ];

  List _delivery = [
    Text('Delivery Fee:',
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Roboto-Regular',
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700)),
    Text('Shipping Fee:',
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Roboto-Regular',
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700)),
  ];

  List _shippingAddressMessage = [
    Text('On The Go?',
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 14, color: Colors.black)),
    Text('Updated Address',
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 14, color: Colors.black)),
  ];

  List _orderText = [
    Text('Add Card',
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 14, color: Colors.white)),
    Text('SUBMIT ORDER',
        style:
            TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.white))
  ];

  List _couponOptions = [
    Text('Have A Coupon?',
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 14, color: Colors.black)),
    ''
  ];

  bool vaildForm = false;

  List _options = ['DOOR', 'DROP OFF', 'IN STORE PICKUP'];

  //Address

  // void _squarePay() {
  //   InAppPayments.setSquareApplicationId(squareApplicationId);
  //   InAppPayments.startCardEntryFlow(
  //     onCardNonceRequestSuccess: _cardNonceRequestSuccess,
  //     onCardEntryCancel: _cardEntryCancel,
  //   );
  // }

  // void _cardEntryCancel() {}

  // void _cardNonceRequestSuccess(CardDetails result) {
  //   print('Testing nonce');

  //   InAppPayments.completeCardEntry(
  //     onCardEntryComplete: _cardEntryComplete,
  //   );

  //   setState(() {
  //     nonce = result.nonce;
  //   });

  //   //Add Nonce Pop Up
  //   print(result.nonce);
  // }

  void _uploadCardData(
      address, address2, city, state, zip, fname, lname, noonce) {
    print('uploading card data');
  }

  void _cardEntryComplete() {
    squareTwoButtonPopup(
      Text('Add New Card To Profile?'),
    );
  }

  // void _updateUserCard(
  //     address, address2, city, state, zip, fname, lname, noonce) {
  //   Map<String, dynamic> _cardData = {
  //     "address": address,
  //     "address2": address2,
  //     "city": city,
  //     "state": state,
  //     "zip_code": zip,
  //     "first_name": fname,
  //     "last_name": lname,
  //     "card_noonce": noonce
  //   };

  //   addSquarePaymentMethod(_cardData);
  // }

  void squareTwoButtonPopup(content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: <Widget>[
              Image.asset('assets/cdLogo.png',
                  width: screenAwareSize(60, context),
                  height: screenAwareSize(60, context),
                  fit: BoxFit.contain),
              Text(
                'New Card',
              )
            ],
          ),
          content: content,
          actions: <Widget>[
            MaterialButton(
              color: Colors.teal,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                "Nope",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              color: Colors.teal,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                "Add Card To Profile",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // _updateUserCard(
                //     userProfile.address,
                //     userProfile.address2 != null ? userProfile.address2 : '',
                //     userProfile.city,
                //     userProfile.state,
                //     userProfile.zip,
                //     userProfile.name.split(" ")[0],
                //     userProfile.name.split(" ")[1],
                //     nonce);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void cartIntegrity() {
    if (userCart.orderDetails == null) {
      Navigator.pop(context);
    }
  }

  void _getShippingIndicator() {
    // setState(() {
    //   switch (userCart.dispensary.shippingMethod) {
    //     case 'Standard':
    //       _shippingIconNum = 0;
    //       break;
    //     case 'Drop':
    //       _shippingIconNum = 1;

    //       break;

    //     default:
    //   }
    // });
    // _getRate();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _totalNumber = userCart.cartTotal;
      _totalCart();
      _profileCheck(); //xz
      cartIntegrity(); //xy
      _getShippingIndicator();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _cartUpdate() {
    setState(() {
      tempCart = userCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    _cartUpdate();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 8.0,
        title: Text('Checkout',
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: tempCart != null
                ? Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 8,
                          child: darkModeActive
                              ? HLAlertWidget().cardWidget(
                                  _topHeader(context, tempCart.orderDetails))
                              : _topHeader(context, tempCart.orderDetails)),
                      Expanded(
                          flex: 2,
                          child: darkModeActive
                              ? HLAlertWidget().cardWidget(
                                  _couponPopup(tempCart.orderDetails))
                              : _couponPopup(tempCart.orderDetails)),
                      Expanded(
                          flex: 2,
                          child: darkModeActive
                              ? HLAlertWidget().cardWidget(_paymentSection())
                              : _paymentSection()),
                      Expanded(
                          flex: 3,
                          child: darkModeActive
                              ? HLAlertWidget().cardWidget(
                                  _totalBill(context, tempCart.orderDetails))
                              : _totalBill(context, tempCart.orderDetails)),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: screenAwareSize(60, context),
                          width: MediaQuery.of(context).size.width / 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 8,
                              color: nonce == '' ? Colors.white : Colors.teal,
                              onPressed: () {
                                checkOrder(
                                    tempCart.orders.toList(),
                                    _address == ""
                                        ? customerProfile.address
                                        : _address,
                                    _options[sharedValue],
                                    _couponCode,
                                    nonce,
                                    !usedCoupon || _updatedTotal == null
                                        ? _totalNumber
                                        : _updatedTotal,
                                    _paymentType);
                              },
                              child: SizedBox(
                                height: screenAwareSize(30, context),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child:

                                      // nonce == ''
                                      //     ? Text(
                                      //         'SQUARE PAY',
                                      //         textAlign: TextAlign.center,
                                      //         style: TextStyle(
                                      //             fontFamily: 'Poppins',
                                      //             fontSize: 14,
                                      //             color: Colors.blue),
                                      //       )
                                      //     :

                                      Text(
                                    'Submit Order',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _shippingIndicator() {
    return Container(child: _shippingIndicatorIcons[_shippingIconNum]);
  }

  void _getRate() {
    // if (_shippingIconNum == 1) {
    //   getShippingRate(tempCart.dispensary.id, tempCart.orders).then((value) {
    //     print('Printing rate');
    //     setState(() {
    //       shippingRate = value;
    //       _shippingFee = shippingRate.shippingAmount.amount;
    //     });
    //     print('test=');
    //     _totalCart();
    //   });
    // } else {
    //   setState(() {
    //     _shippingFee = tempCart.dispensary.deliveryFee;
    //   });
    //   _totalCart();
    // }
  }

  Widget _couponPopup(cart) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      child: couponData == ""
          ? Container(
              child: Column(children: <Widget>[
                Text(
                  'Have A Discount Code?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 12, color: Colors.black),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      elevation: 8,
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      onPressed: () {
                        _showCoupon();
                      },
                      child: Text(
                        'Add DiscountCode',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.teal),
                      ),
                    ))
              ]),
            )
          : Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      !usedCoupon
                          ? _couponOptions[0]
                          : Text(
                              '${couponData.code.toUpperCase()} applied! ${(couponData.amount * 100).toStringAsFixed(2)}% off!',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              softWrap: true,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.black)),

                      // SizedBox(
                      //   width: screenAwareSize(50, context),
                      // ),
                      // Text('Take ${_validCouponData.amount}% off all ' +
                      //             _validCouponData.categories !=
                      //         null
                      //     ? ' ${_validCouponData[0].categories} products'
                      //     : '${_validCouponData[0].categories} products'),
                      _address != null
                          ? _shippingAddressMessage[0]
                          : _shippingAddressMessage[1],
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          elevation: 8,
                          color: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          onPressed: () {
                            _showCoupon();
                          },
                          child: Text(
                            'Add Coupon',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                            elevation: 8,
                            color: Colors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            onPressed: () {
                              _getAddress();
                            },
                            child: Text(
                              'Edit Address',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _showCoupon() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text(
            'Enter Your Coupon',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
            textAlign: TextAlign.center,
          ),
          content: _couponTextField(),
          actions: <Widget>[
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 8,
                color: Colors.blue,
                child: Text(
                  "Close",
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            MaterialButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 8,
                child: Text(
                  "Apply",
                ),
                onPressed: () {
                  // CHECK COUPON
                  // checkingCoupon( _couponCode);
                }),
          ],
        );
      },
    );
  }

  Widget _couponTextField() {
    return Container(
        width: screenAwareSize(175, context),
        child: TextFormField(
            focusNode: _couponFocusNode,
            controller: _couponController,
            keyboardType: TextInputType.text,
            maxLength: 20,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            obscureText: false,
            textCapitalization: TextCapitalization.none,
            decoration: InputDecoration(
                icon: Icon(
                  FontAwesomeIcons.cannabis,
                  color: Colors.teal,
                  size: screenAwareSize(20, context),
                ),
                hintText: "Enter Your Coupon",
                contentPadding: EdgeInsets.symmetric(
                    vertical: screenAwareSize(10.0, context),
                    horizontal: screenAwareSize(10.0, context)),
                fillColor: Colors.transparent,
                filled: true),
            validator: (String value) {
              if (value.isEmpty) {
                return '';
              }
            },
            onChanged: (String value) {
              _couponCode = value.replaceAll(' ', '');
            }));
  }

  Future<void> checkOrder(orders, address, deliveryType, couponCode, nonce,
      total, _paymentType) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child:
                CircularProgressIndicator(strokeWidth: 6, color: Colors.blue),
          );
        });
    Future.delayed(
        Duration(
          seconds: 1,
        ), () {
      APIS.addOrder(orders, address, couponCode, nonce, total).catchError((e) {
        HLAlertWidget()
            .showPopup(context, 'Cannot Add Order\nPlease Try Again');
      }).then((value) {
        setState(() {
          orderPlaced = true;
        });
        _orderSegue(orderPlaced, _paymentType);
      });
    });
  }

  void _orderSegue(bool isLoggedIn, _paymentType) {
    setState(() {
      if (isLoggedIn == true) {
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
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BottomBarController()));
          HLAlertWidget().singlebuttonWidget(context, 'Checkout \nComplete',
              _successfulOrderWidget(_paymentType), _backToHome);
          clearCart();

          orderPlaced = false;
        });
      } else {}
    });
  }

  Widget _topHeader(BuildContext context, cart) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Text(
            '${cart.length} Item(s)',
            style: receiptStyle,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _headerImages(cart),
          ),
          SizedBox(height: screenAwareSize(20, context)),
          _deliveryWidget(context)
        ],
      ),
    );
  }

  Widget _headerImages(cart) {
    return Container(
      height: screenAwareSize(120, context),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: cart.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 20, top: 5),
        itemBuilder: (context, i) {
          return Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                    width: screenAwareSize(65, context),
                    height: screenAwareSize(85, context),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          image: NetworkImage(
                            cart[i].productImage,
                          ),
                          fit: BoxFit.fill,
                        )),
                  ),
                ),
                SizedBox(
                  height: screenAwareSize(18, context),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '${cart[i].quantity}x ${cart[i].productName} \n\$${cart[i].price}',
                    textAlign: TextAlign.center,
                    style: receiptStyle,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _deliveryWidget(BuildContext context) {
    return Column(
      children: [
        _shippingIconNum == 0 ? _dropSelection() : Container(),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _shippingIndicator(),
                  SizedBox(
                    width: screenAwareSize(20, context),
                    height: screenAwareSize(20, context),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.25,
                    child: Text(
                      _address == "" ? customerProfile.address : _address,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
//TOTAL CALCULATION

  Future<void> checkingCoupon(disId, couponCode) async {
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
    print(couponCode);

//CHECK COUPON HERE!!!

    // checkCoupon(couponCode, disId).then((couponData) {
    //   print('Checking the Coupon');
    //   if (couponData != null && usedCoupon == false) {
    //     _applyCoupon(couponData);
    //   } else {
    //     print('No active coupon or Coupon has been used');
    //     Navigator.pop(context);
    //     HLAlertWidget().single(context, 'Cannot Apply Coupon');
    //   }
    // });
  }

  //CoupoN CALCULATION

  void _applyCoupon(couponData) {
    bool matchingCategories = false;
    bool matchingProducts = false;

    print('New total $_totalNumber');

    for (int i = 0; i < tempCart.orderDetails.length; i++) {
//Test Coupon Category

      if (couponData.validCategories
          .contains(tempCart.orderDetails[i].product.productCategory)) {
//Product Matching Category Found

        print('Matching Valid Categories');

        matchingCategories = couponData.validCategories
            .contains((tempCart.orderDetails[i].product.productCategory));

        //Print Matching products

        print(matchingCategories.toString());

//HOLD COUPON DATA
        _lastCoupon = couponData.code;

//UPDATE CART
        updateCartTotal(couponData.amount, i);
      } else {
        print('No valid categories');
      }

      if (couponData.validProducts
          .contains((tempCart.orderDetails[i].product.id))) {
//Test Coupon Category

        print('Matching product id');
        matchingProducts = couponData.validProducts
            .contains((tempCart.orderDetails[i].product.id));

//MATCHING PRODUCT ID FOUND

        print(couponData.validProducts
            .contains((tempCart.orderDetails[i].product.id)));
        _lastCoupon = couponData.code;

//UPDATE CART
        updateCartTotal(couponData.amount, i);
      }
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void updateCartTotal(amount, index) {
    tempCart.orderDetails[index].price =
        (tempCart.orderDetails[index].price).toDouble() * amount;

    setState(() {
      activeCoupon = true;
      usedCoupon = true;
    });
    reviseCartTotal();
  }

  void getCartTotal() {
    print('ff');

    if (activeCoupon == false) if (userCart != null) {
      _totalNumber = 0;

      for (int i = 0; i < tempCart.orderDetails.length; i++) {
        setState(() {
          _totalNumber += (tempCart.orderDetails[i].price *
              tempCart.orderDetails[i].quantity);
        });

        print('Updated cart total');
      }
    } else {
      print('Did not update cart');
    }

    _updatetotalCart(_totalNumber);
  }

  void reviseCartTotal() {
    print('update Cart Data');

    _totalNumber = 0;

    for (int i = 0; i < tempCart.orderDetails.length; i++) {
      _totalNumber +=
          (tempCart.orderDetails[i].price * tempCart.orderDetails[i].quantity);

      tempCart = userCart;
      print('Updated cart total');
    }

    _updatetotalCart(_totalNumber);
  }

  void _updatetotalCart(_totalNumber) {
    print('Update Cart Total  cart');
    fee = 7.99;
    tx = (fee + 0.07);
    var tc = (fee + _totalNumber + tx);
    setState(() {
      _updatedTotal = dp(tc, 2);
    });
    print(_totalNumber);
  }

  void _totalCart() {
    fee = 7.99;

    tx = _totalNumber * 0.07;
    var tc = (fee + _totalNumber + tx);

    setState(() {
      _totalNumber = dp(tc, 2);
    });
    print(_totalNumber);
  }

  double dp(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  Widget _totalBill(BuildContext context, cart) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: .0, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Order detail
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    // Text('data'),

                    SizedBox(
                      height: screenAwareSize(10, context),
                    ),
                    _shippingIconNum == 0 ? _delivery[0] : _delivery[1],

                    SizedBox(
                      height: screenAwareSize(10, context),
                    ),
                    Text(
                      'State Tax',
                      style: receiptStyle,
                    ),
                    SizedBox(
                      height: screenAwareSize(10, context),
                    ),
                    // Text(
                    //   'Discount Applied',
                    //   style: receiptStyle,
                    // ),
                    // SizedBox(
                    //   height: screenAwareSize(10, context),
                    // ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: screenAwareSize(10, context),
                    ),
                    Text(
                      '\$${7.99}',
                      style: receiptStyle,
                    ),
                    SizedBox(
                      height: screenAwareSize(10, context),
                    ),
                    Text(
                      tx == 0.0 ? '\$${7.99}' : '\$${tx.toStringAsFixed(2)}',
                      style: receiptStyle,
                    ),
                  ],
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                  top: 6.0, left: 20, right: 10, bottom: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //Check For Devices variations here
                  Text(
                    'Total',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: screenAwareSize(16, context)),
                  ),
                  Text(
                    !usedCoupon || _updatedTotal == null
                        ? '\$$_totalNumber'
                        : '\$$_updatedTotal',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            squareData != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Card Ending In:'),
                      Text(squareData.customer.cards[0].last4),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void clearCart() {
    print('The Cart has ${itemCart.orderDetails[0]}');

    final cart = CartProvider.of(context);

    cart.clearCart();
    // userCart.orderDetails = [];
    // userCart.orders = [];

    setState(() {
      activeCoupon = false;
      usedCoupon = false;
    });
  }

  Widget _successfulOrderWidget(_paymentType) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [_successfulOrderDetails(_paymentType)]),
      ),
    );
  }

  Widget _successfulOrderDetails(_paymentType) {
    var now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date',
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                ),
              ),
              Text(
                DateFormat("MM-dd-yyyy hh:mm").format(now),
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenAwareSize(20, context),
          ),

          //Items

          SizedBox(
            height: screenAwareSize(16, context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Method',
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                ),
              ),
              Text(
                '$_paymentType',
                style: TextStyle(
                    fontFamily: 'Roboto-Regular', color: Colors.black),
              ),
            ],
          ),
          SizedBox(
            height: screenAwareSize(10, context),
          ),
          Divider(),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: screenAwareSize(14, context)),
                ),
                Text(
                  !usedCoupon
                      ? '\$${_totalNumber.toStringAsFixed(2)} '
                      : '\$${_updatedTotal.toStringAsFixed(2)} ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenAwareSize(14, context),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  void _backToHome() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void popupSwitch(int value) {
    setState(() {
      switch (value) {
        case 0:
          textA = 'Something Went Wrong';
          textB = 'Could Not Complete Order';

          _showPopup(textA, textB);

          break;
        case 1:
          textA = 'Hold Up Bud';
          textB = 'Your last order must be completed before placing a new one.';

          _showPopup(textA, textB);

          break;
        case 2:
          textA = 'Hold Up Bud';
          textB = 'Your last order must be completed before placing a new one.';

          _showPopup(textA, textB);
          break;
      }
    });
  }

  final Map<int, Widget> userDetailsSegment = <int, Widget>{
    0: Center(
      child: Text(
        'Front Door Drop Off',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    ),
    1: Center(
      child: Text(
        'In Store Pickup',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    ),
  };

  Widget _dropSelection() {
    return Container(
      child: CupertinoSlidingSegmentedControl(
        thumbColor: Colors.teal,
        children: userDetailsSegment,
        onValueChanged: (val) {
          setState(() {
            sharedValue = val;
          });
        },
        groupValue: sharedValue,
      ),
    );
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
            textAlign: TextAlign.left,
          ),
          actions: <Widget>[
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: Colors.teal,
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

  void _changedPaymentType(int value) {
    setState(() {
      _paymentCounter = value;

      switch (_paymentCounter) {
        case 0:
          _paymentDetails = 'PayPal';

          _paymentType = 'Visa';

          break;
        case 1:
          _paymentDetails = 'Square';
          _paymentType = 'MC';

          break;
      }
    });
  }

  Widget _paymentSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: screenAwareSize(200, context),
          child: Text(
            _paymentDetails,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(fontFamily: 'Roboto-Regular', fontSize: 12),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              runAlignment: WrapAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      activeColor: Colors.teal,
                      value: 0,
                      groupValue: _paymentCounter,
                      onChanged: _changedPaymentType,
                    ),
                    Text(
                      'Square',
                      style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          color: Colors.blue,
                          fontSize: screenAwareSize(10, context)),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      activeColor: Colors.teal,
                      value: 1,
                      groupValue: _paymentCounter,
                      onChanged: _changedPaymentType,
                    ),
                    Text(
                      'PayPal',
                      style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          color: Colors.blue,
                          fontSize: screenAwareSize(10, context)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _getAddress() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapBoxAutoCompleteWidget(
          apiKey: mapboxKey,
          hint: "Enter Address",
          onSelect: (place) {
            setState(() {
              _address = place.placeName;
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

  void _profileCheck() {
    // if (hasProfile == false) {
    //   print('User does not have a profile and will be redirected');
    // } else {
    //   print('User has profile and can order');
    // }
  }
}

mixin RadioModel {}

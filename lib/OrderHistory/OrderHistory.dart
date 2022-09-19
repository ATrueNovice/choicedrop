import 'package:choicedrop/APIS/Apis.dart';
import 'package:choicedrop/APIS/model/order.dart';
import 'package:choicedrop/Checkout/Cart.dart';
import 'package:choicedrop/Checkout/CartDetails.dart';
import 'package:choicedrop/Checkout/CartProvider.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistory extends StatefulWidget {
  final recentOrders;

  const OrderHistory({Key key, this.recentOrders}) : super(key: key);

  @override
  State createState() => _OrderHistory(recentOrders);
}

class _OrderHistory extends State<OrderHistory>
    with SingleTickerProviderStateMixin {
  _OrderHistory(recentOrders);

  dynamic recentOrders;
  Map<String, dynamic> _order = {'product_size': null, 'quantity': null};

  Color statusContainerColor = Colors.grey;
  //Button Config

  String buttonTextInfo;
  Color buttonColor;

  dynamic orderHistory;
  int index;

  int starCount = 5;
  double rating = 4.5;
  dynamic cartInfo;

  bool isCancelled = false;

  bool _buttonAvailable = false;

  //navigate

  @override
  void initState() {
    cartInfo = currentOrder;
    super.initState();
  }

  Future _orderPageNavigator(order) async {
    switch (order.status) {
      case "Your Order Is Being Picked Right Off The Plant!":
        print("Your Order Is Being Picked Right Off The Plant!");
        statusContainerColor = Colors.black;
        buttonColor = Colors.grey;
        buttonTextInfo = 'Cancel Order';

        _buttonAvailable = true;

        break;
      case "Picked, Weighed, And Ready For Delivery.":
        print("Picked, Weighed, And Ready For Delivery.");
        statusContainerColor = Colors.black;
        buttonColor = Colors.blueGrey;
        buttonTextInfo = '';
        _buttonAvailable = false;

        break;

      case "Your Bud Has Left The Building! ":
        print("Your Bud Has Left The Building!");
        var currentReview = order;
        statusContainerColor = Colors.blue;
        buttonColor = Colors.blue;
        buttonTextInfo = 'Rate';
        _buttonAvailable = false;

        break;
      case "Out For Delivery":
        statusContainerColor = Colors.black;
        buttonColor = Colors.yellow;
        buttonTextInfo = '';
        _buttonAvailable = false;

        print("The Best Bud Is Heading Straight To Your Door.");

        break;

      case "The Best Bud Is Heading Straight To Your Door.":
        statusContainerColor = Colors.blue;
        buttonColor = Colors.blue;
        buttonTextInfo = 'Track';
        _buttonAvailable = true;

        print("The Best Bud Is Heading Straight To Your Door.");

        break;
      case "Delivered":
        print("Delivered");
        var currentReview = order;
        statusContainerColor = Colors.grey;
        buttonColor = Colors.grey;
        buttonTextInfo = 'Rate';

        if (order.orderRated == false) {
          _buttonAvailable = true;
        } else {
          _buttonAvailable = false;
        }

        break;
      case "Canceled":
        print("Canceled");
        var currentReview = order;
        statusContainerColor = Colors.grey;
        buttonColor = Colors.grey;
        buttonTextInfo = 'Rate';
        _buttonAvailable = false;

        break;

      case "Refunded":
        print("Refunded");
        var currentReview = order;
        statusContainerColor = Colors.grey;
        buttonColor = Colors.grey;
        buttonTextInfo = 'Rate';
        _buttonAvailable = false;

        break;
      default:
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 8,
          // backgroundColor: Colors.blue,
          // title: buddiesLogo,
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
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: _getHistory()));
  }

  Widget _getHistory() {
    return StreamBuilder(
      stream: APIS.getHistory(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData == true) {
          orderHistory = snapshot.data;
          pOrders = orderHistory;
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              print('Done');

              break;
            default:
              return Center(child: CircularProgressIndicator());
          }
        }

        return orderHistory == null
            ? _noOrders(context)
            : _fullReciept(orderHistory);
      },
    );
  }

  Widget _fullReciept(orderHistory) {
    return Column(
      children: <Widget>[
        darkModeActive
            ? Card(
                elevation: 8.0,
                color: Colors.white,
                child: SizedBox(
                  height: screenAwareSize(40, context),
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                      child: Text(
                    'Order History',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 20),
                  )),
                ),
              )
            : Center(
                child: Text(
                'Order History',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins', color: Colors.black, fontSize: 20),
              )),
        Expanded(child: _pastOrder(orderHistory)),
      ],
    );
  }

  Widget _pastOrder(orderHistory) {
    return Container(
      height: MediaQuery.of(context).size.height,

      //Add order history api here
      child: ListView.builder(
        shrinkWrap: true,
        //change when order history count
        itemCount: orderHistory.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, i) {
          var _orderHistory = orderHistory[i];

          _orderPageNavigator(_orderHistory);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                child: _orderItem(_orderHistory, i)),
          );
        },
      ),
    );
  }

  Widget _orderItem(_orderHistory, i) {
    double c_width = MediaQuery.of(context).size.width * 0.5;
    final theme = Theme.of(context);
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            height: screenAwareSize(125, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  alignment: Alignment.center,
                  image: AssetImage(
                    'assets/cdVan.png',
                  ),
                  fit: BoxFit.fitWidth),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: screenAwareSize(25, context),
                      ),
                      Card(
                        elevation: 8.0,
                        color: Colors.white.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: c_width,
                              child: Text('Choice Drop Order',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: screenAwareSize(16, context))),
                            ),
                            GestureDetector(
                              child: Text('View Menu',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: screenAwareSize(16, context))),
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => DispensaryHome(
                                //               dispensary: orderHistory[i].venue,
                                //             )));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: screenAwareSize(20, context),
            width: screenAwareSize(10, context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    shape: BoxShape.rectangle,
                    color: statusContainerColor,
                    border: Border.all(color: statusContainerColor),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _orderHistory.status == 'Delivered'
                          ? GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => TrackingPage(
                                //               order: _orderHistory,
                                //             )));
                              },
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: screenAwareSize(150, context),
                                      child: Text(
                                        _orderHistory.status,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: screenAwareSize(150, context),
                              child: Text(
                                _orderHistory.status,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 14),
                              ),
                            )))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                _orderDetails(_orderHistory),

                Divider(
                  color: Colors.black,
                  height: screenAwareSize(8, context),
                  thickness: .5,
                ),

                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                          fontFamily: theme.textTheme.headline4.fontFamily,
                          color: theme.textTheme.headline4.color,
                          fontSize: theme.textTheme.headline4.fontSize),
                    ),
                    Text(
                      '\$${_orderHistory.total}',
                      style: TextStyle(
                          fontFamily: theme.textTheme.headline4.fontFamily,
                          color: theme.textTheme.headline4.color,
                          fontSize: theme.textTheme.headline4.fontSize),
                    )
                  ],
                ),

                SizedBox(
                  height: screenAwareSize(6, context),
                ),
              ],
            ),
          ),
          _bottomDetails(context, _orderHistory, i, buttonColor, buttonTextInfo,
              _buttonAvailable),
          SizedBox(
            height: screenAwareSize(15, context),
          ),
          Divider(
            thickness: 10,
          ),
          _reOrder(context, _orderHistory)
        ],
      ),
    ));
  }

  Future _cancelOrderCheck(orderId) async {
    // cancelOrder(orderId).then((value) {
    //   _cancelCheck(isUploaded, orderId);
    // });
  }

  Widget _noOrders(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text('No Orders Yet'),
          )
        ],
      ),
    ));
  }

  Widget _orderDetails(orderHistory) {
    final theme = Theme.of(context);
    List details = orderHistory.orderDetails;

    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: details.length,
          //  physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            return Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${details[i]['quantity']} ${details[i]['productName']} ",
                        maxLines: 2,
                        textWidthBasis: TextWidthBasis.parent,
                        style: TextStyle(
                            fontFamily: theme.textTheme.headline4.fontFamily,
                            color: theme.textTheme.headline4.color,
                            fontSize: theme.textTheme.headline4.fontSize),
                      ),
                      Text(
                        "${details[i]['price']}",
                        maxLines: 2,
                        textWidthBasis: TextWidthBasis.parent,
                        style: TextStyle(
                            fontFamily: theme.textTheme.headline4.fontFamily,
                            color: theme.textTheme.headline4.color,
                            fontSize: theme.textTheme.headline4.fontSize),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _reOrder(context, orderHistory) {
    return MaterialButton(
        child: Container(
          height: screenAwareSize(20, context),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 2,
          child: Text(
            'Order Again',
            style: TextStyle(
                color: Colors.white, fontFamily: 'Poppins', fontSize: 14),
          ),
        ),
        elevation: 8,
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: () {
          twoButtonPopup(context, _orderDetails(orderHistory), orderHistory);
        });
  }

  void twoButtonPopup(context, content, data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: <Widget>[
              Image.asset('assets/cdLogo.png',
                  width: screenAwareSize(60, context),
                  height: screenAwareSize(60, context),
                  fit: BoxFit.contain),
              Text(
                'Re Order These\n Items:',
              )
            ],
          ),
          content: content,
          elevation: 8,
          actions: <Widget>[
            MaterialButton(
              color: Colors.blue,
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                "Go Back",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              color: Colors.blue,
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);

                _getOrder(data);

                print('popping 2');
              },
            ),
          ],
        );
      },
    );
  }

  _getOrder(orderHistory) {
    for (int i = 0; i < orderHistory.orderDetails.length; i++) {
      print('Prod Size');
      var productName = orderHistory.orderDetails[i]['productName'];
      var image = orderHistory.orderDetails[i]['productImage'];

      _order['product_size'] = orderHistory.orderDetails[i]['product_size'];
      _order['productName'] = orderHistory.orderDetails[i]['productName'];
      _order['quantity'] = orderHistory.orderDetails[i]['quantity'];
      _order['price'] = orderHistory.orderDetails[i]['price'];
      _order['productImage'] = orderHistory.orderDetails[i]['productImage'];

      var total = orderHistory.orderDetails[i]['price'];

      final cartModel = CartDetails.fromProduct(orderHistory.orderDetails[i],
          productName, image, orderHistory.orderDetails[i]['quantity'], total);

      print('The Total is ${total}');
      _addProductButton(cartModel, productName, image, _order, total);
    }
    print(_order);
  }

  void _fromPreRec(dispensary) {
    print('from pre rec');
    // if (fromPreRec == true) {
    //   CartProvider.of(context).setDispensary(dispensary);
    // } else {}
  }

  void _addProductButton(cartModel, productName, image, _order, price) {
    final cart = CartProvider.of(context);

    // if (userCart != null && venueId != userCart.dispensary.id) {
    //   print('Something Else In the Cart Bud!');

    //   tempTwoButtonPopup(
    //       cart, venue, venueId, venuePhoto, cartModel, price, _order);
    // } else {
    //   _fromPreRec(venueId);

    cart.addToCart(cartModel, image, productName, price, _order);

    _productDetailPopup('Order Placed', _addedConfirmation());
    // }
  }

  Widget _addedConfirmation() {
    return Container(
        child: Text(
      'Added To Cart!',
      textAlign: TextAlign.center,
    ));
  }

  void _productDetailPopup(_header, _productDetails) {
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
                _header,
              )
            ],
          ),
          content: _productDetails,
          actions: <Widget>[
            MaterialButton(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.blue,
              textColor: Colors.white,
              child: Container(child: Text("Head To Cart")),
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartPage()));
              },
            ),
            MaterialButton(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.blue,
              textColor: Colors.white,
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

  Widget _bottomDetails(
      BuildContext context, orderHistory, i, buttonColor, buttonText, visible) {
    return visible
        ? Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  animationDuration: Duration(seconds: 1),
                  color: buttonColor,
                  elevation: 8.0,
                  height: screenAwareSize(40, context),
                  minWidth: MediaQuery.of(context).size.width / 2.5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: () {
                    // :

                    print('tapped');
                    _locationCheck(orderHistory.status, i, orderHistory.id);
                  },
                  child: Container(
                    height: screenAwareSize(20, context),
                    child: Text(
                      buttonTextInfo,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 14),
                    ),
                  ),
                ),

                //Help Button
                MaterialButton(
                  animationDuration: Duration(seconds: 1),
                  elevation: 8,
                  highlightColor: orderHistory.orderFlagged == false
                      ? Colors.blue
                      : Colors.yellow,
                  disabledColor: Colors.grey,
                  height: screenAwareSize(40, context),
                  minWidth: MediaQuery.of(context).size.width / 2.5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: buttonColor,
                  onPressed: () {
                    print('Help Page');

                    // orderHistory.orderFlagged == false
                    //     ? Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => HelpPage(
                    //                   order: orderHistory,
                    //                 )))
                    //     : Container();
                  },
                  child: Container(
                    height: screenAwareSize(20, context),
                    child: Text(
                      orderHistory.orderFlagged == false
                          ? 'Help'
                          : 'Awaiting Support',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  void _locationCheck(status, i, orderId) {
    // var lat = userLat;
    // var lng = userLong;

    // print('the user lat is $lat');

    // if (lat == 0.0 || lng == 0.0) {
    //   final _func = Locator().checkLocation(lat);
    //   HLAlertWidgets().singlebutton(
    //       context, 'Where Are You Bud?', '\nWe Need Your Location', _func);
    // } else {
    //   _segue(status, i, orderId);
    // }
  }

  void _segue(status, i, orderId) {
    switch (status) {
      case 'Your Order Is Being Picked Right Off The Plant!':
        _cancelationChecker(orderId, "Are you Sure,\nBud?",
            "You Will Cancel Order $orderId", _verifyCancellation(orderId));
        break;
      case 'The Best Bud Is Heading Straight To Your Door.':
        print('Tracking');
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => TrackingPage(
        //               order: orderHistory[i],
        //             )));
        break;
      case 'Delivered':
        print('delivered');
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             ProductRating(currentReview: orderHistory[i])));
        break;
    }
  }

  void _cancelationChecker(orderId, title, content, widget) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0)),
            title: Row(
              children: <Widget>[
                Image.asset(
                  'assets/smiley.png',
                  height: screenAwareSize(50, context),
                  width: screenAwareSize(50, context),
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  width: screenAwareSize(125, context),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            content: Text(content, textAlign: TextAlign.center),
            actions: <Widget>[widget],
          );
        });
  }

  Widget _cancellationConfirmation(text) {
    return Container(
      height: screenAwareSize(26, context),
      width: screenAwareSize(100, context),
      child: MaterialButton(
        color: Colors.blue,
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Text(
          'Dismiss',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.pop(context);
          print(text);
        },
      ),
    );
  }

  Widget _verifyCancellation(orderId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MaterialButton(
          animationDuration: Duration(seconds: 1),
          color: Colors.blue,
          elevation: 8.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Text(
            'Nope, My Bad',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            print('mistake');
            Navigator.pop(context);
          },
        ),
        MaterialButton(
            animationDuration: Duration(seconds: 1),
            color: Colors.blue,
            elevation: 8.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Text('Yes, Im Sure', style: TextStyle(color: Colors.white)),
            onPressed: () {
              print('Cancelling Order');
              _cancelOrderCheck(orderId);
              Navigator.pop(context);
            })
      ],
    );
  }

  void _cancelCheck(bool, orderId) {
    switch (bool) {
      case true:
        _cancelOrderSegue(orderId);
        setState(() {
          isUploaded = false;
        });
        break;

      case false:
        _badCancel(orderId);
        break;
    }
  }

  void _cancelOrderSegue(orderId) {
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
            seconds: 2,
          ), () {
        _showCancellation(orderId);
      });
    });
  }

  void _badCancel(orderId) {
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
            seconds: 2,
          ), () {
        Navigator.pop(context);

        _cancelationChecker(
            orderId,
            'Whoa, somethings up',
            'your order could not be cancelled. please try again',
            _cancellationConfirmation('Cant cancel'));
      });
    });
  }

  void _showCancellation(orderId) {
    Navigator.pushReplacementNamed(context, '/bottomBar');

    _cancelationChecker(orderId, 'Dankrupt', 'Your Order Has Been Cancelled',
        _cancellationConfirmation('Cancellation Confirmed'));
  }
}

import 'dart:math';
import 'package:choicedrop/Checkout/Checkout.dart';
import 'package:choicedrop/LogIn/helpers/ImageGuard.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'CartDetails.dart';
import 'CartProvider.dart';

class CartPage extends StatefulWidget {
  @override
  State createState() => _CartPage();
}

class _CartPage extends State<CartPage> {
  double cartTotal = 0;
  bool orderMin = false;
  bool cartEmpty = true;
  double minOrderNumber = 25.00;

  //Build Cart Data
  Random random = new Random();
  int index = 0;

  var _cartDetails;
  var recommendationList;

  @override
  void initState() {
    _cartDetails = userCart;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('Is the Cart Filled $cartEmpty');
      checkCart();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int starCount = 5;
  double rating = 4.5;

  void getCartTotal() {
    // Check Cart
    print(_cartDetails.orderDetails.length);

    if (_cartDetails.orderDetails.length > 0) {
      cartTotal = 0;

      for (int i = 0; i < _cartDetails.orderDetails.length; i++) {
        setState(() {
          cartTotal += (_cartDetails.orderDetails[i].price *
              _cartDetails.orderDetails[i].quantity);
        });

        print(
            'There are ${_cartDetails.orderDetails.length} many items in the cart');
        minReached(cartTotal);
      }
    }
  }

  void checkCart() {
    if (_cartDetails != null) {
      print('The cart count is:');

      if (_cartDetails.orderDetails.length > 0) {
        print('Cart is Full');
        setState(() {
          cartEmpty = false;
          getCartTotal();
        });
      }
    } else {
      print('Cart is Empty');

      cartEmpty = true;
    }

    print('Cart is empty: ${cartEmpty}');
  }

  void minReached(cartTotal) {
    setState(() {
      if (cartTotal >= minOrderNumber) {
        orderMin = true;
        print('Has the minumum order been reached: $orderMin');
      } else {
        orderMin = false;

        print('the min has not been reached');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(cartEmpty);
    return Container(
      child: cartEmpty == true ? _noConnection(context) : _cartHome(context),
    );
  }

  Widget _noConnection(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'No Bud Yet...',
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: screenAwareSize(16, context)),
          ),
          Image.asset(
            'assets/emptyCart.png',
            height: screenAwareSize(140, context),
            width: screenAwareSize(100, context),
          )
        ],
      ),
    );
  }

  Widget _cartHome(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading:
            Navigator.canPop(context) == true ? false : false,
        elevation: 8.0,
        backgroundColor: Colors.blue,
        bottomOpacity: .2,
        title: Text(
          'My Cart',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        leading: Navigator.canPop(context) == true
            ? IconButton(
                icon: Icon(
                  FontAwesomeIcons.caretLeft,
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    print('Can pop');
                  } else {
                    print('No pop');
                  }
                  Navigator.maybePop(context);
                },
              )
            : Container(),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                FontAwesomeIcons.trash,
                color: Colors.white,
                size: screenAwareSize(14, context),
              ),
              onPressed: () {
                clearoutCart();
              })
        ],
      ),
      body: SafeArea(
        top: true,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              _cartheader(_cartDetails, theme),
              Expanded(
                child: Container(
                  // height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _cartDetails.orderDetails.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, i) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            _products(_cartDetails, i, theme),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: 60,
                child: orderMin
                    ? Container(
                        width: MediaQuery.of(context).size.width / 1.25,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 8,
                          color: Colors.blue,
                          onPressed: () {
                            userCart.getCartTotal(cartTotal);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Checkout()));
                          },
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                '',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 14),
                              ),
                              Text(
                                'Checkout',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                              Text(
                                '\$${cartTotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontFamily: 'Roboto-Regular',
                                    fontSize: 12,
                                    color: Colors.white),
                              ),
                            ],
                          )),
                        ),
                      )
                    : MaterialButton(
                        // disabledColor: hlSecondaryPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 8,
                        onPressed: () {}),
              ),
              SizedBox(
                height: screenAwareSize(10, context),
              ),
              // recommendedProducts.length > 0
              //     ? Expanded(flex: 2, child: _recommendationSheet())
              //     : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _cartheader(currentOrder, theme) {
    double c_width = MediaQuery.of(context).size.width * 0.5;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => DispensaryHome(
                    //               dispensary: currentOrder.dispensary,
                    //             ))).then((value) {
                    //   //UPDATE CART HERE

                    //   getCartTotal();
                    // });
                  },
                  child: Container(
                    height: screenAwareSize(70, context),
                    width: screenAwareSize(70, context),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                    child: ClipOval(
                      child: Image.asset('assets/cdVan.png'),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    currentOrder != null
                        ? Container(
                            width: c_width,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Choice Drop',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily:
                                        theme.textTheme.headline2.fontFamily,
                                    color: theme.textTheme.headline2.color,
                                    fontSize:
                                        theme.textTheme.headline2.fontSize),
                              ),
                            ),
                          )
                        : Text(
                            '',
                            style: TextStyle(
                                fontFamily:
                                    theme.textTheme.headline2.fontFamily,
                                color: theme.textTheme.headline2.color,
                                fontSize: theme.textTheme.headline3.fontSize),
                          ),
                  ],
                ),
                Text(
                  "\$${cartTotal.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontFamily: theme.textTheme.headline2.fontFamily,
                      color: theme.textTheme.headline2.color,
                      fontSize: theme.textTheme.headline3.fontSize),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey[200]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: orderMin
                      ? Text('You Have Reached The Minimum Order of \$25.00')
                      : Text('This Store Has A Order \$25.00 Minimum'),
                ),
              ),
            ),
            Divider(
              height: .5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _products(detail, i, theme) {
    final cart = CartProvider.of(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: screenAwareSize(65, context),
            width: screenAwareSize(65, context),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(
                      detail.orderDetails[i].productImage,
                    ),
                    fit: BoxFit.cover)),
          ),
          Counter(
            color: Colors.white,
            textStyle: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: screenAwareSize(14, context)),
            buttonSize: screenAwareSize(20, context),
            minValue: 1,
            maxValue: 10,
            step: 1,
            heroDown: 'CartPage ${detail.orderDetails[i].price}$i down',
            heroUp: 'CartPage ${detail.orderDetails[i].price}$i up',
            decimalPlaces: 0,
            initialValue: cart.orderDetails[i].quantity,
            onChanged: (num val) {
              cart.orderDetails[i].quantity = val;
              getCartTotal();
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: screenAwareSize(150, context),
                child: Text(
                  detail.orderDetails[i].productName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenAwareSize(12, context),
                    color: Colors.black,
                  ),
                  softWrap: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: screenAwareSize(20, context),
                  ),
                  Text(
                    '\$${detail.orderDetails[i].price.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w700,
                        fontSize: screenAwareSize(10, context)),
                  ),
                  IconButton(
                    color: Colors.red,
                    onPressed: () {
                      deleteItem(detail, cartTotal, i);
                    },
                    icon: Icon(FontAwesomeIcons.trash),
                    iconSize: screenAwareSize(12, context),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recommendationSheet() {
    //Add
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'Our Buddies Also Bought:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenAwareSize(12, context),
                  color: Colors.black,
                ),
              ),
            ],
          ),
          _productSuggestions(),
        ],
      ),
    );
  }

  _productSuggestions() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10.0),
//       child: Container(
//         height: screenAwareSize(75, context),
//         width: MediaQuery.of(context).size.width,
//         child: ListView.builder(
//           shrinkWrap: true,
//           scrollDirection: Axis.horizontal,
//           itemCount: recommendedProducts.length,
//           itemBuilder: (context, i) {
//             return Column(
//               children: <Widget>[
//                 InkWell(
//                   onTap: () {
// //                     Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                             builder: (context) => SelectedProduct(
// //                                   product: recommendedProducts[i],
// //                                   dispensary: userCart.dispensary,
// //                                 ))).whenComplete(() {
// //                       try {
// //                         getCartTotal();
// //                       } catch (e) {
// //                         print('Checkout $e');
// //                       }

// // //ADD REFRESH HERE
// //                     });
//                   },
//                   child: Container(
//                     width: 100,
//                     height: screenAwareSize(40, context),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(18)),
//                         image: DecorationImage(
//                             image: NetworkImage(
//                               recommendedProducts[i].image,
//                             ),
//                             fit: BoxFit.fitWidth)),
//                   ),
//                 ),
//                 Container(
//                   width: screenAwareSize(100, context),
//                   child: Text(
//                     recommendedProducts[i].name,
//                     textAlign: TextAlign.center,
//                     overflow: TextOverflow.clip,
//                     maxLines: 2,
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 12,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
  }

  void clearoutCart() {
    _emptyCart('Clear My Cart', 'Are You Sure You Want To Clear The Cart?');
  }

  void deleteItem(
    cart,
    cartTotal,
    i,
  ) {
    setState(() {
      cartTotal = cartTotal - userCart.orderDetails[i].price;

      userCart.orderDetails.removeAt(i);
      print('There are ${userCart.orderDetails.length} many items in the cart');
    });

    print(cartTotal);
    minReached(cartTotal);
    getCartTotal();
    if (userCart.orderDetails.length == 0) {
      Navigator.pushReplacementNamed(context, '/bottomBar');
    } else {
      print('We are still buying something...');
    }
  }

  void addItem(
    cart,
    cartTotal,
    i,
  ) {
    setState(() {
      cartTotal = cartTotal + userCart.orderDetails[i].price;

      print(
          'You added ${userCart.orderDetails[i].quantity} more ${userCart.orderDetails[i].product.name} to the cart');
    });
    getCartTotal();
  }

  void _emptyCart(
    title,
    content,
  ) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            title: Row(
              children: <Widget>[
                Image.asset(
                  'assets/cdLogo.png',
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
            actions: <Widget>[
              MaterialButton(
                elevation: 8,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Text(
                  'Clear It Out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  final cart = CartProvider.of(context);
                  cart.orderDetails.clear();
                  userCart.orderDetails.clear();

                  setState(() {
                    cartTotal = 0;
                    cartEmpty = true;
                    userCart.orderDetails = [];
                    cart.orderDetails = [];
                    activeCoupon = false;
                    usedCoupon = false;
                  });
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomAppBar()));
                },
              ),
              MaterialButton(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.blue,
                child: Text(
                  'Go Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}

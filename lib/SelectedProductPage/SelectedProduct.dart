import 'package:choicedrop/Checkout/Cart.dart';
import 'package:choicedrop/Checkout/CartDetails.dart';
import 'package:choicedrop/Checkout/CartProvider.dart';
import 'package:choicedrop/LogIn/helpers/ImageGuard.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';

bool favorite = false;

class SelectedProduct extends StatefulWidget {
  @required
  final dynamic product;
  final dynamic dispensary;

  SelectedProduct({
    this.product,
    this.dispensary,
    dispensaryMenu,
  });
  @override
  State createState() => _SelectedProduct(product);
}

class _SelectedProduct extends State<SelectedProduct> {
  dynamic product;
  final GlobalKey<ScaffoldState> _productSelectScaffoldKey =
      GlobalKey<ScaffoldState>();

  bool isExpanded = false;
  int currentSizeIndex = 0;
  int currentColorIndex = 0;

  _SelectedProduct(this.product);

  @override
  void initState() {
    print(product.productName);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProductScreenTopPart(
                product: product,
              ),
              ProductScreenBottomPart(
                  product: product, key: _productSelectScaffoldKey)
            ],
          ),
        ),
      ),
    ));
  }
}

class ProductScreenTopPart extends StatefulWidget {
  @required
  final dynamic product;

  ProductScreenTopPart({Key key, this.product}) : super(key: key);
  @override
  _ProductScreenTopPartState createState() =>
      _ProductScreenTopPartState(product);
}

class _ProductScreenTopPartState extends State<ProductScreenTopPart> {
  dynamic product;

  _ProductScreenTopPartState(this.product);
  var buttonColor;

  @override
  void initState() {
    // _faveCheck();
    super.initState();
  }

  void _faveCheck() {
    print('starting check');
    var _faved = customerProfile.likedProducts.where((e) => e.id == product.id);

    print(_faved);

    setState(() {
      if (_faved.isNotEmpty == true) {
        buttonColor = Colors.yellow;

        print("one of my faves");
      } else {
        buttonColor = Colors.blue;

        print("Don't like it yet");
      }
    });
  }

  void _likedProduct(product) {
    // if (buttonColor == Colors.blue) {
    //   addLikes(product.id);
    //   setState(() {
    //     buttonColor = Colors.yellow;
    //   });
    // } else {
    //   setState(() {
    //     buttonColor = Colors.blue;
    //   });

    //   dislikeProduct(product.id);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3,
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  child: ImageGuard()
                      .imageGuard(product.productImage, BoxFit.fill)),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    // focusColor: hlSecondaryPurple,
                    icon: Icon(
                      FontAwesomeIcons.angleLeft,
                      color: Colors.blue.withOpacity(.6),
                      size: screenAwareSize(26, context),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              bottom: screenAwareSize(20, context),
              left: screenAwareSize(5, context),
              child: FloatingActionButton(
                heroTag: "btn1",
                backgroundColor: buttonColor,
                child: Icon(
                  FontAwesomeIcons.heart,
                  color: Colors.white,
                  size: screenAwareSize(20, context),
                ),
                mini: true,
                onPressed: () {
                  _likedProduct(product);
                },
              )),
          Positioned(
            bottom: screenAwareSize(15, context),
            right: screenAwareSize(5, context),
            child: FloatingActionButton(
              heroTag: "btn2d",
              backgroundColor: Colors.blue.withOpacity(.7),
              child: Icon(
                FontAwesomeIcons.share,
                color: Colors.white,
              ),
              mini: true,
              onPressed: () {
                final RenderBox box = context.findRenderObject();
                Share.share('shareSubject',
                    subject:
                        'I Want This' + product.productName + 'From hii-line!',
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductScreenBottomPart extends StatefulWidget {
  @required
  final dynamic scaffoldKey;
  final dynamic product;
  final dynamic dispensary;
  ProductScreenBottomPart(
      {Key key, this.product, this.dispensary, this.scaffoldKey})
      : super(key: key);

  @override
  _ProductScreenBottomPartState createState() =>
      _ProductScreenBottomPartState(product, dispensary);
}

class _ProductScreenBottomPartState extends State<ProductScreenBottomPart> {
  _ProductScreenBottomPartState(this.product, this.dispensary);

  dynamic product;
  dynamic dispensary;
  dynamic scaffoldKey;
  bool isExpanded = false;
  int currentSizeIndex = 0;
  int currentColorIndex = 0;
  int cartVal = 1;
  String image;
  double total = 0.0;
  double price;
  // Sizes productSizes;
  final List sizeList = [];
  bool hideAccessory = false;

  int selectorValue = 0;
  String address = "";
  int selectedId;
  int currentCartID = 0;
  String successHeader = 'Added To Cart';
  String _guideHeader = 'hii-line! Guide';

  @override
  void initState() {
    _getSizes(product);
    // print(selectedId = product.sizes[0].id);
    super.initState();
  }

  final Map<int, Widget> detailPage = <int, Widget>{
    0: Center(
      child: Text(
        'Description',
        style: TextStyle(
          fontFamily: "Roboto-Regular",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    1: Center(
      child: Text(
        ' Read The Label ',
        style: TextStyle(
          fontFamily: "Roboto-Regular",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  };
  Map<String, dynamic> _order = {'product_size': null, 'quantity': null};

  // List<Order> orders;
//Dialog Screen

  var productData;
  int strainInfo;

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
            _header == successHeader
                ? MaterialButton(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text("Head To Cart"),
                    onPressed: () {
                      Navigator.of(context).pop();

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CartPage()));
                    },
                  )
                : Container(),
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

  //Product
  int prodDetail = 0;

  void _productDetail(value) {
    switch (value) {
      case "Flower":
        setState(() {
          prodDetail = 0;
        });

        break;
      case 'Concentrates':
        prodDetail = 1;

        break;
      case 'Dabs':
        prodDetail = 2;

        break;
      case 'Pets':
        prodDetail = 3;

        break;
      case 'Storage':
        prodDetail = 4;

        break;
      case 'Topical':
        prodDetail = 5;

        break;
      case "Vaping":
        prodDetail = 6;

        break;
      case 'Home Setup':
        prodDetail = 7;

        break;
      case "Edibles":
        prodDetail = 8;
        break;
      case 'Pre-rolled':
        prodDetail = 9;

        break;
      case 'Bongs & Pipes':
        prodDetail = 10;

        break;

      case 'Edibles & Drinks':
        prodDetail = 8;

        break;
      default:
    }
    print(prodDetail);
  }

  void _strainDetail(value) {
    switch (value) {
      case 'hybrid':
        strainInfo = 0;

        break;
      case 'indica':
        strainInfo = 1;

        break;
      case 'sativa':
        strainInfo = 2;

        break;

      case 'Rigs':
        strainInfo = 3;

        break;
      case 'Carry Case':
        strainInfo = 4;

        break;
      case 'Pen':
        strainInfo = 5;

        break;
      case 'Cartridge':
        strainInfo = 6;
        break;
      case 'Bongs & Pipes':
        strainInfo = 7;

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

//  product.sizes = productSizes;
    _productDetail(product.category);

//  print('The ID is ${productSizes[0].id}');
    var mainStyle;
    final Map<int, Widget> segmentDetails = <int, Widget>{
      0: Column(
        children: <Widget>[
          darkModeActive
              ? Card(
                  elevation: 8.0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _shortDesc(theme),
                  ),
                )
              : _shortDesc(theme),
        ],
      ),
      1: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 30),
          child: Card(elevation: 8.0, color: Colors.white, child: Container()))
    };
    //     child: _nutritionalFacts(theme))
    // : _nutritionalFacts(theme))

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            // color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: screenAwareSize(8.0, context),
            ),
            darkModeActive
                ? Card(
                    elevation: 8.0,
                    color: Colors.white,
                    child: _namePlate(theme))
                : _namePlate(theme),
            SizedBox(
              height: screenAwareSize(12.0, context),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: CupertinoSegmentedControl(
                  borderColor: Colors.white,
                  unselectedColor: Colors.white,
                  selectedColor: Colors.blue,
                  children: detailPage,
                  groupValue: selectorValue,
                  onValueChanged: (changedFromGroupValue) {
                    setState(() {
                      selectorValue = changedFromGroupValue;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: screenAwareSize(8.0, context),
            ),
            Center(child: segmentDetails[selectorValue]),

            SizedBox(
              height: screenAwareSize(60, context),
            ),
            //Signed
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                darkModeActive
                    ? Card(
                        elevation: 8.0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Available Sizes",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: screenAwareSize(16.0, context),
                                fontFamily: "Poppins"),
                          ),
                        ),
                      )
                    : Text(
                        "Available Sizes",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: screenAwareSize(16.0, context),
                            fontFamily: "Poppins"),
                      ),
                SizedBox(
                  height: screenAwareSize(10, context),
                ),
                hideAccessory == false ? _sizeWidget() : Container(),
                SizedBox(
                  height: screenAwareSize(10, context),
                ),
                Center(
                  child: Counter(
                    color: Colors.white,
                    textStyle: TextStyle(
                        fontFamily: theme.textTheme.headline3.fontFamily,
                        color: theme.textTheme.headline3.color,
                        fontSize: theme.textTheme.headline1.fontSize),
                    buttonSize: screenAwareSize(40, context),
                    heroUp: 'up',
                    heroDown: 'down',
                    minValue: 1,
                    maxValue: 10,
                    step: 1,
                    decimalPlaces: 0,
                    initialValue: cartVal,
                    onChanged: (num val) {
                      setState(() {
                        cartVal = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenAwareSize(20, context),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: MaterialButton(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    color: Colors.blue,
                    height: screenAwareSize(40, context),
                    onPressed: () {
                      _getOrder(
                          product.productName,
                          product.sizes[currentSizeIndex],
                          cartVal,
                          product.prices[currentSizeIndex],
                          product.productImage);
                      final cart = CartProvider.of(context);
                      final cartModel = CartDetails.fromProduct(
                          product,
                          product.productName,
                          product.productImage,
                          cartVal,
                          product.prices[currentSizeIndex]);
                      _addProductButton(cart, cartModel, _order);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(''),
                        Text(
                          'ADD TO CART',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                        ),
                        Text(
                          '\$' +
                              ('${(product.prices[currentSizeIndex] * cartVal).toStringAsFixed(2)}'),
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  )
                  // : Container(),
                  ),
            ),
          ],
        ));
  }

  Widget _namePlate(theme) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Text(
          product.productName,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: theme.textTheme.headline6.fontFamily,
              color: theme.textTheme.headline6.color,
              fontSize: theme.textTheme.headline6.fontSize),
        ),
      ),
    );
  }

  Widget _shortDesc(theme) {
    return Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: Text(
          product.description,
          maxLines: 6,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: theme.textTheme.bodyText2.fontFamily,
              color: theme.textTheme.bodyText2.color,
              fontSize: theme.textTheme.bodyText2.fontSize),
        ));
  }

  Widget _addedConfirmation() {
    return Container(
        child: Text(
      'Added To Cart!',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.blue),
    ));
  }

  Widget _sizeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          height: screenAwareSize(60.0, context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: sizeList.map((item) {
              var index = sizeList.indexOf(item);
              // print(item);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentSizeIndex = index;
                    print('current index is ${sizeList.indexOf(item)}');
                  });
                },
                child: sizeItem(item, index == currentSizeIndex, context),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future getTotal(product, cartVal) async {
    price = product.sizes[0].price;
    print('The price is: $price');
  }

  void _addProductButton(cart, cartModel, _order) {
    final cart = CartProvider.of(context);

    cart.addToCart(
        cartModel, product.productImage, product.productName, price, _order);
    Navigator.of(context).pop();

    _productDetailPopup(successHeader, _addedConfirmation());
  }

  void checkOrders() {
    if (cartEmpty == false) {
      cartEmpty = true;
    } else {}
  }

  _getOrder(name, size, quantity, price, productImage) {
    setState(() {
      _order['productName'] = name;
      _order['product_size'] = size;
      _order['quantity'] = quantity;
      _order['price'] = price;
      _order['productImage'] = productImage;
    });
  }

  void _getSizes(product) {
    for (int i = 0; i < product.sizes.length; i++) {
      // sizeNumlist
      var nSize = product.sizes[i];
      // print('${nSize.price}');

      var sizeName = sizeNumlist[nSize - 1];
      sizeList.add(sizeName);
    }
    _hideAccessorySize();
  }

  void _hideAccessorySize() {
    // if (product.sizes[0]) {
    //   setState(() {
    //     hideAccessory = true;
    //   });
    // } else {
    //   setState(() {
    //     hideAccessory = false;
    //   });
    // }
  }
}

Widget sizeItem(var size, bool isSelected, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 12.0),
    child: Container(
      width: screenAwareSize(40.0, context),
      height: screenAwareSize(40.0, context),
      decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Color(0xFF525663),
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
                color:
                    isSelected ? Colors.black.withOpacity(.5) : Colors.black12,
                offset: Offset(0.0, 10.0),
                blurRadius: 10.0)
          ]),
      child: Center(
        child: Text(size,
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.white, fontFamily: "Montserrat-Bold")),
      ),
    ),
  );
}

Widget colorItem(
    Color color, bool isSelected, BuildContext context, VoidCallback _ontab) {
  return GestureDetector(
    onTap: _ontab,
    child: Padding(
      padding: EdgeInsets.only(left: screenAwareSize(10.0, context)),
      child: Container(
        width: screenAwareSize(30.0, context),
        height: screenAwareSize(30.0, context),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: Colors.blue.withOpacity(.8),
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0))
                  ]
                : []),
        child: ClipPath(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: color,
          ),
        ),
      ),
    ),
  );
}

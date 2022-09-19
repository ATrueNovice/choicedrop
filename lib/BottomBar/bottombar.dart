import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:choicedrop/APIS/Apis.dart';
import 'package:choicedrop/APIS/addProducts.dart';
import 'package:choicedrop/Account/AccountInfo.dart';
import 'package:choicedrop/Checkout/Cart.dart';
import 'package:choicedrop/HomeScreens/HomeScreen.dart';
import 'package:choicedrop/OrderHistory/OrderHistory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomBarController extends StatefulWidget {
  const BottomBarController({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomBarController();
}

class _BottomBarController extends State<BottomBarController> {
  int _currentIndex = 0;
  final _bottombarScaffoldKey = GlobalKey<ScaffoldState>();

  dynamic dispensary;

  var pages = [
    HomeScreen(),
    CartPage(),
    const OrderHistory(),
    // AccountInfo(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _fbstart() async {
    print('checking driver');
    // await APIS.addProducts(AddProducts.initProducts);
  }

  @override
  void initState() {
    pages[0] = HomeScreen();
    _fbstart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _bottombarScaffoldKey,
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        elevation: 8,
        hasInk: true,
        inkColor: Colors.black12,
        items: [
          BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              FontAwesomeIcons.home,
              color: Colors.blue,
            ),
            activeIcon: Icon(
              FontAwesomeIcons.home,
              color: Colors.grey,
            ),
            title: Text(
              "Home",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey,
              ),
            ),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              FontAwesomeIcons.shoppingCart,
              color: Colors.blue,
            ),
            activeIcon: Icon(
              FontAwesomeIcons.shoppingCart,
              color: Colors.grey,
            ),
            title: Text(
              "Cart",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey,
              ),
            ),
          ),
          BubbleBottomBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              FontAwesomeIcons.receipt,
              color: Colors.blue,
            ),
            activeIcon: Icon(
              FontAwesomeIcons.receipt,
              color: Colors.grey,
            ),
            title: Text(
              "Orders",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey,
              ),
            ),
          ),
          // BubbleBottomBarItem(
          //   backgroundColor: Colors.white,
          //   icon: Icon(
          //     FontAwesomeIcons.userCircle,
          //     color: Colors.blue,
          //   ),
          //   activeIcon: Icon(
          //     FontAwesomeIcons.userCircle,
          //     color: Colors.grey,
          //   ),
          //   title: Text(
          //     "Account",
          //     style: TextStyle(
          //       fontFamily: 'Poppins',
          //       color: Colors.grey,
          //     ),
          //   ),
          // ),
        ],
      ),
      body: pages[_currentIndex],
    );
  }
}

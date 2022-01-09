//Screen Sizes

import 'package:choicedrop/APIS/model/Coupon.dart';
import 'package:choicedrop/APIS/model/SquareCustomer.dart';
import 'package:flutter/material.dart';

var orderError;
Coupon couponData;

double baseHeight = 640.0;
const double kDefaultPadding = 20.0;
bool darkModeActive = false;
bool isUploaded = false;
bool usedCoupon = false;
bool activeCoupon = false;
bool updatingCart = false;
dynamic customerProfile;
dynamic currentProducts;
bool cartEmpty = false;
bool orderPlaced = false;
var pOrders;
dynamic products;
ActiveSquareAccount squareData;

String passwordValidator =
    r'^(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[^\w\d\s:])([^\s]){8,16}$';

final mapboxKey =
    'pk.eyJ1IjoiaHNpc2VhbiIsImEiOiJja3ZyNWJjaHRleWdqMnBtbnhlM281eDF4In0.hOuFc2a83zfQINELElLE4g';

double screenAwareSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / baseHeight;
}

List<String> sizeNumlist = [
  '1 Gal',
  '3 Gal',
  '5 Gal',
  'Each',
];

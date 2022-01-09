import 'dart:ffi';

import 'package:choicedrop/APIS/model/utils.dart';
import 'package:flutter/material.dart';

class OrderDate {
  static const String createdAt = 'createdAt';
}

class Order {
  final String address;
  final List<dynamic> orderDetails;
  final String status;
  final String idUser;
  final double total;
  final String coupon;
  final String nonce;
  final DateTime createdAt;

  const Order({
    @required this.address,
    @required this.orderDetails,
    @required this.status,
    @required this.idUser,
    @required this.total,
    @required this.coupon,
    @required this.nonce,
    @required this.createdAt,
  });

  static Order fromJson(Map<String, dynamic> json) => Order(
        address: json['address'],
        orderDetails: json['orderDetails'],
        status: json['status'],
        idUser: json['idUser'],
        total: json['total'] as double,
        coupon: json['coupon'],
        nonce: json['nonce'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'address': address,
        'status': status,
        'orderDetails': orderDetails,
        'idUser': idUser,
        'total': total,
        'coupon': coupon,
        'nonce': nonce,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
      };
}

class OrderDetails {
  final String productName;
  final double prouctPrice;
  final double quantity;

  const OrderDetails({
    @required this.productName,
    @required this.prouctPrice,
    @required this.quantity,
  });

  static OrderDetails fromJson(Map<String, dynamic> json) => OrderDetails(
        productName: json['productName'],
        prouctPrice: json['prouctPrice'],
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'prouctPrice': prouctPrice,
        'quantity': quantity,
      };
}

import 'package:choicedrop/APIS/model/utils.dart';
import 'package:flutter/material.dart';

class Order {
  final String address;
  final String customer;
  final String date;
  final String driver;
  final String status;
  final String subtotal;
  final String total;
  final DateTime deliveryDate;
  final DateTime createdAt;

  const Order({
    @required this.address,
    @required this.customer,
    @required this.date,
    @required this.driver,
    @required this.status,
    @required this.subtotal,
    @required this.total,
    @required this.deliveryDate,
    @required this.createdAt,
  });

  static Order fromJson(Map<String, dynamic> json) => Order(
        address: json['address'],
        customer: json['customer'],
        date: json['date'],
        driver: json['driver'],
        status: json['status'],
        subtotal: json['subtotal'],
        total: json['total'],
        deliveryDate: json['deliveryDate'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'productName': address,
        'customer': customer,
        'date': date,
        'status': status,
        'total': total,
        'subtotal': subtotal,
        'deliveryDate': deliveryDate,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
      };
}

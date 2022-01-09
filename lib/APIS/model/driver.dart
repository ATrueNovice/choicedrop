import 'package:choicedrop/APIS/model/utils.dart';
import 'package:flutter/material.dart';

class Driver {
  final String productName;
  final String description;
  final String image;
  final String usage;
  final String minimumQuantity;
  final String price;
  final String type;
  final DateTime createdAt;

  const Driver({
    @required this.productName,
    @required this.description,
    @required this.image,
    @required this.usage,
    @required this.minimumQuantity,
    @required this.price,
    @required this.type,
    @required this.createdAt,
  });

  static Driver fromJson(Map<String, dynamic> json) => Driver(
        productName: json['productName'],
        description: json['description'],
        image: json['username'],
        usage: json['message'],
        minimumQuantity: json['minimum_quantity'],
        price: json['username'],
        type: json['message'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'description': description,
        'image': image,
        'usage': usage,
        'minimumQuantity': minimumQuantity,
        'price': price,
        'type': type,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
      };
}

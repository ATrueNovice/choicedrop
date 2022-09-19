import 'package:choicedrop/APIS/model/utils.dart';
import 'package:flutter/material.dart';

class ProductDate {
  static const String createdAt = 'createdAt';
  static int productId = 1;
}

class Products {
  final String productName;
  final String category;
  final String description;
  final String productImage;
  final String usage;
  final int minimumQuantity;
  final String type;
  final int id;
  final String rating;
  final List<dynamic> sizes;
  final List<dynamic> prices;
  final DateTime createdAt;

   Products({
    @required this.productName,
    @required this.category,
    @required this.description,
    @required this.productImage,
    @required this.usage,
    @required this.minimumQuantity,
    @required this.type,
    @required this.id,
    @required this.rating,
    @required this.sizes,
    @required this.prices,
    @required this.createdAt,
  });

  static Products fromJson(Map<String, dynamic> json) => Products(
        productName: json['productName'],
        description: json['description'],
        category: json['category'],
        productImage: json['productImage'],
        usage: json['usage'],
        minimumQuantity: json['minimum_quantity'],
        type: json['type'],
        id: json['id'],
        rating: json['rating'],
        sizes: json['sizes'],
        prices: json['prices'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'category': category,
        'description': description,
        'productImage': productImage,
        'usage': usage,
        'minimumQuantity': minimumQuantity,
        'id': id,
        'rating': rating,
        'type': type,
        'sizes': sizes,
        'prices': prices,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
      };
}



class ReadProducts {
  final String productName;
  final String category;
  final String description;
  final String productImage;
  final String usage;
  final int minimumQuantity;
  final String type;
  final int id;
  final String rating;
  final List<dynamic> sizes;
  final List<dynamic> prices;
  final DateTime createdAt;

   ReadProducts({
    @required this.productName,
    @required this.category,
    @required this.description,
    @required this.productImage,
    @required this.usage,
    @required this.minimumQuantity,
    @required this.type,
    @required this.id,
    @required this.rating,
    @required this.sizes,
    @required this.prices,
    @required this.createdAt,
  });

  ReadProducts fromJson(Map<String, dynamic> json) => ReadProducts(
        productName: json['productName'],
        description: json['description'],
        category: json['category'],
        productImage: json['productImage'],
        usage: json['usage'],
        minimumQuantity: json['minimum_quantity'],
        type: json['type'],
        id: json['id'],
        rating: json['rating'],
        sizes: json['sizes'],
        prices: json['prices'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'category': category,
        'description': description,
        'productImage': productImage,
        'usage': usage,
        'minimumQuantity': minimumQuantity,
        'id': id,
        'rating': rating,
        'type': type,
        'sizes': sizes,
        'prices': prices,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
      };
}
class ProductsInHeading implements Comparable<ProductsInHeading> {
  final String heading;
  final List products;

  ProductsInHeading(this.heading, this.products);

  @override
  int compareTo(ProductsInHeading other) {
    return heading.compareTo(other.heading);
  }
}

class ProductSize {
  final String productId;
  final int size;

  const ProductSize({this.productId, this.size});

  static ProductSize fromJson(Map<String, dynamic> json) => ProductSize(
        size: json['sizes'],
      );

  Map<String, dynamic> toJson() => {
        'sizes': size,
      };
}

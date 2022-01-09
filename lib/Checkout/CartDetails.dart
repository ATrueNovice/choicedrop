import 'package:choicedrop/Checkout/CartProvider.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:flutter/material.dart';

Cart itemCart;
var initDispenaries;

Cart get userCart => itemCart;
CartDetails orderDetail;
CartProvider cart;
Cart currentOrder;
bool pendingOrder = false;

enum CartErrors {
  productAlreadyExists,
  successfullyAdded,
  newDispensary,
  additionalDispensaryItem,
  newCartCreated,
  clearCart
}

class Cart {
  String productImage;
  String productName;
  double cartTotal = 0;
  double temp;

  List<CartDetails> orderDetails;
  var orders;

  Cart(
      {this.productImage,
      this.productName,
      this.cartTotal,
      this.orders,
      List<CartDetails> products})
      : orderDetails = products;

  void addToCart(CartDetails product, productImage, productName, total, order) {
    orderDetails ??= <CartDetails>[];
    orders ??= [];

    if (itemCart != null) {
      print('There are current pending orders.');

      dispensaryCheck(product, productImage, productName, total, order);
    } else {
      print('There Are No Pending Orders. Checking Dispensary Id');
      createNewCart(product, productImage, productName, total, order);
    }
  }

  void dispensaryCheck(
      CartDetails product, productImage, productName, total, order) {
    print('From The Same Dispensary. Checking For Duplicates');

    checkDuplicates(product, productImage, productName, total, order);
  }

  Future<void> createNewCart(
      CartDetails product, productImage, productName, total, order) async {
    //Match item ID

    if (itemCart != null) {
      dispensaryCheck(product, productImage, productName, total, order);
    } else {
      orderDetails.add(product);
      orders.add(order);
      print('New Cart Created');

      itemCart = Cart(
          productImage: productImage,
          productName: productName,
          products: orderDetails,
          orders: orders);

      _addProduct(CartErrors.newCartCreated);
    }
  }

  void checkDuplicates(
      CartDetails product, productImage, productName, total, order) {
    //Match item ID

    final existing = orderDetails.firstWhere(
        (p) => p.product.id == product.product.id,
        orElse: () => null);

    print('Duplicate Items. Adding Item. add by one');
    existing.quantity += product.quantity;
  }

  Future<void> _addProduct(error) async {
    switch (error) {
      case CartErrors.successfullyAdded:
        print('Product Added');
        pendingOrder = true;
        updatingCart = false;

        break;
      case CartErrors.productAlreadyExists:
        print('Product Already Added');
        pendingOrder = true;
        updatingCart = false;

        break;

      case CartErrors.newDispensary:
        print('New Dispensary Selected. Old Dispensary Overwritten');
        updatingCart = true;
        pendingOrder = true;

        break;

      case CartErrors.newCartCreated:
        print('New Cart Created');
        updatingCart = true;
        pendingOrder = true;

        break;

      case CartErrors.clearCart:
        print('New Product Cart Created');
        updatingCart = false;
        pendingOrder = true;

        break;
    }
  }

  void setDispensary(dispensary) {
    if (dispensary == dispensary) {
      return;
    } else {
      print('set new dispensary');
      // Assign the new dispensary

      dispensary = dispensary;

      // Clear the cart
      orderDetails = <CartDetails>[];
      orders = [];
    }
  }

  void clearCart() {
    print('The Cart has ${itemCart.orderDetails.length}');

    itemCart.orderDetails = <CartDetails>[];
    itemCart.orders = [];
    itemCart.productImage = null;
    itemCart.productName = null;
    itemCart.cartTotal = null;
    itemCart.temp = null;

    orderDetails = null;
    orders = null;
    itemCart = null;
    // cartEmpty = true;
    pendingOrder = false;
    updatingCart = true;

    print('After Clearing, We Have\n $itemCart Items In Itt');
  }

  void getCartTotal(total) {
    itemCart.cartTotal = total;
    print('The Cart Has ${itemCart.cartTotal} Worth Of Items');
  }

  updateCartTotal(price, index) {
    if (orders != null) {
      itemCart.cartTotal = 0;

      for (int i = 0; i < orders.length; i++) {
        if (orders[index] = orders[i]) {
          orders[i].price = price;
        }

        itemCart.cartTotal += (orders[i].price * orders[i].quantity);
      }
    }
    print('updated cart total');
    print(cartTotal);

    return itemCart.cartTotal;
  }

  factory Cart.fromJSON(Map<String, dynamic> json) => Cart(
      productImage: json['productImage'],
      productName: json['name'],
      products: json['cartData'],
      orders: json['order']);

  Map<String, dynamic> toJson() => {
        "productImage": productImage == null ? null : productImage,
        "name": productName,
        "cartData": orderDetails,
        "order": orders
      };
}

class CartDetails {
  //Use whole prodcut and do not distructure. Work backwards to incorporate product.
  dynamic product;
  int quantity;
  double price;
  String productName;
  String productImage;
  CartDetails(this.product, this.productName, this.productImage, this.quantity,
      this.price);

  factory CartDetails.fromProduct(dynamic product, String productName,
      String productImage, int quantity, double price) {
    return CartDetails(
      product,
      productName,
      productImage,
      quantity,
      price,
    );
  }
}

class Order {
  int productSize;
  int quantity;

  Order(this.productSize, this.quantity);

  factory Order.fromOrder(int productSize, int quantity) {
    return Order(productSize, quantity);
  }
}

class ChangeFilter {
  void updatedispensaryFilter(i) {}
}

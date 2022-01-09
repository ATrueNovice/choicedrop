import 'package:choicedrop/APIS/google_sign_in.dart';
import 'package:choicedrop/APIS/model/data.dart';
import 'package:choicedrop/APIS/model/order.dart';
import 'package:choicedrop/APIS/model/products.dart';
import 'package:choicedrop/APIS/model/user.dart';
import 'package:choicedrop/APIS/model/userProfile.dart';
import 'package:choicedrop/APIS/model/utils.dart';
import 'package:choicedrop/Static/static.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class APIS {
  static Stream<List<Products>> getProducts() => FirebaseFirestore.instance
      .collection('products')
      .orderBy(ProductDate.createdAt, descending: true)
      .snapshots()
      .transform(Utils.transformer(Products.fromJson));

  static Future getProduct(String idUser, String message, orderId) async {
    final refMessages = FirebaseFirestore.instance.collection('products');

    final product = Products(
      productName: 'productName',
      description: 'myUsername',
      productImage: 'photo',
      usage: 'myId',
      minimumQuantity: 2,
      type: message,
      createdAt: DateTime.now(),
    );

    final refUsers = FirebaseFirestore.instance.collection('customer');
    await refUsers
        .doc(idUser)
        .update({UserField.lastMessageTime: DateTime.now()});
  }

  static Future checkCustomer() async {
    final email = FirebaseAuth.instance.currentUser.email;

    final refUsers = FirebaseFirestore.instance.collection('customer');
    final allCustomers = await refUsers.get();

    var data = allCustomers.docs;

    final String testEmail = email;
    print('Check ID');

    var id = '';
    if (allCustomers.size > 0) {
      for (int i = 0; i < allCustomers.size; i++) {
        print(data[i].data());

        if (data[i].data()['email'] == testEmail) {
          var mydata = data[i].data();
          myId = data[i].data()['idUser'];
          print('Added user: $myId');

          customerProfile = userProfile(
              address: mydata['address'],
              firstName: mydata['firstName'],
              lastName: mydata['lastName'],
              phone: mydata['phone'],
              idUser: myId,
              email: mydata['email']);
          id = myId;
          return id;
        } else {
          print('checking');
        }
      }
    } else if (myId == '') {
      print('Could not find account');
      return id;
    } else {
      id = myId;
    }
  }

  static Future addOrder(orderDetails, address, coupon, nonce, total) async {
    final refOrders = FirebaseFirestore.instance.collection('order');
    final order = Order(
      address: address,
      status: 'Placed',
      idUser: myId,
      coupon: coupon,
      total: total,
      orderDetails: orderDetails,
      nonce: nonce,
      createdAt: DateTime.now(),
    );

    return await refOrders.add(order.toJson());
  }

  static Stream<List<Order>> getHistory() => FirebaseFirestore.instance
      .collection('order')
      .orderBy(OrderDate.createdAt, descending: true)
      .snapshots()
      .transform(Utils.transformer(Order.fromJson));

  static Future addCustomer(firstName, lastName, email, phone, address) async {
    final refUsers = FirebaseFirestore.instance.collection('customer');
    final myData = FirebaseAuth.instance.currentUser.uid;

    final customer = Customer(
      idUser: myData,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      lastMessageTime: DateTime.now(),
    );

    final userDoc = refUsers.doc();
    final newUser = customer.copyWith(idUser: userDoc.id);

    return await userDoc.set(newUser.toJson()).catchError((e) {
      print('my error $e');
    }).then((value) {
      return value;
    });
    ;
  }
}

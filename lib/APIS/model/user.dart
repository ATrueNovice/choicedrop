import 'package:choicedrop/APIS/model/utils.dart';
import 'package:meta/meta.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class Customer {
  final String idUser;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final DateTime lastMessageTime;

  const Customer({
    this.idUser,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.phone,
    @required this.address,
    @required this.lastMessageTime,
  });

  Customer copyWith({
    String idUser,
    String firstName,
    String lastName,
    String email,
    String address,
    String phone,
    String lastMessageTime,
  }) =>
      Customer(
        idUser: idUser ?? this.idUser,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );

  static Customer fromJson(Map<String, dynamic> json) => Customer(
        idUser: json['idUser'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        address: json['address'],
        phone: json['phone'],
        lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'address': address,
        'phone': phone,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
      };
}

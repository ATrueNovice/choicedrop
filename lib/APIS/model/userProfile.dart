import 'package:choicedrop/APIS/model/utils.dart';
import 'package:meta/meta.dart';

class userProfile {
  final String idUser;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;

  const userProfile({
    this.idUser,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.phone,
    @required this.address,
  });

  userProfile copyWith({
    String idUser,
    String firstName,
    String lastName,
    String email,
    String address,
    String phone,
  }) =>
      userProfile(
        idUser: idUser ?? this.idUser,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        address: address ?? this.address,
        phone: phone ?? this.phone,
      );

  static userProfile fromJson(Map<String, dynamic> json) => userProfile(
        idUser: json['idUser'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        address: json['address'],
        phone: json['phone'],
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'address': address,
        'phone': phone,
      };
}

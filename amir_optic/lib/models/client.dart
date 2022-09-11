import 'dart:convert';

import 'package:flutter/foundation.dart';

class Client {
  String firstName;
  String lastName;

  List<String> phoneNumbers;
  String id;
  String address;
  String hmo;
  String comments;
  String uid;

  Client({
    required this.firstName,
    required this.lastName,
    required this.phoneNumbers,
    required this.id,
    required this.address,
    required this.hmo,
    required this.comments,
    required this.uid,
  });

  Client copyWith({
    String? firstName,
    String? lastName,
    List<String>? phoneNumbers,
    String? id,
    String? address,
    String? hmo,
    String? comments,
    String? uid,
  }) {
    return Client(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      id: id ?? this.id,
      address: address ?? this.address,
      hmo: hmo ?? this.hmo,
      comments: comments ?? this.comments,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumbers': phoneNumbers,
      'id': id,
      'address': address,
      'hmo': hmo,
      'comments': comments,
      'uid': uid,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phoneNumbers: List<String>.from(map['phoneNumbers']),
      id: map['id'] ?? '',
      address: map['address'] ?? '',
      hmo: map['hmo'] ?? '',
      comments: map['comments'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Client.fromJson(String source) => Client.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Client(firstName: $firstName, lastName: $lastName, phoneNumbers: $phoneNumbers, id: $id, address: $address, hmo: $hmo, comments: $comments, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Client &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      listEquals(other.phoneNumbers, phoneNumbers) &&
      other.id == id &&
      other.address == address &&
      other.hmo == hmo &&
      other.comments == comments &&
      other.uid == uid;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
      lastName.hashCode ^
      phoneNumbers.hashCode ^
      id.hashCode ^
      address.hashCode ^
      hmo.hashCode ^
      comments.hashCode ^
      uid.hashCode;
  }
}

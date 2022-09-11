// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:uuid/uuid.dart';

import 'package:amir_optic/models/purchase.dart';

class ContactLenses implements Purchase {
  @override
  double price;
  @override
  Timestamp purchasedAt;
  @override
  String uid;
  @override
  String optometrist;
  @override
  String purchaseCause;
  @override
  String comments;
  @override
  PurchaseStatus purchaseStatus;
  @override
  String? imageUrl;

  String R;
  String R_VA;
  String L;
  String L_VA;
  String BC;
  String D;

  String details;

  ContactLenses({
    required this.price,
    required this.purchasedAt,
    this.uid = "",
    required this.optometrist,
    required this.purchaseCause,
    required this.comments,
    required this.purchaseStatus,
    this.imageUrl,
    required this.R,
    required this.R_VA,
    required this.L,
    required this.L_VA,
    required this.BC,
    required this.D,
    required this.details,
  }) {
    if (uid.isEmpty) uid = const Uuid().v1();
  }

  ContactLenses copyWith({
    double? price,
    Timestamp? purchasedAt,
    String? uid,
    String? optometrist,
    String? purchaseCause,
    String? comments,
    PurchaseStatus? purchaseStatus,
    String? imageUrl,
    String? R,
    String? R_VA,
    String? L,
    String? L_VA,
    String? BC,
    String? D,
    String? details,
  }) {
    return ContactLenses(
      price: price ?? this.price,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      uid: uid ?? this.uid,
      optometrist: optometrist ?? this.optometrist,
      purchaseCause: purchaseCause ?? this.purchaseCause,
      comments: comments ?? this.comments,
      purchaseStatus: purchaseStatus ?? this.purchaseStatus,
      imageUrl: imageUrl ?? this.imageUrl,
      R: R ?? this.R,
      R_VA: R_VA ?? this.R_VA,
      L: L ?? this.L,
      L_VA: L_VA ?? this.L_VA,
      BC: BC ?? this.BC,
      D: D ?? this.D,
      details: details ?? this.details,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'purchasedAt': purchasedAt,
      'uid': uid,
      'optometrist': optometrist,
      'purchaseCause': purchaseCause,
      'comments': comments,
      'purchaseStatus': EnumToString.convertToString(purchaseStatus),
      'imageUrl': imageUrl,
      'R': R,
      'R_VA': R_VA,
      'L': L,
      'L_VA': L_VA,
      'BC': BC,
      'D': D,
      'details': details,
    };
  }

  factory ContactLenses.fromMap(Map<String, dynamic> map) {
    return ContactLenses(
      price: map['price'].toDouble(),
      purchasedAt: map['purchasedAt'],
      uid: map['uid'],
      optometrist: map['optometrist'],
      purchaseCause: map['purchaseCause'],
      comments: map['comments'],
      purchaseStatus: EnumToString.fromString(
          PurchaseStatus.values, map['purchaseStatus'])!,
      imageUrl: map['imageUrl'],
      R: map['R'],
      R_VA: map['R_VA'],
      L: map['L'],
      L_VA: map['L_VA'],
      BC: map['BC'],
      D: map['D'],
      details: map['details'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactLenses.fromJson(String source) =>
      ContactLenses.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ContactLenses(price: $price, purchasedAt: $purchasedAt, uid: $uid, optometrist: $optometrist, purchaseCause: $purchaseCause, comments: $comments, purchaseStatus: $purchaseStatus, imageUrl: $imageUrl, R: $R, R_VA: $R_VA, L: $L, L_VA: $L_VA, BC: $BC, D: $D, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactLenses &&
        other.price == price &&
        other.purchasedAt == purchasedAt &&
        other.uid == uid &&
        other.optometrist == optometrist &&
        other.purchaseCause == purchaseCause &&
        other.comments == comments &&
        other.purchaseStatus == purchaseStatus &&
        other.imageUrl == imageUrl &&
        other.R == R &&
        other.R_VA == R_VA &&
        other.L == L &&
        other.L_VA == L_VA &&
        other.BC == BC &&
        other.D == D &&
        other.details == details;
  }

  @override
  int get hashCode {
    return price.hashCode ^
        purchasedAt.hashCode ^
        uid.hashCode ^
        optometrist.hashCode ^
        purchaseCause.hashCode ^
        comments.hashCode ^
        purchaseStatus.hashCode ^
        imageUrl.hashCode ^
        R.hashCode ^
        R_VA.hashCode ^
        L.hashCode ^
        L_VA.hashCode ^
        BC.hashCode ^
        D.hashCode ^
        details.hashCode;
  }

  @override
  PurchaseType getPurchaseType() {
    return PurchaseType.contactLenses;
  }
}

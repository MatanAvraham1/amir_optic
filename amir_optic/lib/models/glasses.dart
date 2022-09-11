// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:uuid/uuid.dart';

import 'package:amir_optic/models/purchase.dart';

class Glasses implements Purchase {
  @override
  Timestamp purchasedAt;
  @override
  String uid;
  @override
  double price;
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
  String PD;
  String ADD;
  String H;
  String frameDetails;

  Glasses({
    required this.purchasedAt,
    this.uid = "",
    required this.price,
    required this.optometrist,
    required this.purchaseCause,
    required this.comments,
    required this.purchaseStatus,
    this.imageUrl,
    required this.R,
    required this.R_VA,
    required this.L,
    required this.L_VA,
    required this.PD,
    required this.ADD,
    required this.H,
    required this.frameDetails,
  }) {
    if (uid.isEmpty) uid = const Uuid().v1();
  }

  Map<String, dynamic> toMap() {
    return {
      'purchasedAt': purchasedAt,
      'uid': uid,
      'price': price,
      'optometrist': optometrist,
      'purchaseCause': purchaseCause,
      'comments': comments,
      'purchaseStatus': EnumToString.convertToString(purchaseStatus),
      'imageUrl': imageUrl,
      'R': R,
      'R_VA': R_VA,
      'L': L,
      'L_VA': L_VA,
      'PD': PD,
      'ADD': ADD,
      'H': H,
      'frameDetails': frameDetails,
    };
  }

  factory Glasses.fromMap(Map<String, dynamic> map) {
    return Glasses(
      purchasedAt: map['purchasedAt'],
      uid: map['uid'],
      price: map['price'].toDouble(),
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
      PD: map['PD'],
      ADD: map['ADD'],
      H: map['H'],
      frameDetails: map['frameDetails'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Glasses.fromJson(String source) =>
      Glasses.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Glasses(purchasedAt: $purchasedAt, uid: $uid, price: $price, optometrist: $optometrist, purchaseCause: $purchaseCause, comments: $comments, purchaseStatus: $purchaseStatus, imageUrl: $imageUrl, R: $R, R_VA: $R_VA, L: $L, L_VA: $L_VA, PD: $PD, ADD: $ADD, H: $H, frameDetails: $frameDetails)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Glasses &&
        other.purchasedAt == purchasedAt &&
        other.uid == uid &&
        other.price == price &&
        other.optometrist == optometrist &&
        other.purchaseCause == purchaseCause &&
        other.comments == comments &&
        other.purchaseStatus == purchaseStatus &&
        other.imageUrl == imageUrl &&
        other.R == R &&
        other.R_VA == R_VA &&
        other.L == L &&
        other.L_VA == L_VA &&
        other.PD == PD &&
        other.ADD == ADD &&
        other.H == H &&
        other.frameDetails == frameDetails;
  }

  @override
  int get hashCode {
    return purchasedAt.hashCode ^
        uid.hashCode ^
        price.hashCode ^
        optometrist.hashCode ^
        purchaseCause.hashCode ^
        comments.hashCode ^
        purchaseStatus.hashCode ^
        imageUrl.hashCode ^
        R.hashCode ^
        R_VA.hashCode ^
        L.hashCode ^
        L_VA.hashCode ^
        PD.hashCode ^
        ADD.hashCode ^
        H.hashCode ^
        frameDetails.hashCode;
  }

  @override
  PurchaseType getPurchaseType() {
    return PurchaseType.glasses;
  }

  Glasses copyWith({
    Timestamp? purchasedAt,
    String? uid,
    double? price,
    String? optometrist,
    String? purchaseCause,
    String? comments,
    PurchaseStatus? purchaseStatus,
    String? imageUrl,
    String? R,
    String? R_VA,
    String? L,
    String? L_VA,
    String? PD,
    String? ADD,
    String? H,
    String? frameDetails,
  }) {
    return Glasses(
      purchasedAt: purchasedAt ?? this.purchasedAt,
      uid: uid ?? this.uid,
      price: price ?? this.price,
      optometrist: optometrist ?? this.optometrist,
      purchaseCause: purchaseCause ?? this.purchaseCause,
      comments: comments ?? this.comments,
      purchaseStatus: purchaseStatus ?? this.purchaseStatus,
      imageUrl: imageUrl ?? this.imageUrl,
      R: R ?? this.R,
      R_VA: R_VA ?? this.R_VA,
      L: L ?? this.L,
      L_VA: L_VA ?? this.L_VA,
      PD: PD ?? this.PD,
      ADD: ADD ?? this.ADD,
      H: H ?? this.H,
      frameDetails: frameDetails ?? this.frameDetails,
    );
  }
}

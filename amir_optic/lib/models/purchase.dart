import 'package:cloud_firestore/cloud_firestore.dart';

enum PurchaseStatus { notReady, ready }

enum PurchaseType {
  contactLenses,
  glasses,
}

abstract class Purchase {
  static PurchaseType getPurchaseTypeByMap(Map<String, dynamic> map) {
    if (map.containsKey("frameDetails")) {
      return PurchaseType.glasses;
    }

    return PurchaseType.contactLenses;
  }

  late Timestamp purchasedAt;
  late double price;
  late String uid;
  late String optometrist;
  late String purchaseCause;
  late String comments;
  late String? imageUrl;
  late PurchaseStatus purchaseStatus;
  Purchase({
    required this.purchasedAt,
    required this.price,
    required this.uid,
    required this.optometrist,
    required this.purchaseCause,
    required this.comments,
    this.imageUrl,
    required this.purchaseStatus,
  });

  PurchaseType getPurchaseType();

  @override
  String toString() {
    return 'Purchase(purchasedAt: $purchasedAt, price: $price, uid: $uid, optometrist: $optometrist, purchaseCause: $purchaseCause, comments: $comments, imageUrl: $imageUrl, purchaseStatus: $purchaseStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Purchase &&
        other.purchasedAt == purchasedAt &&
        other.price == price &&
        other.uid == uid &&
        other.optometrist == optometrist &&
        other.purchaseCause == purchaseCause &&
        other.comments == comments &&
        other.imageUrl == imageUrl &&
        other.purchaseStatus == purchaseStatus;
  }

  @override
  int get hashCode {
    return purchasedAt.hashCode ^
        price.hashCode ^
        uid.hashCode ^
        optometrist.hashCode ^
        purchaseCause.hashCode ^
        comments.hashCode ^
        imageUrl.hashCode ^
        purchaseStatus.hashCode;
  }
}

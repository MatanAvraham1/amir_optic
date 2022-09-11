import 'package:amir_optic/models/contact_lenses.dart';
import 'package:amir_optic/models/glasses.dart';
import 'package:amir_optic/models/purchase.dart';
import 'package:amir_optic/services/online_db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class PurchaseFormController extends PropertyChangeNotifier<String> {
  dynamic purchase;
  bool enabled;
  PurchaseType purchaseType;
  XFile? pickedImage;
  GlobalKey<FormState> glassesFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> contactLensesFormKey = GlobalKey<FormState>();

  PurchaseFormController._create({
    required this.purchaseType,
    dynamic initialPurchase,
    this.enabled = true,
  }) {
    if (initialPurchase == null) {
      if (purchaseType == PurchaseType.glasses) {
        purchase = Glasses(
            purchasedAt: Timestamp.now(),
            price: 0,
            optometrist: "",
            purchaseCause: "",
            comments: "",
            purchaseStatus: PurchaseStatus.notReady,
            L_VA: "",
            R_VA: "",
            R: "",
            L: "",
            PD: "",
            ADD: "",
            H: "",
            frameDetails: "");
      } else {
        purchase = ContactLenses(
            price: 0,
            purchasedAt: Timestamp.now(),
            optometrist: "",
            purchaseCause: "",
            comments: "",
            purchaseStatus: PurchaseStatus.notReady,
            R_VA: "",
            R: "",
            L_VA: "",
            L: "",
            BC: "",
            D: "",
            details: "");
      }
    } else {
      purchase = initialPurchase;

      if (purchase is Glasses && purchaseType != PurchaseType.glasses) {
        throw "error!";
      } else if (purchase is ContactLenses &&
          purchaseType != PurchaseType.contactLenses) {
        throw "error!";
      }
    }
  }

  static Future<PurchaseFormController> create({
    required PurchaseType purchaseType,
    dynamic initialPurchase,
    bool enabled = true,
  }) async {
    // Call the private constructor
    var component = PurchaseFormController._create(
        purchaseType: purchaseType,
        enabled: enabled,
        initialPurchase: initialPurchase);

    await component._loadImage();

    // Return the fully initialized object
    return component;
  }

  Future _loadImage() async {
    if (purchase.imageUrl != null) {
      pickedImage = XFile.fromData(
          await OnlineDBSerivce.getPurchaeImageData(purchase.imageUrl));
    }
  }

  bool validate() {
    if (purchaseType == PurchaseType.glasses) {
      return glassesFormKey.currentState!.validate();
    }
    return contactLensesFormKey.currentState!.validate();
  }

  void changePurchaseType(PurchaseType purchaseType) {
    this.purchaseType = purchaseType;
    purchase = null;

    if (purchaseType == PurchaseType.glasses) {
      purchase = Glasses(
          purchasedAt: Timestamp.now(),
          price: 0,
          optometrist: "",
          purchaseCause: "",
          comments: "",
          purchaseStatus: PurchaseStatus.notReady,
          L_VA: "",
          R_VA: "",
          R: "",
          L: "",
          PD: "",
          ADD: "",
          H: "",
          frameDetails: "");
    } else {
      purchase = ContactLenses(
          price: 0,
          purchasedAt: Timestamp.now(),
          optometrist: "",
          purchaseCause: "",
          comments: "",
          purchaseStatus: PurchaseStatus.notReady,
          R_VA: "",
          R: "",
          L: "",
          L_VA: "",
          BC: "",
          D: "",
          details: "");
    }

    notifyListeners("changePurchaseType");
  }

  void changeEnabledMode(bool enabled) {
    this.enabled = enabled;
    notifyListeners("changeEnabledMode");
  }
}

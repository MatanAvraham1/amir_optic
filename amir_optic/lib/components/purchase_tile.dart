import 'package:amir_optic/models/contact_lenses.dart';
import 'package:amir_optic/models/glasses.dart';
import 'package:amir_optic/screens/purchases/purchase_page.dart';
import 'package:amir_optic/translations/locale_keys.g.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:amir_optic/models/client.dart';
import 'package:amir_optic/models/purchase.dart';

class PurchaseTile extends StatefulWidget {
  const PurchaseTile({
    Key? key,
    required this.purchase,
    required this.client,
    required this.purchaseType,
  }) : super(key: key);

  final dynamic purchase;
  final Client client;
  final PurchaseType purchaseType;

  @override
  State<PurchaseTile> createState() => _PurchaseTileState();
}

class _PurchaseTileState extends State<PurchaseTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: _buildTralling(),
      title: Text(widget.purchaseType == PurchaseType.glasses
          ? LocaleKeys.glasses.tr()
          : LocaleKeys.contact_lenses.tr()),
      subtitle: Text(
          "${widget.purchase.purchasedAt.toDate().day}/${widget.purchase.purchasedAt.toDate().month}/${widget.purchase.purchasedAt.toDate().year}"),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PurchasePage(
            /*
            Passing copy of widget.purchase instead of pointer to this varaible.
            
            Why?
            becuase when the user edit the purchase in the purchase page -  
            the user changing the widget.purchase object...
            And when he saves the changes the program uploads this object to the online db.
            
            so if the user will not save the changes to the online db,
            when the user will reopen the purchase page the changes "will be saved"
            becuase we are using the same [widget.purchase].

            so becuase that every time we are opening the purchase page, we are passing a copy
            of the widget.purchase object and not pointer.
            */
            purchase: widget.purchaseType == PurchaseType.glasses
                ? Glasses.fromMap(widget.purchase.toMap())
                : ContactLenses.fromMap(widget.purchase.toMap()),
            purchaseType: widget.purchaseType,
            client: widget.client,
          ),
        ));
      },
    );
  }

  Widget _buildTralling() {
    if (widget.purchase.imageUrl == null) {
      return CircleAvatar(
        child: widget.purchase.getPurchaseType() == PurchaseType.glasses
            ? Image.asset(
                "assets/images/glasses.png",
                color: Colors.white,
              )
            : const Icon(Icons.remove_red_eye),
      );
    }

    return FutureBuilder<String>(
      future: FirebaseStorage.instance
          .ref(widget.purchase.imageUrl)
          .getDownloadURL(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error!");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return CircleAvatar(
          backgroundImage: NetworkImage(snapshot.data!),
        );
      },
    );
  }
}

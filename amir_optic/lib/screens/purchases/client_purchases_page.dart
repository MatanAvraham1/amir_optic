import 'package:amir_optic/components/loading_indicator.dart';
import 'package:amir_optic/components/purchase_tile.dart';
import 'package:amir_optic/models/contact_lenses.dart';
import 'package:amir_optic/models/glasses.dart';
import 'package:amir_optic/models/purchase.dart';
import 'package:amir_optic/screens/purchases/add_purchase_page.dart';
import 'package:amir_optic/translations/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:amir_optic/models/client.dart';

class ClientPurchasesPage extends StatefulWidget {
  final Client client;

  const ClientPurchasesPage({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  State<ClientPurchasesPage> createState() => _ClientPurchasesPageState();
}

class _ClientPurchasesPageState extends State<ClientPurchasesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddPurchasePage(
              client: widget.client,
            ),
          ));
        },
        label: Text(
          LocaleKeys.add_purchase.tr(),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white),
        ),
      ),
      body: _buildPurchasesList(),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> _buildPurchasesList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("clients")
          .doc(widget.client.uid)
          .collection("purchases")
          .snapshots(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.active) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              index = snapshot.data!.docs.length -
                  index -
                  1; // Reverses the list (to make it ordered by date)

              dynamic purchase;

              var doc = snapshot.data!.docs.elementAt(index).data();
              var purchaseType = Purchase.getPurchaseTypeByMap(
                  snapshot.data!.docs.elementAt(index).data());
              if (purchaseType == PurchaseType.glasses) {
                purchase = Glasses.fromMap(doc);
              } else if (purchaseType == PurchaseType.contactLenses) {
                purchase = ContactLenses.fromMap(doc);
              }

              return PurchaseTile(
                client: widget.client,
                purchase: purchase,
                purchaseType: purchaseType,
              );
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingIndicator(
          title: LocaleKeys.load_purchases.tr(),
        );
      },
    );
  }
}

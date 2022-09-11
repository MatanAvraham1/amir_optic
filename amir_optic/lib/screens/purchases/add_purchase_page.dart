import 'package:amir_optic/classes/navigators_keys.dart';
import 'package:amir_optic/classes/purchase_form_controller.dart';
import 'package:amir_optic/components/loading_alert.dart';
import 'package:amir_optic/components/loading_indicator.dart';
import 'package:amir_optic/components/purchase_form.dart';
import 'package:amir_optic/translations/locale_keys.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:amir_optic/models/client.dart';
import 'package:amir_optic/models/purchase.dart';
import 'package:amir_optic/services/online_db_service.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

class AddPurchasePage extends StatefulWidget {
  const AddPurchasePage({
    Key? key,
    required this.client,
  }) : super(key: key);

  final Client client;

  @override
  State<AddPurchasePage> createState() => _AddPurchasePageState();
}

class _AddPurchasePageState extends State<AddPurchasePage> {
  late PurchaseFormController _purchaseFormController;
  late PurchaseType purchaseType;
  bool loading = true;

  @override
  void initState() {
    purchaseType = PurchaseType.glasses;

    PurchaseFormController.create(purchaseType: purchaseType).then((value) {
      _purchaseFormController = value;
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _purchaseFormController.dispose();
    super.dispose();
  }

  Future addPurchase(dynamic purchase) async {
    final navigatorkey = Provider.of<NavigatorsKeys>(context, listen: false)
        .clientPageNavigatorKey(context);

    // Shows loading dialog
    showLoadingAlertDialog(navigatorkey.currentState!.context);

    await OnlineDBSerivce.addPurchase(purchase, widget.client.uid,
        purchaseImage: _purchaseFormController.pickedImage);

    // Closes loading dialog
    Navigator.of(context).pop();
    // Closes add purchase page
    Navigator.of(context).pop();

    MotionToast.info(
            title: Text(LocaleKeys.add_purchase.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            description: Text(LocaleKeys.purchase_success_created.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold)))
        .show(context);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Material(
        child: LoadingIndicator(
          title: LocaleKeys.loading_purchase.tr(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.add_purchase.tr(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.14,
            ),
            Center(
              child: SizedBox(
                width: 400,
                child: Column(
                  children: [
                    // The title
                    Text(
                      LocaleKeys.purchase_details.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.orange),
                    ),
                    // Little space between the title to the purchase form
                    const SizedBox(
                      height: 20,
                    ),
                    // Product type selector
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<PurchaseType>(
                        value: purchaseType,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.green,
                          ),
                          labelText: LocaleKeys.product_type.tr(),
                          hintText: LocaleKeys.product_type.tr(),
                        ),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyText1!.color),
                        items: [
                          DropdownMenuItem<PurchaseType>(
                            value: PurchaseType.glasses,
                            child: Text(LocaleKeys.glasses.tr()),
                          ),
                          DropdownMenuItem<PurchaseType>(
                            value: PurchaseType.contactLenses,
                            child: Text(LocaleKeys.contact_lenses.tr()),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              purchaseType = value;
                              _purchaseFormController
                                  .changePurchaseType(purchaseType);
                            });
                          }
                        },
                      ),
                    ),
                    // Little space between the purchase type to the purchase form
                    const SizedBox(
                      height: 25,
                    ),
                    PurchaseForm(
                        purchaseFormController: _purchaseFormController),

                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_purchaseFormController.validate()) {
                          await addPurchase(_purchaseFormController.purchase);
                        }
                      },
                      child: Text(
                        LocaleKeys.add_purchase.tr(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

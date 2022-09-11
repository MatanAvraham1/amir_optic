import 'package:amir_optic/classes/navigators_keys.dart';
import 'package:amir_optic/classes/purchase_form_controller.dart';
import 'package:amir_optic/components/loading_alert.dart';
import 'package:amir_optic/components/loading_indicator.dart';
import 'package:amir_optic/components/purchase_form.dart';
import 'package:amir_optic/translations/locale_keys.g.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:amir_optic/models/client.dart';
import 'package:amir_optic/models/purchase.dart';
import 'package:amir_optic/services/online_db_service.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({
    Key? key,
    required this.purchase,
    required this.purchaseType,
    required this.client,
  }) : super(key: key);

  final dynamic purchase;
  final PurchaseType purchaseType;
  final Client client;

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  late final PurchaseFormController _purchaseFormController;

  bool loading = true;

  @override
  void initState() {
    PurchaseFormController.create(
            purchaseType: widget.purchaseType,
            enabled: false,
            initialPurchase: widget.purchase)
        .then((value) {
      _purchaseFormController = value;
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future deletePurchaseAlertOnClick() async {
    {
      final navigatorkey = Provider.of<NavigatorsKeys>(context, listen: false)
          .clientPageNavigatorKey(context);

      // Shows loading dialog
      showLoadingAlertDialog(navigatorkey.currentState!.context);

      await OnlineDBSerivce.deletePurchase(
          widget.purchase.uid, widget.client.uid);

      // Closes Loading Dialog
      Navigator.of(context).pop();

      Navigator.of(context).pop();

      MotionToast.info(
          title: Text(
            LocaleKeys.delete.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          description: Text(
            LocaleKeys.purchase_success_deleted.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          )).show(context);
    }
  }

  Future updatePurchase() async {
    final navigatorkey = Provider.of<NavigatorsKeys>(context, listen: false)
        .clientPageNavigatorKey(context);

    // Shows loading dialog
    showLoadingAlertDialog(navigatorkey.currentState!.context);

    widget.purchase.imageUrl = (await OnlineDBSerivce.updatePurchase(
            _purchaseFormController.purchase,
            widget.client.uid,
            _purchaseFormController.pickedImage))
        .imageUrl;

    // Closes loading dialog
    Navigator.of(context).pop();

    MotionToast.info(
        title: Text(
          LocaleKeys.save.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        description: Text(
          LocaleKeys.purchase_success_updated.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        )).show(context);

    setState(() {
      _purchaseFormController.changeEnabledMode(false);
    });
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_purchaseFormController.enabled) {
              if (_purchaseFormController.validate()) {
                updatePurchase();
              }
            } else {
              setState(() {
                _purchaseFormController.changeEnabledMode(true);
              });
            }
          },
          child: Text(
            !_purchaseFormController.enabled
                ? LocaleKeys.edit.tr()
                : LocaleKeys.save.tr(),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white),
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  AwesomeDialog(
                    width: 400,
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.INFO,
                    body: Center(
                      child: Text(
                        "${LocaleKeys.delete_purchase_alert.tr()} ?",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    title: 'This is Ignored',
                    desc: 'This is also Ignored',
                    btnCancelText: LocaleKeys.no.tr(),
                    btnOkText: LocaleKeys.yes.tr(),
                    btnOkOnPress: deletePurchaseAlertOnClick,
                    btnCancelOnPress: () {},
                  ).show();
                },
                icon: const Icon(Icons.delete))
          ],
          centerTitle: true,
          title: Text(
            widget.purchaseType == PurchaseType.glasses
                ? LocaleKeys.glasses.tr()
                : LocaleKeys.contact_lenses.tr(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Text(
                LocaleKeys.purchase_details.tr(),
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.orange,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              PurchaseForm(purchaseFormController: _purchaseFormController),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ));
  }
}

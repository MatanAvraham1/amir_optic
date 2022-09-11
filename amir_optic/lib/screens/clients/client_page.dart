import 'package:amir_optic/classes/navigators_keys.dart';
import 'package:amir_optic/components/loading_alert.dart';
import 'package:amir_optic/classes/chosen_client.dart';
import 'package:amir_optic/constants/constants.dart';
import 'package:amir_optic/screens/clients/client_details_page.dart';
import 'package:amir_optic/screens/purchases/client_purchases_page.dart';
import 'package:amir_optic/services/online_db_service.dart';
import 'package:amir_optic/translations/locale_keys.g.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:amir_optic/models/client.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({
    Key? key,
    required this.client,
  }) : super(key: key);
  final Client client;

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  @override
  Widget build(BuildContext context) {
    final chosenClient = Provider.of<ChosenClient>(context, listen: true);

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            leading: kIsSplitedScreen
                ? CloseButton(
                    onPressed: () {
                      chosenClient.unsSelectClient();
                    },
                  )
                : null,
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
                          "${LocaleKeys.delete_client_alert.tr()} ${widget.client.firstName} ${widget.client.lastName}?",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      title: 'This is Ignored',
                      desc: 'This is also Ignored',
                      btnCancelText: LocaleKeys.no.tr(),
                      btnOkText: LocaleKeys.yes.tr(),
                      btnOkOnPress: () async {
                        final navigatorkey =
                            Provider.of<NavigatorsKeys>(context, listen: false)
                                .clientPageNavigatorKey(context);

                        // Shows Loading Dialog
                        showLoadingAlertDialog(
                            navigatorkey.currentState!.context);

                        await OnlineDBSerivce.deleteClient(widget.client.uid);

                        // Closes the loading dialog
                        Navigator.of(context).pop();

                        if (kIsSplitedScreen) {
                          Provider.of<ChosenClient>(context, listen: false)
                              .unsSelectClient();
                        } else {
                          Navigator.of(context).pop();
                        }

                        MotionToast.info(
                            title: Text(
                              LocaleKeys.delete.tr(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            description: Text(
                              LocaleKeys.client_success_deleted.tr(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )).show(context);
                      },
                      btnCancelOnPress: () {},
                    ).show();
                  },
                  icon: const Icon(Icons.delete)),
            ],
            centerTitle: true,
            title: Text(
              "${widget.client.firstName} ${widget.client.lastName}",
            ),
            bottom: TabBar(
                labelStyle: const TextStyle(fontWeight: FontWeight.w400),
                tabs: [
                  Tab(
                    text: LocaleKeys.details.tr(),
                  ),
                  Tab(
                    text: LocaleKeys.purchases.tr(),
                  )
                ]),
          ),
          body: TabBarView(
            children: [
              ClientDetailsPage(
                client: widget.client,
              ),
              ClientPurchasesPage(
                client: widget.client,
              ),
            ],
          )),
    );
  }
}

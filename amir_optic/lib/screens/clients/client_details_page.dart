import 'package:amir_optic/classes/client_form_controller.dart';
import 'package:amir_optic/classes/navigators_keys.dart';
import 'package:amir_optic/components/client_form.dart';
import 'package:amir_optic/components/loading_alert.dart';
import 'package:amir_optic/exceptions/online_db_service_exceptions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:amir_optic/models/client.dart';
import 'package:amir_optic/services/online_db_service.dart';
import 'package:amir_optic/translations/locale_keys.g.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

class ClientDetailsPage extends StatefulWidget {
  final Client client;

  const ClientDetailsPage({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage>
    with AutomaticKeepAliveClientMixin {
  late final ClientFormController _clientFormController;

  @override
  void initState() {
    _clientFormController =
        ClientFormController(initialClient: widget.client, enabled: false);
    super.initState();
  }

  @override
  void dispose() {
    _clientFormController.dispose();
    super.dispose();
  }

  Future updateClient() async {
    var newClient = Client(
        address: widget.client.address,
        uid: widget.client.uid,
        firstName: widget.client.firstName,
        lastName: widget.client.lastName,
        phoneNumbers: widget.client.phoneNumbers,
        id: widget.client.id,
        hmo: widget.client.hmo,
        comments: widget.client.comments);

    if (_clientFormController.validate()) {
      final navigatorkey = Provider.of<NavigatorsKeys>(context, listen: false)
          .clientPageNavigatorKey(context);

      // Shows Loading Dialog
      showLoadingAlertDialog(navigatorkey.currentState!.context);

      try {
        await OnlineDBSerivce.updateClient(newClient);
      } on ClientIdDoesAlreadyInUse {
        // Closes loading dialog
        Navigator.of(context).pop();

        MotionToast.error(
            title: Text(
              LocaleKeys.error.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            description: Text(
              LocaleKeys.id_already_in_use.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            )).show(context);
      }

      // Closes loading dialog
      Navigator.of(context).pop();

      MotionToast.info(
          title: Text(
            LocaleKeys.save.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          description: Text(
            LocaleKeys.client_success_updated.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          )).show(context);

      setState(() {
        _clientFormController.changeEnabledMode(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Little space
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            // The title
            Text(
              LocaleKeys.client_details.tr(),
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.orange,
                  ),
            ),
            // Little space between the title to the form
            const SizedBox(
              height: 20,
            ),
            ClientForm(clientFormController: _clientFormController),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_clientFormController.enabled) {
            await updateClient();
          } else {
            setState(() {
              _clientFormController
                  .changeEnabledMode(!_clientFormController.enabled);
            });
          }
        },
        child: Text(
          !_clientFormController.enabled
              ? LocaleKeys.edit.tr()
              : LocaleKeys.save.tr(),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

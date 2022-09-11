import 'package:amir_optic/classes/client_form_controller.dart';
import 'package:amir_optic/classes/navigators_keys.dart';
import 'package:amir_optic/components/client_form.dart';
import 'package:amir_optic/components/loading_alert.dart';
import 'package:amir_optic/classes/chosen_client.dart';
import 'package:amir_optic/constants/constants.dart';
import 'package:amir_optic/exceptions/online_db_service_exceptions.dart';
import 'package:amir_optic/screens/clients/client_page.dart';
import 'package:amir_optic/services/online_db_service.dart';
import 'package:amir_optic/translations/locale_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

class AddClientPage extends StatefulWidget {
  const AddClientPage({Key? key}) : super(key: key);

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final ClientFormController clientFormController = ClientFormController();

  @override
  void dispose() {
    clientFormController.dispose();
    super.dispose();
  }

  Future addButtonOnPressed(Size size) async {
    const textStyle = TextStyle(fontWeight: FontWeight.bold);

    var navigatorKey = Provider.of<NavigatorsKeys>(context, listen: false)
        .homePageNavigatorKey(context);

    var clientToAdd = clientFormController.client;

    if (clientFormController.validate()) {
      try {
        // Shows loading dialog
        showLoadingAlertDialog(navigatorKey.currentState!.context);

        await OnlineDBSerivce.addClient(clientToAdd);

        // Closes loading dialog
        Navigator.of(context).pop();
        // Closes add client page
        Navigator.of(context).pop();

        if (kIsSplitedScreen) {
          Provider.of<ChosenClient>(context, listen: false)
              .selectClient(clientToAdd);
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ClientPage(client: clientToAdd),
          ));
        }

        MotionToast.info(
                title: Text(
                  LocaleKeys.add_client.tr(),
                  style: textStyle,
                ),
                description: Text(LocaleKeys.client_success_created.tr(),
                    style: textStyle))
            .show(context);
      } on ClientAlreadyExistsException {
        Navigator.of(context).pop();
        MotionToast.error(
            title: Text(
              LocaleKeys.error.tr(),
              style: textStyle,
            ),
            description: Text(
              LocaleKeys.client_exists.tr(),
              style: textStyle,
            )).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.add_client.tr(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Little of space
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
            // Little space betwen the formm to the title
            const SizedBox(
              height: 20,
            ),
            ClientForm(clientFormController: clientFormController),
            TextButton(
              onPressed: () async =>
                  await addButtonOnPressed(MediaQuery.of(context).size),
              child: Text(
                LocaleKeys.add_client_button.tr(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

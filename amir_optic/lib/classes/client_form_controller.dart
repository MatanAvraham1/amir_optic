import 'package:amir_optic/models/client.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:uuid/uuid.dart';

class ClientFormController extends PropertyChangeNotifier<String> {
  late Client client;
  bool enabled;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ClientFormController({
    Client? initialClient,
    this.enabled = true,
  }) {
    if (initialClient == null) {
      client = Client(
          firstName: "",
          lastName: "",
          phoneNumbers: [""],
          id: "",
          address: "",
          hmo: "",
          comments: "",
          uid: const Uuid().v1());
    } else {
      client = initialClient;
    }
  }

  bool validate() {
    return formKey.currentState!.validate();
  }

  void changeEnabledMode(bool enabled) {
    this.enabled = enabled;
    notifyListeners("changeEnabledMode");
  }
}

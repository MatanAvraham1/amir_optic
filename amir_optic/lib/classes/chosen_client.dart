import 'package:amir_optic/models/client.dart';
import 'package:flutter/material.dart';

class ChosenClient extends ChangeNotifier {
  Client? selectedClient;

  void unsSelectClient() {
    selectedClient = null;
    notifyListeners();
  }

  void selectClient(Client client) async {
    // TODO: check that
    unsSelectClient();
    await Future.delayed(const Duration(milliseconds: 5));
    selectedClient = client;
    notifyListeners();
  }
}

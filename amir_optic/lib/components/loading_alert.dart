import 'package:amir_optic/components/loading_indicator.dart';
import 'package:flutter/material.dart';

void showLoadingAlertDialog(BuildContext context,
    {bool useRootNavigator = false}) {
  showDialog(
    useRootNavigator: useRootNavigator,
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const LoadingAlertDialog();
    },
  );
}

class LoadingAlertDialog extends StatefulWidget {
  const LoadingAlertDialog({Key? key}) : super(key: key);

  @override
  State<LoadingAlertDialog> createState() => _LoadingAlertDialogState();
}

class _LoadingAlertDialogState extends State<LoadingAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: LoadingIndicator(),
    );
  }
}

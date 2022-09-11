import 'package:amir_optic/constants/constants.dart';
import 'package:flutter/material.dart';

class NavigatorsKeys {
  final _homePageNavigatorKey = GlobalKey<NavigatorState>();
  final _clientPageNavigatorKey = GlobalKey<NavigatorState>();
  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  get rootNavigatorKey {
    return _rootNavigatorKey;
  }

  GlobalKey<NavigatorState> homePageNavigatorKey(BuildContext context) {
    if (kIsSplitedScreen) {
      return _homePageNavigatorKey;
    }

    return _rootNavigatorKey;
  }

  GlobalKey<NavigatorState> clientPageNavigatorKey(BuildContext context) {
    if (kIsSplitedScreen) {
      return _clientPageNavigatorKey;
    }

    return _rootNavigatorKey;
  }
}

import 'package:amir_optic/components/loading_indicator.dart';
import 'package:amir_optic/screens/error_page.dart';
import 'package:amir_optic/screens/home/home_page.dart';
import 'package:amir_optic/screens/login_page.dart';
import 'package:amir_optic/translations/locale_keys.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:amir_optic/firebase_options.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future _initialization() async {
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return ErrorPage(
            error: snapshot.error,
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ErrorPage(error: snapshot.error);
              }

              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data == null) {
                  return const LoginPage();
                } else {
                  return const HomePage();
                }
              }

              return Scaffold(
                body: LoadingIndicator(
                  title: LocaleKeys.connect_to_server.tr(),
                ),
              );
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: LoadingIndicator(
            title: LocaleKeys.connect_to_server.tr(),
          ),
        );
      },
    );
  }
}

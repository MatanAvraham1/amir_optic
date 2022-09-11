import 'package:amir_optic/components/change_locale_button.dart';
import 'package:amir_optic/components/loading_alert.dart';
import 'package:amir_optic/translations/locale_keys.g.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:theme_provider/theme_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isFormValidate = false;
  bool _passwordVisible = false;

  String email = "";
  String password = "";

  Future login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isFormValidate = false;
      });

      try {
        // Shows loading dialog
        showLoadingAlertDialog(context);

        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          Navigator.of(context).pop(); // Closes loading dialog
        });
      } catch (e) {
        // Closes loading dialog
        Navigator.of(context).pop();

        if (e.toString() ==
            "[firebase_auth/invalid-email] The email address is badly formatted.") {
          AwesomeDialog(
            width: 400,
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.ERROR,
            body: Center(
              child: Text(
                LocaleKeys.invalid_email.tr(),
                style: const TextStyle(fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () {},
          ).show();
        } else if (e.toString() ==
                "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted." ||
            e.toString() ==
                "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
          AwesomeDialog(
            width: 400,
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.ERROR,
            body: Center(
              child: Text(
                LocaleKeys.worng_login_deatils.tr(),
                style: const TextStyle(fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () {},
          ).show();
        }
      }
    } else {
      setState(() {
        isFormValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(ThemeProvider.themeOf(context).id == "light_theme"
              ? "assets/images/light_background.jpg"
              : "assets/images/dark_background.jpg"),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                CycleThemeIconButton(),
                                ChangeLocaleButton(),
                              ]);
                        },
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.settings)),
          title: Text(
            LocaleKeys.login.tr(),
          ),
          centerTitle: true,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return _buildLoginForm();
  }

  Widget _buildLoginForm() {
    return Center(
      child: SingleChildScrollView(
        // To Avoid bottom overflowed
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(14)),
          ),
          width: 300,
          height: isFormValidate ? 440 : 370,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LocaleKeys.welcome.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 32),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                LocaleKeys.please_connect_to_your_user.tr(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.field_empty_error.tr();
                        }
                      },
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        icon: const Icon(Icons.email),
                        labelText: LocaleKeys.email.tr(),
                        hintText: LocaleKeys.email.tr(),
                      ),
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.field_empty_error.tr();
                        }
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: !_passwordVisible,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: Icon(!_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        icon: const Icon(Icons.security),
                        labelText: LocaleKeys.password.tr(),
                        hintText: LocaleKeys.password.tr(),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                      ),
                      onPressed: login,
                      child: Text(
                        LocaleKeys.login_button.tr(),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

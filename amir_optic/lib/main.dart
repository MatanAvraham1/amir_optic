import 'package:amir_optic/classes/navigators_keys.dart';
import 'package:amir_optic/constants/themes.dart';
import 'package:amir_optic/classes/chosen_client.dart';
import 'package:amir_optic/firebase_options.dart';
import 'package:amir_optic/screens/loading_page.dart';
import 'package:amir_optic/translations/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

// TODO: works on themes and localizations
// TODO: add SHA1 to firebase project
// TODO: add splash screen
// TODO: add icon

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en'),
      Locale('he'),
    ],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    assetLoader: const CodegenLoader(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        String? savedTheme = await previouslySavedThemeFuture;

        if (savedTheme != null) {
          // If previous theme saved, use saved theme
          controller.setTheme(savedTheme);
        } else {
          // If previous theme not found, use platform default
          Brightness platformBrightness =
              SchedulerBinding.instance.window.platformBrightness;
          if (platformBrightness == Brightness.dark) {
            controller.setTheme('dark_theme');
          } else {
            controller.setTheme('light_theme');
          }
          // Forget the saved theme(which were saved just now by previous lines)
          controller.forgetSavedTheme();
        }
      },
      themes: [
        lightTheme,
        darkTheme,
      ],
      child: ThemeConsumer(
        child: Builder(builder: (themeContext) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ChosenClient>(
                create: (context) => ChosenClient(),
              ),
              Provider<NavigatorsKeys>(create: (context) => NavigatorsKeys()),
            ],
            builder: (context, child) {
              return MaterialApp(
                navigatorKey:
                    Provider.of<NavigatorsKeys>(context, listen: false)
                        .rootNavigatorKey,
                theme: ThemeProvider.themeOf(themeContext).data,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                title: 'Amir Optic',
                home: const LoadingPage(),
              );
            },
          );
        }),
      ),
    );
  }
}

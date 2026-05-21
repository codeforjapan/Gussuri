import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gussuri/about_me.dart';
import 'package:gussuri/base.dart';
import 'package:gussuri/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:intl/intl_standalone.dart';
import 'gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      runApp(MaterialApp(
        home: Scaffold(body: Center(child: SelectableText('Firebase init error:\n$e'))),
      ));
      return;
    }
  } catch (e, s) {
    runApp(MaterialApp(
      home: Scaffold(body: Center(child: SelectableText('Firebase init error:\n$e\n$s'))),
    ));
    return;
  }
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  runApp(
    ChangeNotifierProvider(
      create: (context) => CalenderState(),
      child: Gussuri(showOnboarding: !hasSeenOnboarding),
    ),
  );
}

class Gussuri extends StatelessWidget {
  final bool showOnboarding;
  const Gussuri({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) {
          return MaterialApp(
            title: 'Gussuri',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: false),
            home: showOnboarding ? const AboutMe(isOnboarding: true) : const Base(),
          );
        });
  }
}

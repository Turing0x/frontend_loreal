import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:frontend_loreal/assets/themes/dark_theme.dart';
import 'package:frontend_loreal/assets/themes/light_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/router/on_generate_route.dart';
import 'config/router/routes.dart';
import 'config/server/http/methods.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  final rutIni = await rutaInicial();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(ProviderScope(
    child: MyApp(
      rutaInicial: rutIni,
      savedThemeMode: savedThemeMode
    ),
  ));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.rutaInicial, 
    required this.savedThemeMode,
  });
  final String rutaInicial;
  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (light, dark) {
        return MaterialApp(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          theme: light,
          darkTheme: dark,
          title: 'Loreal',
          initialRoute: rutaInicial,
          routes: appRoutes,
          onGenerateRoute: onGenerateRoute
        );
      },
    );
  }
}

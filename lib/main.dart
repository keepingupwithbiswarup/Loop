import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopedin/firebase_options.dart';

import 'package:loopedin/pages/loginpage.dart';
import 'package:loopedin/pages/splashpage.dart';
import 'package:loopedin/pages/userprofile.dart';
import 'package:loopedin/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var prefs = await SharedPreferences.getInstance();
  bool? isAuthenticated = prefs.getBool('LoggedIn') ?? false;

  runApp(
    ProviderScope(
      child: MyApp(isAuthenticated: isAuthenticated),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  const MyApp({super.key, required this.isAuthenticated});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: isAuthenticated ? const ProfilePage() : const SplashPage());
  }
}

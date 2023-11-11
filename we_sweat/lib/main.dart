import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:we_sweat/pages/home.dart';
import 'package:we_sweat/pages/splash.dart';
import 'package:we_sweat/providers/profile_provider.dart';
import 'package:we_sweat/theme/theme_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  if (apnsToken != null) {
    final fcmToken =
        await FirebaseMessaging.instance.getToken(vapidKey: apnsToken);
    print(fcmToken);
  }
  if (Platform.isIOS) {
    FirebaseMessaging.instance.requestPermission();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeManager(),
        builder: (context, _) {
          return Consumer<ThemeManager>(
              builder: (context, themeManager, child) {
            return MaterialApp(
                title: 'We Sweat',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: ProfileProvider(
                  child: SplashScreen(),
                ));
          });
        });
  }
}

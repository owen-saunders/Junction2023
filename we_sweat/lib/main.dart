import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:we_sweat/pages/splash.dart';
import 'package:we_sweat/providers/profile_provider.dart';
import 'package:we_sweat/services/messaging_service.dart';
import 'package:we_sweat/theme/theme_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

MessagingService _msgService = MessagingService();

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _msgService.init();

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(" --- background message received ---");
  print(message.notification!.title);
  print(message.notification!.body);
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
                  child: SplashScreen(
                    msgServ: _msgService,
                  ),
                ));
          });
        });
  }
}

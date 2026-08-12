import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initialize();
  runApp(const GearNestApp());
}

class GearNestApp extends StatelessWidget {
  const GearNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GearNest',
      theme: AppTheme.theme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

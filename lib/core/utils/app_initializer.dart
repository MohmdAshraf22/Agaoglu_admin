import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tasks_admin/core/local/shared_prefrences.dart';
import 'package:tasks_admin/core/services/service_locator.dart' as di;
import 'package:tasks_admin/core/utils/localization_manager.dart';
import 'package:tasks_admin/modules/main/ui/screens/dashboard_screen.dart';
import 'package:tasks_admin/modules/user/ui/screens/login_screen.dart';

import '../../modules/firebase_options.dart';

class AppInitializer {
  static Future<void> init() async {
    await CacheHelper.init();
    await LocalizationManager.init();
    await di.init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
  }

  static Widget getFirstScreen() {
    if (DateTime.now().isAfter(DateTime.parse("2025-03-16 06:23:26.609857"))) {
      return EmptyScreen();
    }
    return FirebaseAuth.instance.currentUser == null
        ? LoginScreen()
        : const AdminDashboardScreen();
  }
}

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "انتهت فترة التجربة .. يرجى التواصل مع المطورين",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

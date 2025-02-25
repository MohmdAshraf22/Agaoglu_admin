import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:tasks_admin/core/local/shared_prefrences.dart';
import 'package:tasks_admin/core/services/service_locator.dart' as di;
import 'package:tasks_admin/core/utils/localization_manager.dart';
import 'package:tasks_admin/main.dart';
import 'package:tasks_admin/modules/main/ui/screens/dashboard_screen.dart';
import 'package:tasks_admin/modules/user/ui/screens/login_screen.dart';

import '../../firebase_options.dart';

class AppInitializer {
  static Future<void> init() async {
    await CacheHelper.init();
    await LocalizationManager.init();
    await di.init(); // Initialize the service locator
    FirebaseConstants.firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Widget getFirstScreen() => FirebaseAuth.instance.currentUser == null
      ? LoginScreen()
      : const AdminDashboardScreen();
}

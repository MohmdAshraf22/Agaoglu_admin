import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/local/shared_prefrences.dart';
import 'package:tasks_admin/core/services/service_locator.dart' as di;
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/utils/localization_manager.dart';
import 'package:tasks_admin/firebase_options.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/main/cubit/dashboard_cubit.dart';
import 'package:tasks_admin/modules/main/ui/screens/dashboard_screen.dart';
import 'package:tasks_admin/modules/user/cubit/user_cubit.dart';
import 'package:tasks_admin/modules/user/ui/screens/manage_workers_screen.dart';

class FirebaseConstants {
  static FirebaseApp? firebaseApp;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await LocalizationManager.init();
  await di.init(); // Initialize the service locator
  FirebaseConstants.firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => UserCubit.get()),
            BlocProvider<DashboardCubit>.value(value: DashboardCubit())
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: LocalizationManager.getCurrentLocale(),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            title: 'Task Management',
            theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: ColorManager.primary),
              inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
              buttonTheme: ButtonThemeData(
                height: 6.h,
                buttonColor: ColorManager.orange,
              ),
              appBarTheme: AppBarTheme(surfaceTintColor: Colors.white),
              useMaterial3: true,
            ),
            home: const AdminDashboard(),
          )),
    );
  }
}

/*
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: "admin@amdin.com", password: "123456")
      .then((v) async {
    await FirebaseFirestore.instance
        .collection("admins")
        .doc(v.user!.uid)
        .set({'id': v.user!.uid, 'name': "admin", "email": "admin@amdin.com"});
  });

 */

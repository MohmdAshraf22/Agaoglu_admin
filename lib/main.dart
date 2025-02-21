import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/local/shared_prefrences.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/utils/localization_manager.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/core/services/service_locator.dart' as di;
import 'package:tasks_admin/modules/task/data/repository/task_repo.dart';
import 'package:tasks_admin/modules/task/presentation/cubit/task_cubit.dart';
import 'package:tasks_admin/modules/task/presentation/screens/task_management.dart'; // Correct import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  await LocalizationManager.init();
  await di.init(); // Initialize the service locator
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) =>
          BlocProvider<TaskCubit>.value(
        value: TaskCubit(di.sl<TaskRepository>()),
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
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: ColorManager.primary),
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
          home: const TaskManagementScreen(),
        ),
      ),
    );
  }
}

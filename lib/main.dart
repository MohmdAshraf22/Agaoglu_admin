import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/services/service_locator.dart' as di;
import 'package:tasks_admin/core/utils/app_initializer.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/main/cubit/dashboard_cubit.dart';
import 'package:tasks_admin/modules/task/cubit/task_cubit.dart';
import 'package:tasks_admin/modules/task/data/repository/task_repo.dart';
import 'package:tasks_admin/modules/user/cubit/user_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.init();

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
            BlocProvider(
              create: (context) => TaskCubit(di.sl<TaskRepository>()),
            ),
            BlocProvider<DashboardCubit>.value(value: DashboardCubit())
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: Locale("tr"),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            title: 'Görev Yönetimi',
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
            home: AppInitializer.getFirstScreen(),
          )),
    );
  }
}

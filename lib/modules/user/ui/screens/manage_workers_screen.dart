import 'package:flutter/material.dart';
import 'package:tasks_admin/modules/user/cubit/user_cubit.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';

class ManageWorkersScreen extends StatelessWidget {
  const ManageWorkersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Worker> workers = [];
    UserCubit cubit = UserCubit();
    return const Placeholder();
  }
}

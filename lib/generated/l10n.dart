// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Please enter email`
  String get enterEmail {
    return Intl.message(
      'Please enter email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid email`
  String get enterValidEmail {
    return Intl.message(
      'Please enter valid email',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `forgot password?`
  String get forgotPassword {
    return Intl.message(
      'forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Submit Task`
  String get submit_task {
    return Intl.message('Submit Task', name: 'submit_task', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Task Description`
  String get task_description {
    return Intl.message(
      'Task Description',
      name: 'task_description',
      desc: '',
      args: [],
    );
  }

  /// `Task Title`
  String get task_title {
    return Intl.message('Task Title', name: 'task_title', desc: '', args: []);
  }

  /// `Enter task description`
  String get enter_task_description {
    return Intl.message(
      'Enter task description',
      name: 'enter_task_description',
      desc: '',
      args: [],
    );
  }

  /// `Enter task title`
  String get enter_task_title {
    return Intl.message(
      'Enter task title',
      name: 'enter_task_title',
      desc: '',
      args: [],
    );
  }

  /// `Please enter task title`
  String get please_enter_task_title {
    return Intl.message(
      'Please enter task title',
      name: 'please_enter_task_title',
      desc: '',
      args: [],
    );
  }

  /// `Select Worker`
  String get select_worker {
    return Intl.message(
      'Select Worker',
      name: 'select_worker',
      desc: '',
      args: [],
    );
  }

  /// `Please select a worker`
  String get please_select_a_worker {
    return Intl.message(
      'Please select a worker',
      name: 'please_select_a_worker',
      desc: '',
      args: [],
    );
  }

  /// `Choose a worker`
  String get choose_a_worker {
    return Intl.message(
      'Choose a worker',
      name: 'choose_a_worker',
      desc: '',
      args: [],
    );
  }

  /// `Due Date`
  String get due_date {
    return Intl.message('Due Date', name: 'due_date', desc: '', args: []);
  }

  /// `Select date`
  String get select_date {
    return Intl.message('Select date', name: 'select_date', desc: '', args: []);
  }

  /// `Search tasks...`
  String get search_tasks {
    return Intl.message(
      'Search tasks...',
      name: 'search_tasks',
      desc: '',
      args: [],
    );
  }

  /// `Not Accepted yet`
  String get not_accepted_yet {
    return Intl.message(
      'Not Accepted yet',
      name: 'not_accepted_yet',
      desc: '',
      args: [],
    );
  }

  /// `Delete Task`
  String get delete_task {
    return Intl.message('Delete Task', name: 'delete_task', desc: '', args: []);
  }

  /// `Are you sure you want to delete this task?`
  String get are_you_sure_you_want_to_delete_this_task {
    return Intl.message(
      'Are you sure you want to delete this task?',
      name: 'are_you_sure_you_want_to_delete_this_task',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Create Task`
  String get create_task {
    return Intl.message('Create Task', name: 'create_task', desc: '', args: []);
  }

  /// `Task Management`
  String get task_management {
    return Intl.message(
      'Task Management',
      name: 'task_management',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `In Progress`
  String get in_progress {
    return Intl.message('In Progress', name: 'in_progress', desc: '', args: []);
  }

  /// `Approved`
  String get approved {
    return Intl.message('Approved', name: 'approved', desc: '', args: []);
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message('Cancelled', name: 'cancelled', desc: '', args: []);
  }

  /// `Add Image`
  String get add_image {
    return Intl.message('Add Image', name: 'add_image', desc: '', args: []);
  }

  /// `Add Voice`
  String get add_voice {
    return Intl.message('Add Voice', name: 'add_voice', desc: '', args: []);
  }

  /// `Add Site`
  String get add_site {
    return Intl.message('Add Site', name: 'add_site', desc: '', args: []);
  }

  /// `Add Block`
  String get add_block {
    return Intl.message('Add Block', name: 'add_block', desc: '', args: []);
  }

  /// `Add Flat`
  String get add_flat {
    return Intl.message('Add Flat', name: 'add_flat', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Additional Files`
  String get additional_files {
    return Intl.message(
      'Additional Files',
      name: 'additional_files',
      desc: '',
      args: [],
    );
  }

  /// `Update Task`
  String get update_task {
    return Intl.message('Update Task', name: 'update_task', desc: '', args: []);
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Admin Panel`
  String get admin_panel {
    return Intl.message('Admin Panel', name: 'admin_panel', desc: '', args: []);
  }

  /// `Please enter password`
  String get enterPassword {
    return Intl.message(
      'Please enter password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Check your email`
  String get checkYourEmail {
    return Intl.message(
      'Check your email',
      name: 'checkYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `A password reset link has been sent to your email address`
  String get resetPasswordLinkSent {
    return Intl.message(
      'A password reset link has been sent to your email address',
      name: 'resetPasswordLinkSent',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Send Reset Link`
  String get sendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `Back to login`
  String get backToLogin {
    return Intl.message(
      'Back to login',
      name: 'backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Workers Management`
  String get workersManagement {
    return Intl.message(
      'Workers Management',
      name: 'workersManagement',
      desc: '',
      args: [],
    );
  }

  /// `Search workers...`
  String get searchWorkers {
    return Intl.message(
      'Search workers...',
      name: 'searchWorkers',
      desc: '',
      args: [],
    );
  }

  /// `Delete Worker`
  String get deleteWorker {
    return Intl.message(
      'Delete Worker',
      name: 'deleteWorker',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this worker?`
  String get deleteWorkerConfirmation {
    return Intl.message(
      'Are you sure you want to delete this worker?',
      name: 'deleteWorkerConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Admin Dashboard`
  String get adminDashboard {
    return Intl.message(
      'Admin Dashboard',
      name: 'adminDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Recent Tasks`
  String get recentTasks {
    return Intl.message(
      'Recent Tasks',
      name: 'recentTasks',
      desc: '',
      args: [],
    );
  }

  /// `Total Workers`
  String get totalWorkers {
    return Intl.message(
      'Total Workers',
      name: 'totalWorkers',
      desc: '',
      args: [],
    );
  }

  /// `Pending Tasks`
  String get pendingTasks {
    return Intl.message(
      'Pending Tasks',
      name: 'pendingTasks',
      desc: '',
      args: [],
    );
  }

  /// `Completed Tasks`
  String get completedTasks {
    return Intl.message(
      'Completed Tasks',
      name: 'completedTasks',
      desc: '',
      args: [],
    );
  }

  /// `No data found`
  String get noDataFound {
    return Intl.message(
      'No data found',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Create Worker`
  String get createWorker {
    return Intl.message(
      'Create Worker',
      name: 'createWorker',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Select Job`
  String get selectJob {
    return Intl.message('Select Job', name: 'selectJob', desc: '', args: []);
  }

  /// `Job Title`
  String get jobTitle {
    return Intl.message('Job Title', name: 'jobTitle', desc: '', args: []);
  }

  /// `Please enter name`
  String get enterName {
    return Intl.message(
      'Please enter name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `enter worker name`
  String get enterWorkerName {
    return Intl.message(
      'enter worker name',
      name: 'enterWorkerName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter phone number`
  String get enterPhone {
    return Intl.message(
      'Please enter phone number',
      name: 'enterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Worker added successfully`
  String get workerAddedSuccessfully {
    return Intl.message(
      'Worker added successfully',
      name: 'workerAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Surname`
  String get surName {
    return Intl.message('Surname', name: 'surName', desc: '', args: []);
  }

  /// `Please enter surname`
  String get enterSurname {
    return Intl.message(
      'Please enter surname',
      name: 'enterSurname',
      desc: '',
      args: [],
    );
  }

  /// `Edit Worker`
  String get editWorker {
    return Intl.message('Edit Worker', name: 'editWorker', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Worker updated successfully`
  String get workerUpdatedSuccessfully {
    return Intl.message(
      'Worker updated successfully',
      name: 'workerUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Leave empty to keep current`
  String get leaveEmptyToKeepCurrent {
    return Intl.message(
      'Leave empty to keep current',
      name: 'leaveEmptyToKeepCurrent',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `View Workers`
  String get viewWorkers {
    return Intl.message(
      'View Workers',
      name: 'viewWorkers',
      desc: '',
      args: [],
    );
  }

  /// `Edit Task`
  String get edit_task {
    return Intl.message('Edit Task', name: 'edit_task', desc: '', args: []);
  }

  /// `Assigned to`
  String get assignedTo {
    return Intl.message('Assigned to', name: 'assignedTo', desc: '', args: []);
  }

  /// `Please select a job`
  String get please_select_a_job {
    return Intl.message(
      'Please select a job',
      name: 'please_select_a_job',
      desc: '',
      args: [],
    );
  }

  /// `Select Job`
  String get select_job {
    return Intl.message('Select Job', name: 'select_job', desc: '', args: []);
  }

  /// `No workers for job`
  String get no_workers_for_job {
    return Intl.message(
      'No workers for job',
      name: 'no_workers_for_job',
      desc: '',
      args: [],
    );
  }

  /// `Please select a job first`
  String get select_job_first {
    return Intl.message(
      'Please select a job first',
      name: 'select_job_first',
      desc: '',
      args: [],
    );
  }

  /// `View Tasks`
  String get viewTasks {
    return Intl.message('View Tasks', name: 'viewTasks', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'tr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

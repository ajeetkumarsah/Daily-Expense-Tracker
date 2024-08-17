import 'package:expense_tracker/blocs/auth_bloc/bloc.dart';
import 'package:expense_tracker/blocs/expense_bloc/bloc.dart';
import 'package:expense_tracker/blocs/expense_bloc/event.dart';
import 'package:expense_tracker/repositories/auth_repository.dart';
import 'package:expense_tracker/repositories/expense_repository.dart';
import 'package:expense_tracker/screens/dashboard_screen.dart';
import 'package:expense_tracker/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/login_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().requestExactAlarmPermission();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await NotificationService().scheduleDailyReminder();
// Check login state
  AuthRepository authRepository = AuthRepository();
  bool isLoggedIn = await authRepository.checkLoginState();
  int userId = await authRepository.getUserId();

  runApp(MyApp(isLoggedIn: isLoggedIn, userId: userId));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final int userId;
  final ExpenseRepository expenseRepository = ExpenseRepository();
  final AuthRepository authRepository = AuthRepository();

  MyApp({super.key, required this.isLoggedIn, required this.userId});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExpenseBloc>(
          create: (context) =>
              ExpenseBloc(expenseRepository)..add(FetchExpensesEvent(userId)),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Personal Expense Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: isLoggedIn ? DashboardScreen(userId: userId) : LoginScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/new_report_screen/new_report_screen.dart';
import '../presentation/report_details_screen/report_details_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String login = '/login-screen';
  static const String dashboard = '/dashboard';
  static const String newReport = '/new-report-screen';
  static const String reportDetails = '/report-details-screen';
  static const String registration = '/registration-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    dashboard: (context) => const Dashboard(),
    newReport: (context) => const NewReportScreen(),
    reportDetails: (context) => const ReportDetailsScreen(),
    registration: (context) => const RegistrationScreen(),
    // TODO: Add your other routes here
  };
}

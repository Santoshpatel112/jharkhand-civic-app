import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme_config.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/reports/create_report_screen.dart';
import 'screens/reports/my_reports_screen.dart';
import 'screens/reports/report_detail_screen.dart';
import 'screens/home/profile_screen.dart';
import 'screens/settings/settings_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Jharkhand Civic Reporter',
          debugShowCheckedModeBanner: false,
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/create-report': (context) => const CreateReportScreen(),
            '/my-reports': (context) => const MyReportsScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/report-detail') {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => ReportDetailScreen(
                  reportId: args['reportId'],
                ),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
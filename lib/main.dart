import 'package:flutter/material.dart';
import 'package:mobile_project/views/auth/login_screen.dart';
import 'package:mobile_project/views/auth/register_screen.dart';
import 'package:mobile_project/views/donor/donor_home.dart';
import 'package:mobile_project/views/map/resource_map.dart';
import 'package:mobile_project/views/recipient/recipient_home.dart';
import 'package:mobile_project/views/splash_screen.dart';
import 'package:mobile_project/core/routes.dart';
import 'package:mobile_project/core/theme.dart';

void main() {
  runApp(const UnitedHopeApp());
}

class UnitedHopeApp extends StatelessWidget {
  const UnitedHopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'United Hope',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.donorHome: (context) => const DonorHomeScreen(),
        AppRoutes.recipientHome: (context) => const RecipientHomeScreen(),
        AppRoutes.resourceMap: (context) => const ResourceMapScreen(),
      },
      onUnknownRoute:
          (settings) => MaterialPageRoute(
            builder:
                (context) => Scaffold(
                  appBar: AppBar(title: const Text('Error')),
                  body: const Center(child: Text('Page not found')),
                ),
          ),
      debugShowCheckedModeBanner: false,
    );
  }
}

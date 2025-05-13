import 'package:flutter/material.dart';
import 'package:mobile_project/features/admin/admin_home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mobile_project/core/theme/theme.dart';
import 'package:mobile_project/core/utils/routes.dart';
import 'package:mobile_project/core/widgets/donation_all_page.dart';
import 'package:mobile_project/core/widgets/recipient_all_pages.dart';
import 'package:mobile_project/features/auth/login_screen.dart';
import 'package:mobile_project/features/auth/register_screen.dart';
import 'package:mobile_project/features/splash/splash_screen.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://wmcwbyprpsmfhbcbryje.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtY3dieXBycHNtZmhiY2JyeWplIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYzNjQyMDMsImV4cCI6MjA2MTk0MDIwM30.hg2juPoCQmaaQpLI_RI3OZo0n6v1eJxLsy9OQhkcZyY',
  );

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
        AppRoutes.donorHome: (context) => const DonationAllPage(),
        AppRoutes.recipientHome: (context) => const RecipientAllPages(),
        AppRoutes.admin: (context) => const AdminHomeScreen(),
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

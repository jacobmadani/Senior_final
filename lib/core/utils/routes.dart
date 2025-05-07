import 'package:flutter/material.dart';
import 'package:mobile_project/features/auth/login_screen.dart';
import 'package:mobile_project/features/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String donorHome = '/donor-home';
  static const String recipientHome = '/recipient-home';
  static const String intermediaryHome = '/intermediary-home';
  static const String resourceMap = '/resource-map';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Page not found')),
        );
      },
    );
  }
}

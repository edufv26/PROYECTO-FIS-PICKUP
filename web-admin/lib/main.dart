import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cafeteria_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CafeteriaProvider()),
      ],
      child: const TeseCafeteriaAdminApp(),
    ),
  );
}

class TeseCafeteriaAdminApp extends StatelessWidget {
  const TeseCafeteriaAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuth = context.watch<AuthProvider>().isAuthenticated;

    return MaterialApp(
      title: 'TESE-Eats | Panel de Cafeterías',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF800020)),
        useMaterial3: true,
      ),
      home: isAuth ? const DashboardScreen() : const LoginScreen(),
    );
  }
}
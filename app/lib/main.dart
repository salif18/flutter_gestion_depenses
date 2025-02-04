import 'package:flutter/material.dart';
import 'package:gestionary/providers/statistic_provider.dart';
import 'package:gestionary/providers/theme_provider.dart';
import 'package:gestionary/routes/splash_screen.dart';
import 'package:gestionary/screens/auth/login.dart';
import 'package:gestionary/providers/auth_provider.dart';
import 'package:gestionary/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  //charger le theme automatiquement au demarrage de l'app
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.loadStatus();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserInfosProvider()),
        ChangeNotifierProvider(create: (context) => StatisticsProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // themeMode:ThemeMode.system,
      home: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<String?>(
            future: provider.token(),
            builder: (context, snapshot) {
              final token = snapshot.data;
              if (token != null && token.isNotEmpty) {
                return const SplashScreen();
              } else {
                return const MyLogin();
              }
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './views/screens/login/login_view.dart';
import './core/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OBIX',
      theme: AppTheme.lightTheme, // usamos un tema personalizado
      home: const LoginView(), // primera vista que carga
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('en', 'US'), // Inglés
      ],
      locale: const Locale('es', 'ES'), // Idioma por defecto
    );
  }
}

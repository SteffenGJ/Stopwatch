import 'package:flutter/material.dart';
import 'package:stopwatch/login_screen.dart';
import 'package:stopwatch/stopwatch.dart';

/**
 * 
 * 
 * 
 * VIRKER IKKE. NÅR MAN HOTRELOADER APPEN MENS MAN ER INDE PÅ STOPWATCH KOMMER DER EN EXCEPTIOJ. NOGET MED STRING OG NULL
 * 
 * 
 * 
 * 
 */

void main() {
  runApp(const StopWatchApp());
}

class StopWatchApp extends StatelessWidget {
  const StopWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      routes: {
        LoginScreen.route: (context) => LoginScreen(),
        StopWatch.route: (context) => StopWatch(),
      },
      initialRoute: "/",
    );
  }
}

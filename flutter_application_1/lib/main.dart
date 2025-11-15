import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/history_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HistoryProvider(),
      child: const StrawberryCheckApp(),
    ),
  );
}

class StrawberryCheckApp extends StatelessWidget {
  const StrawberryCheckApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrawberryCheck',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

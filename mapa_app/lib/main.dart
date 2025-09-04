import 'package:flutter/material.dart';
import 'pages/home_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InfraestruturaEmFalta',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.deepPurple.shade50,
      ),
      home: const HomePage(), // Página inicial atualizada
      debugShowCheckedModeBanner: false,
    );
  }
}

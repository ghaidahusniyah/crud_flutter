import 'package:flutter/material.dart';
import 'package:crud_flutter/screens/login_screen.dart';
import 'package:crud_flutter/screens/register_screen.dart';
import 'package:crud_flutter/screens/dashboard_screen.dart';
import 'package:crud_flutter/screens/materi_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Materi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => DashboardScreen(
              name: 'User',
              email: 'Email', // Default dummy email value
            ), // Default dummy value
        '/materi': (context) => MateriScreen(),
      },
    );
  }
}

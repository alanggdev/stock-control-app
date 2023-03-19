import 'package:flutter/material.dart';
import 'package:stock_control/screens/auth_screen.dart';
import 'package:stock_control/screens/sign_in.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/sign_in' : ((context) => const SignIn())
      },
      home: const AuthScreen(),
    );
  }
}
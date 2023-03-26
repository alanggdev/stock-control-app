import 'package:flutter/material.dart';
import 'package:stock_control/screens/auth_screen.dart';
import 'package:stock_control/screens/sign_in_screen.dart';
import 'package:stock_control/screens/sign_up_screen.dart';

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
        '/auth_scren' : ((context) => const AuthScreen()),
        '/sign_in' : ((context) => const SignIn()),
        '/sign_up' : ((context) => const SignUp()),
      },
      home: const AuthScreen(),
    );
  }
}
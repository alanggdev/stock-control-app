import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stock_control/screens/components/buttons.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/images/logo.png', width: 250),
                      ),
                    ),
                    const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      '¡Bienvenido!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff40bcd8),
                      ),
                    ),
                  )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Center(
                    child: authButton(context, 'Iniciar Sesión', '/sign_in', FontAwesomeIcons.rightToBracket),
                  ),
                  Center(
                    child: authButton(context, 'Crear Cuenta', '/sign_up', FontAwesomeIcons.userPlus),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

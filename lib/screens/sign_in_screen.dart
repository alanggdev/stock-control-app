import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stock_control/screens/components/app_bar.dart';
import 'package:stock_control/screens/components/buttons.dart';
import 'package:stock_control/screens/components/input_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final usernameController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarAuthScreen('Iniciar Sesión'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child:
                            Image.asset('assets/images/logo.png', width: 250),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      '¡Bienvenido de vuelta!',
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
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 2),
                      child: inputLabel('Nombre de Usuario'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: textField('Usuario', usernameController),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: inputLabel('Contraseña'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: textField('Clave', passController),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: signInButton(context, usernameController, passController),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     const Text("¿Olvidaste tu contraseña?"),
                    //     TextButton(
                    //       onPressed: () {},
                    //       child: const Text(
                    //         'Recuperar Ahora',
                    //         style: TextStyle(
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.bold,
                    //             color: Color(0xfff90024)),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: dividerLine(),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Continuar con Google',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Color de fondo del botón
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

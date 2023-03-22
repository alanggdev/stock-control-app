// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stock_control/services/auth_request.dart';

Padding authButton(
    BuildContext context, String title, String route, IconData icon) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton.icon(
        icon: FaIcon(
          icon,
          color: Colors.white,
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xffff8e00),
          minimumSize: const Size(double.infinity, 50),
          shape: (RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          )),
        ),
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        label: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    ),
  );
}

SizedBox signInButton(
  BuildContext context,
  TextEditingController usernameController,
  TextEditingController passController,
) {
  return SizedBox(
    width: 150,
    height: 40,
    child: TextButton.icon(
      icon: const FaIcon(
        FontAwesomeIcons.rightToBracket,
        color: Colors.white,
      ),
      onPressed: () {
        if (usernameController.text.isEmpty || passController.text.isEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Campos vacíos', style: TextStyle(fontWeight: FontWeight.bold),),
                content: const Text(
                    'Por favor, ingrese su nombre de usuario y contraseña'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          signInUsername(
              context, usernameController.text, usernameController.text);
          Navigator.pushReplacementNamed(context, '/list_screen');
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xffff8e00),
        shape: (RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        )),
      ),
      label: const Text(
        'Ingresar',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),
  );
}

SizedBox signUpButton(
    TextEditingController usernameController,
    TextEditingController emailController,
    TextEditingController passController,
    TextEditingController confirmPassController) {
  return SizedBox(
    width: 150,
    height: 40,
    child: TextButton.icon(
      icon: const FaIcon(
        FontAwesomeIcons.userPlus,
        color: Colors.white,
      ),
      onPressed: () {
        print('Sign Up Data:');
        print(usernameController.text);
        print(emailController.text);
        print(passController.text);
        print(confirmPassController.text);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xffff8e00),
        shape: (RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        )),
      ),
      label: const Text(
        'Registrar',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),
  );
}

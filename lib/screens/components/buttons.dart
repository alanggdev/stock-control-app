// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

SizedBox signInButton(TextEditingController usernameController, TextEditingController passController) {
  return SizedBox(
    width: 150,
    height: 40,
    child: TextButton.icon(
      icon: const FaIcon(
        FontAwesomeIcons.rightToBracket,
        color: Colors.white,
      ),
      onPressed: () {
        print('Sign In Data:');
        print(usernameController.text);
        print(passController.text);
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

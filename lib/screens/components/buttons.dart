import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Padding authButton(String title, String route, IconData icon) {
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
        onPressed: () {},
        label: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    ),
  );
}

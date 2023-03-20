import 'package:flutter/material.dart';

AppBar appBarAuthScreen(String title) {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Image.asset(
          "assets/images/icon.png",
          width: 20,
        ),
      ],
    ),
    backgroundColor: const Color(0xff9cc4e4),
  );
}

Row dividerLine() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Expanded(
        child: Divider(
          thickness: 1,
          color: Colors.grey,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          "ó",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
      ),
      Expanded(
        child: Divider(
          thickness: 1,
          color: Colors.grey,
        ),
      ),
    ],
  );
}

Expanded titleMenu(IconData icon, String title) {
  return Expanded(
    flex: 0,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, size: 24), // El icono que desea agregar
          const SizedBox(width: 10), // Separación entre el icono y el texto
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    ),
  );
}

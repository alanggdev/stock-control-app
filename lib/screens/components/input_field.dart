import 'package:flutter/material.dart';

Row inputLabel(String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xff1b325f),
        ),
      ),
    ],
  );
}

TextField textField(String text, TextEditingController fieldContoller) {
  return TextField(
    controller: fieldContoller,
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color.fromARGB(173, 219, 219, 219),
      hintText: text,
      enabledBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: Color(0xff40bcd8), width: 5),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: Color(0xffff8e00), width: 10),
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}

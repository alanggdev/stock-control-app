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
      fillColor: Colors.grey[300],
      hintStyle: TextStyle(color: Colors.grey[800]),
      hintText: text,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}

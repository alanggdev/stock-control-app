import 'package:flutter/material.dart';

SafeArea inventoryLabel(BuildContext context, IconData icon, String title, Map<String, dynamic> data) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        height: 60,
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(width: 2, color: Colors.grey),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/inv_screen', arguments: data);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    const SizedBox(width: 15),
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.keyboard_double_arrow_right),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

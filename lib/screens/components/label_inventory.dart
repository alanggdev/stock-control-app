import 'package:flutter/material.dart';
import 'package:stock_control/services/inv_request.dart';

SafeArea inventoryLabel(BuildContext context, IconData icon, String title,
    Map<String, dynamic> data) {
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
            // Navigator.pushNamed(context, '/inv_screen', arguments: data);
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

Future<dynamic> createInventory(BuildContext context) {
  TextEditingController nameInvController = TextEditingController();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: const [
            Icon(
              Icons.create,
            ), // Agrega un icono de advertencia al lado del título
            SizedBox(width: 10), // Agrega un espacio entre el icono y el texto
            Text(
              'Añadir Inventario',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: TextField(
          controller: nameInvController,
          maxLength: 25, // Limita el número de caracteres a 25
          decoration: const InputDecoration(
            hintText: 'Nombre del inventario',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              String text = nameInvController.text.trim();
              if (text.isNotEmpty) {
                if (text.length > 25) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('El texto no puede ser mayor a 25 caracteres'),
                    ),
                  );
                } else {
                 newInventory(context, text);
                  Navigator.of(context).pop(text);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'El nombre del inventario no puede estar vacío',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xffff8e00),
              shape: (RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )),
            ),
            child: const Text('Crear'),
          ),
        ],
      );
    },
  );
}

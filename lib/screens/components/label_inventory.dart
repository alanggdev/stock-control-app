import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_control/screens/inventory_screen.dart';
import 'package:stock_control/services/inv_request.dart';

Padding inventoryLabel(BuildContext context, IconData icon, String title,
    dynamic objeto, String accessToken) {
  return Padding(
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InventoryScreen(objeto, accessToken)));
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
  );
}

Future<dynamic> createInventory(
    BuildContext context, int idOwner, String accessToken) {
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
            onPressed: () async {
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
                  // Navigator.of(context).pop();
                  await newInventory(context, accessToken, text, idOwner);
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

Padding cardConfigSensible(BuildContext context, String title, String stitle,
    String action, String route, dynamic product, String accessToken) {
  return Padding(
    padding: const EdgeInsets.only(left: 8, right: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              stitle,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        OutlinedButton(
          onPressed: () {
            if (action == 'Eliminar') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Confirmación',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: const Text(
                        '¿Está seguro de que desea eliminar este elemento?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Colors.red), // borde del botón
                          backgroundColor:
                              Colors.red, // color de fondo del botón
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Eliminar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // Navigator.of(context).pop();
                          deleteInventory(context, accessToken, product['id']);
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red), // borde del botón
            backgroundColor: Colors.white, // color de fondo del botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            action,
            style: const TextStyle(
              color: Colors.red, // color del texto
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> addProductLabel(
    BuildContext context, String accessToken, int idInventory) {
  TextEditingController productController = TextEditingController();
  TextEditingController productCantController = TextEditingController();
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
              'Agregar producto',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          height: 125,
          child: Column(
            children: [
              TextField(
                controller: productController,
                maxLength: 25, // Limita el número de caracteres a 25
                decoration: const InputDecoration(
                  hintText: 'Nombre del producto',
                ),
              ),
              TextField(
                controller: productCantController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                  hintText: 'Cantidad del producto',
                ),
              ),
            ],
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
            onPressed: () async {
              String text = productController.text.trim();
              String cantText = productCantController.text.trim();
              int productCantInt;

              if (cantText.isNotEmpty) {
                try {
                  productCantInt = int.parse(cantText);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('La cantidad debe ser un número entero.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return; // Salir de la función si no se puede convertir a int.
                }
                if (productCantInt <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('La cantidad debe ser mayor a cero.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return; // Salir de la función si es menor o igual a cero.
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('La cantidad no puede estar vacía.'),
                    backgroundColor: Colors.red,
                  ),
                );
                return; // Salir de la función si está vacía.
              }

              if (text.isNotEmpty && text.length <= 25) {
                addProduct(
                    context, accessToken, idInventory, text, productCantInt);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'El nombre del producto no puede estar vacío o superar los 25 caracteres.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    },
  );
}

Future<dynamic> removeProductLabel(BuildContext context, String accessToken,
    int idInventory, String nameProduct) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Está seguro que desea eliminar el producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red), // borde del botón
              backgroundColor: Colors.white, // color de fondo del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              removeProduct(context, accessToken, idInventory, nameProduct);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.red, // color del texto
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

import 'package:stock_control/screens/inventory_screen.dart';
import 'package:stock_control/services/data.dart';

String baseURL = 'http://3.138.119.212';

Future<dynamic> getInventory(
    BuildContext context, String accessToken, int idInventory) async {
  dynamic inventory = [];
  final dio = Dio();

  await dio
      .get(
    '$baseURL/api/inventory/detail/$idInventory',
    options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"}),
  )
      .then(((response) {
    dynamic args = jsonDecode(response.toString());
    if (args['pay_load'] != 'Not found') {
      print("Get detail");
      inventory = args['pay_load'];
    }
  })).catchError(((e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // ignore: prefer_const_constructors
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }));
  return inventory;
}

Future<List<dynamic>> getInventories(
    int isUser, String accessToken, BuildContext context) async {
  List<dynamic> listInv = [];

  await getInventoryPerOwner(isUser, accessToken, context).then(
    (listOwner) async {
      if (listOwner.isNotEmpty) {
        for (var inv in listOwner) {
          listInv.add(inv);
        }
      }
      await getInventoryPerAdmin(isUser, accessToken, context).then(
        (listAdmin) async {
          if (listAdmin.isNotEmpty) {
            for (var inv in listAdmin) {
              listInv.add(inv);
            }
          }
          await getInventoryPerSeller(isUser, accessToken, context).then(
            (listSeller) {
              if (listSeller.isNotEmpty) {
                for (var inv in listSeller) {
                  listInv.add(inv);
                }
              }
            },
          );
        },
      );
    },
  );

  return listInv;
}

Future<List<dynamic>> getInventoryPerOwner(
    int idOwner, String accessToken, BuildContext context) async {
  List<dynamic> listInvOwner = [];

  final dio = Dio();

  await dio
      .get(
    '$baseURL/api/inventory/owner/$idOwner',
    options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"}),
  )
      .then(((response) {
    dynamic args = jsonDecode(response.toString());
    if (args['pay_load'] != 'Not found') {
      print("GET DETAIL PER OWNER");
      listInvOwner = args['pay_load'];
    }
  })).catchError(((e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // ignore: prefer_const_constructors
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }));
  return listInvOwner;
}

Future<List<dynamic>> getInventoryPerAdmin(
    int idAdmin, String accessToken, BuildContext context) async {
  List<dynamic> listInvAdmin = [];

  final dio = Dio();

  await dio
      .get(
    '$baseURL/api/inventory/admin/$idAdmin',
    options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"}),
  )
      .then(((response) {
    dynamic args = jsonDecode(response.toString());
    if (args['pay_load'] != 'Not found') {
      print("GET DETAIL PER ADMIN");
      listInvAdmin = args['pay_load'];
    }
  })).catchError(((e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // ignore: prefer_const_constructors
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }));
  return listInvAdmin;
}

Future<List<dynamic>> getInventoryPerSeller(
    int idSeller, String accessToken, BuildContext context) async {
  List<dynamic> listInvSeller = [];

  final dio = Dio();

  await dio
      .get(
    '$baseURL/api/inventory/seller/$idSeller',
    options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"}),
  )
      .then(((response) {
    dynamic args = jsonDecode(response.toString());
    if (args['pay_load'] != 'Not found') {
      print("GET DETAIL PER SELLER");
      listInvSeller = args['pay_load'];
    }
  })).catchError(((e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // ignore: prefer_const_constructors
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }));
  return listInvSeller;
}

Future<void> newInventory(
    BuildContext context, String accessToken, String name, int idOwner) async {
  List<String> productName = ["Producto"];
  List<int> product = [1];

  Dio dio = Dio();
  var data = {
    "name": name,
    "owner": idOwner,
    "products_name": productName,
    "products": product
  };

  await dio
      .post(
    '$baseURL/api/inventory/create/',
    options: Options(headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    }),
    data: jsonEncode(data),
  )
      .then(((response) {
    print("OK");
    dynamic args = jsonDecode(response.toString());
    dynamic product = {
      'id': args['pay_load']['id'],
      'name': args['pay_load']['name'],
      'products_name': args['pay_load']['products_name'],
      'products': args['pay_load']['products'],
      'owner': args['pay_load']['owner'],
      'admins': args['pay_load']['admins'],
      'sellers': args['pay_load']['sellers']
    };
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => InventoryScreen(product, accessToken)));
  })).catchError(((e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // ignore: prefer_const_constructors
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }));
}

Future<void> deleteInventory(
    BuildContext context, String accessToken, int idInventory) async {
  Dio dio = Dio();
  await dio
      .delete(
    '$baseURL/api/inventory/detail/$idInventory',
    options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"}),
  )
      .then(((response) {
    print("Deleted");
    // Navigator.of(context).pop();
    Navigator.of(context).popUntil((route) => route.isFirst);
  })).catchError(((e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }));
}

Future<void> addProduct(BuildContext context, String accessToken,
    int idInventory, String name, int cant) async {
  dynamic invDetail = await getInventory(context, accessToken, idInventory);

  List<dynamic> resProductsName = invDetail['products_name'];
  List<dynamic> resProducts = invDetail['products'];

  if (!resProductsName.contains(name)) {
    print("No existe el contenido");
    resProductsName.add(name);
    resProducts.add(cant);
    var data = {"products_name": resProductsName, "products": resProducts};

    Dio dio = Dio();

    await dio
        .patch(
      '$baseURL/api/inventory/detail/$idInventory',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      }),
      data: jsonEncode(data),
    )
        .then(((response) {
      print("Product Added");
      Navigator.pop(context);
    })).catchError(((e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Error',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }));
  } else {
    print("Ya existe el contenido");
  }
}

Future<void> removeProduct(BuildContext context, String accessToken,
    int idInventory, String nameProduct) async {
  dynamic invDetail = await getInventory(context, accessToken, idInventory);

  List<dynamic> resProductsName = invDetail['products_name'];
  List<dynamic> resProducts = invDetail['products'];

  int indexRemove = resProductsName.indexOf(nameProduct);
  print(indexRemove);

  if (indexRemove >= 0) {
    resProductsName.removeAt(indexRemove);
    resProducts.removeAt(indexRemove);

    var data = {"products_name": resProductsName, "products": resProducts};

    print(data);

    Dio dio = Dio();

    await dio
        .patch(
      '$baseURL/api/inventory/detail/$idInventory',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      }),
      data: jsonEncode(data),
    )
        .then(((response) {
      print("Product Deleted");
      Navigator.pop(context);
    })).catchError(((e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Error',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }));
  }
}

Future<void> updateCantProduct(
    BuildContext context, String accessToken, dynamic inventory) async {
  List<dynamic> resProductsName = inventory['products_name'];
  List<dynamic> resProducts = inventory['products'];
  int idInventory = inventory['id'];

  var data = {"products_name": resProductsName, "products": resProducts};

  Dio dio = Dio();

  await dio
      .patch(
    '$baseURL/api/inventory/detail/$idInventory',
    options: Options(headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    }),
    data: jsonEncode(data),
  )
      .then(((response) {
    print("Product Updated Cant");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Cambios guardados y actualizados',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber[800],
      ),
    );
  })).catchError(((e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }));
}

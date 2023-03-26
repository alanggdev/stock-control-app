import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

import 'package:stock_control/screens/inventory_screen.dart';

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
      print(args['pay_load'].toString());
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Producto eliminado, actualice la vista para ver los cambios.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.amber[800],
        ),
      );
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

Future<void> searchIdByUsername(BuildContext context, String accessToken,
    String username, int idInventory) async {
  final dio = Dio();

  await dio
      .get(
    '$baseURL/api/inventory/user/$username',
    options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"}),
  )
      .then(((response) {
    dynamic args = jsonDecode(response.toString());
    if (args['pay_load'] != 'Not found') {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Buscar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // ignore: prefer_const_constructors
            content: SizedBox(
              height: 130,
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Color.fromARGB(223, 221, 218, 218),
                        width: 2.0,
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(
                        username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Encontrado'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          addUserSeller(context, accessToken, idInventory,
                              int.parse(args['pay_load'].toString()));
                        },
                        style: OutlinedButton.styleFrom(
                          // borde del botón
                          backgroundColor: const Color(
                              0xffff8e00), // color de fondo del botón
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Vendedor',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          addUserAdmin(context, accessToken, idInventory,
                              int.parse(args['pay_load'].toString()));
                        },
                        style: OutlinedButton.styleFrom(
                          // borde del botón
                          backgroundColor: const Color(
                              0xffff8e00), // color de fondo del botón
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Gerente',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
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
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Buscar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // ignore: prefer_const_constructors
            content: SizedBox(
              height: 80,
              child: Center(
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                          color: Color.fromARGB(223, 221, 218, 218),
                          width: 2.0,
                        ),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        title: Text(
                          username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('No encontrado'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
            ],
          );
        },
      );
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
}

Future<List<String>> searchUsername(
    BuildContext context, String accessToken, dynamic listUsers) async {
  List<String> username = [];

  if (listUsers.isNotEmpty) {
    for (int userId in listUsers) {
      Dio dio = Dio();
      await dio
          .get(
        '$baseURL/api/inventory/username/$userId',
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"}),
      )
          .then(((response) {
        dynamic args = jsonDecode(response.toString());
        username.add(args['pay_load'].toString());
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
  }
  return username;
}

Future<void> addUserAdmin(BuildContext context, String accessToken,
    int idInventory, int idUser) async {
  dynamic invDetail = await getInventory(context, accessToken, idInventory);

  List<dynamic> resAdminsList = invDetail['admins'];

  if (!resAdminsList.contains(idUser)) {
    print("No existe el contenido");
    resAdminsList.add(idUser);
    var data = {"admins": resAdminsList};

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
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Usuario agregado, actualice la vista para ver los cambios.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
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
  } else {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Este usuario ya es miembro del inventario.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> removeUserAdmin(BuildContext context, String accessToken,
    int idInventory, String username) async {
  final dio = Dio();
  await dio
      .get(
    '$baseURL/api/inventory/user/$username',
    options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"}),
  )
      .then(
    (response) async {
      dynamic args = jsonDecode(response.toString());
      dynamic invDetail = await getInventory(context, accessToken, idInventory);
      List<dynamic> resAdminsList = invDetail['admins'];
      int indexRemove = resAdminsList.indexOf(args['pay_load']);
      resAdminsList.removeAt(indexRemove);
      var data = {"admins": resAdminsList};
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Usuario eliminado, actualice la vista para ver los cambios.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
          ),
        );
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
    },
  ).catchError(((e) {
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

Future<void> addUserSeller(BuildContext context, String accessToken,
    int idInventory, int idUser) async {
  dynamic invDetail = await getInventory(context, accessToken, idInventory);

  List<dynamic> resSellerList = invDetail['sellers'];

  if (!resSellerList.contains(idUser)) {
    print("No existe el contenido");
    resSellerList.add(idUser);
    var data = {"sellers": resSellerList};

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
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Usuario agregado, actualice la vista para ver los cambios.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
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
  } else {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Este usuario ya es miembro del inventario.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> removeUserSeller(BuildContext context, String accessToken,
    int idInventory, String username) async {
  final dio = Dio();
  await dio
      .get(
    '$baseURL/api/inventory/user/$username',
    options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"}),
  )
      .then(
    (response) async {
      dynamic args = jsonDecode(response.toString());
      dynamic invDetail = await getInventory(context, accessToken, idInventory);
      List<dynamic> resASellersList = invDetail['sellers'];
      int indexRemove = resASellersList.indexOf(args['pay_load']);
      resASellersList.removeAt(indexRemove);
      var data = {"sellers": resASellersList};
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Usuario eliminado, actualice la vista para ver los cambios.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
          ),
        );
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
    },
  ).catchError(((e) {
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

Future<dynamic> getUserInfo(
    BuildContext context, String accessToken) async {
  dynamic userInfo = [];
  final dio = Dio();

  await dio
      .get(
    '$baseURL/auth/user/',
    options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"}),
  )
      .then(((response) {
    dynamic args = jsonDecode(response.toString());
    print(args.toString());
    userInfo = args;
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
  return userInfo;
}
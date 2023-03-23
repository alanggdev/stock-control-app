import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

import 'package:stock_control/screens/inventory_screen.dart';

String baseURL = 'https://3480-2806-10ae-1b-3b05-487b-a1ec-327f-c6c6.ngrok.io';

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

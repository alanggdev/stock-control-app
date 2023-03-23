import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';

import 'package:stock_control/screens/list_screen.dart';

String baseURL = 'https://3480-2806-10ae-1b-3b05-487b-a1ec-327f-c6c6.ngrok.io';

Future<void> signInUsername(
    BuildContext context, String username, String password) async {
  Dio dio = Dio();
  var data = {"username": username, "password": password};
  await dio
      .post(
    '$baseURL/auth/login/',
    options:
        Options(headers: {HttpHeaders.contentTypeHeader: "application/json"}),
    data: jsonEncode(data),
  )
      .then(((response) {
    dynamic userData = jsonDecode(response.toString());
    // print(userData['user']);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ListScreen(userData['user'],
                userData['access_token'], userData['refresh_token'])));
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

Future<void> signOut(BuildContext context, String accessToken) async {
  Dio dio = Dio();
  var data = {};
  await dio
      .post(
    '$baseURL/auth/logout/',
    options: Options(headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    }),
    data: jsonEncode(data),
  )
      .then(((response) {
    Navigator.pushNamedAndRemoveUntil(context, '/auth_scren', (route) => false);
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
